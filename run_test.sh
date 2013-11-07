#!/bin/sh

vagrant ssh node1 -c "/vagrant/tests/init_sysbench.sh"

# Start stats collection
vagrant ssh node1 -c "mysqladmin ext -i1 -c65" > results/node1_mysqladmin.log &
vagrant ssh node2 -c "mysqladmin ext -i1 -c65" > results/node2_mysqladmin.log &
vagrant ssh node3 -c "mysqladmin ext -i1 -c65" > results/node3_mysqladmin.log &


# Start sysbench
vagrant ssh node1 -c "/vagrant/tests/run_sysbench.sh" > results/node1_sysbench.log &
vagrant ssh node2 -c "/vagrant/tests/run_sysbench.sh" > results/node2_sysbench.log &
vagrant ssh node3 -c "/vagrant/tests/run_sysbench.sh" > results/node3_sysbench.log &
