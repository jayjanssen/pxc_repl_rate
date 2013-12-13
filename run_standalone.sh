#!/bin/sh

# Compare transaction rates between 5.5 and 5.6, as well as with standalone MySQL vs a 1 node PXC Cluster

#Vagrantfile-5.5  Vagrantfile-5.5-standalone  Vagrantfile-5.6  Vagrantfile-5.6-standalone



vagrant destroy -f
ln -sf Vagrantfile-5.5-standalone Vagrantfile
vagrant up --provider=aws
./run_test.sh perf-5.5-control

vagrant destroy -f
ln -sf Vagrantfile-5.6-standalone Vagrantfile
vagrant up --provider=aws
./run_test.sh perf-5.6-control


vagrant destroy -f
