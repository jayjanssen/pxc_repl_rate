#!/bin/bash

test_name=$1
test_time=$2

nodes=( node1 node2 node3 )
#nodes=`vagrant status | grep "running (" | awk '{print $1}'`

#nodes=( node1 )

# Clean out existing results
rm -rf results/$test_name

# Start stats gathering
echo "Starting tests"
for node in "${nodes[@]}" 
do
	mkdir -p results/$test_name/$node
	vagrant ssh $node -c "/vagrant/tests/gather_stats.sh $test_time" &
done

# Run test only on first node
vagrant ssh ${nodes[0]} -c "/vagrant/tests/run_sysbench.sh $test_time" > results/$test_name/sysbench.log &

echo "Sleeping until tests are done"
sleep $test_time

# Collect stalk data
echo "Collecting stats"
for node in "${nodes[@]}" 
do
	tmp_ssh_config=`mktemp`
	vagrant ssh-config $node > $tmp_ssh_config
	
	mkdir -p results/$test_name/$node
	scp -r -F $tmp_ssh_config $node:/tmp/pxc_test/* results/$test_name/$node/.

	rm -f $tmp_ssh_config
done
