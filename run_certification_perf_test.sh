#!/bin/sh

# Compare transaction rates between 5.5 and 5.6, as well as with standalone MySQL vs a 1 node PXC Cluster

#Vagrantfile-5.5  Vagrantfile-5.5-standalone  Vagrantfile-5.6  Vagrantfile-5.6-standalone



vagrant destroy -f
ln -sf Vagrantfile-5.5-standalone Vagrantfile
vagrant up
./run_test certify-5.5-control

vagrant destroy -f
ln -sf Vagrantfile-5.6-standalone Vagrantfile
vagrant up
./run_test certify-5.6-control


#Now PXC
vagrant destroy -f
ln -sf Vagrantfile-5.5 Vagrantfile
vagrant up node1
./run_test certify-5.5-pxc

vagrant destroy -f
ln -sf Vagrantfile-5.6 Vagrantfile
vagrant up node1
./run_test certify-5.6-pxc
