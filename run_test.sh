#!/bin/bash

test_time=600

nodes=( node1 node2 node3 )

# Initialize test
echo "Initializing sysbench"
vagrant ssh ${nodes[0]} -c "/vagrant/tests/init_sysbench.sh"

# Start stats collection
echo "Starting stats collection"
for node in "${nodes[@]}" 
do
	vagrant ssh $node -c "rm -f /var/lib/pt-stalk/*; pt-stalk --no-stalk --run-time=$test_time --iterations=1 --prefix=$node > /dev/null" &
done

# Start sysbench
echo "Starting tests"
for node in "${nodes[@]}" 
do
	vagrant ssh $node -c "/vagrant/tests/run_sysbench.sh" > results/$node_sysbench.log &
	vagrant ssh $node -c "/vagrant/tests/run_sysbench.sh" > results/$node_sysbench.log &
done

echo "Sleeping until tests are done"
sleep $test_time

# Collect stalk data
echo "Collecting stats"
for node in "${nodes[@]}" 
do
	tmp_ssh_config=`mktemp`
	vagrant ssh-config $node > $tmp_ssh_config

	scp -F $tmp_ssh_config $node:/var/lib/pt-stalk/$node-* results

	rm -f $tmp_ssh_config
done
