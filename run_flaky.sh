#!/bin/bash

# Check throughput and node counts as the packet loss gradually increases on node3

#Vagrantfile-5.5  Vagrantfile-5.5-standalone  Vagrantfile-5.6  Vagrantfile-5.6-standalone


# Initialize Environment 
vagrant destroy -f
ln -sf Vagrantfile-5.6 Vagrantfile
vagrant up


# baseline
./vagrant-percona/pxc-bootstrap.sh

# Initialize test
echo "Initializing sysbench"
vagrant ssh ${nodes[0]} -c "/vagrant/tests/init_sysbench.sh"

./run_test.sh flakey-baseline 600

# Gradually increase the packet loss
#pkt_loss_pcts=( "0.01" "0.05" "0.10" "0.20" "0.50" )
pkt_loss_pcts=( "0.50" )

for pkt_loss_pct in "${pkt_loss_pcts[@]}" 
do
	echo "Setting node3's packet loss to $pkt_loss_pct"
	vagrant ssh node3 -c "iptables -A INPUT -s 192.168.70.0/24 -m statistic --mode random --probability $pkt_loss_pct -j DROP; 
iptables -A OUTPUT -d 192.168.70.0/24 -m statistic --mode random --probability $pkt_loss_pct -j DROP"
	
	echo "Starting test"
	./run_test.sh flakey-$pkt_loss_pct 600
	
	echo "Resetting node3's network"
	vagrant ssh node3 -c "iptables -F" 
	
	echo "Resetting cluster"
	./vagrant-percona/pxc-bootstrap.sh
	
	# Initialize test
	echo "Initializing sysbench"
	vagrant ssh ${nodes[0]} -c "/vagrant/tests/init_sysbench.sh"
done
