#!/bin/sh

# Compare transaction rates between 5.5 and 5.6, as well as with standalone MySQL vs a 1 node PXC Cluster

#Vagrantfile-5.5  Vagrantfile-5.5-standalone  Vagrantfile-5.6  Vagrantfile-5.6-standalone



#vagrant destroy -f
#ln -sf Vagrantfile-5.6-multiregion-nosegment Vagrantfile
#vagrant up --provider=aws
#./vagrant-percona/pxc-bootstrap.sh
#./run_test.sh multiregion-nosegment

ln -sf Vagrantfile-5.6-multiregion Vagrantfile
vagrant provision
./run_test.sh multiregion-segment

#vagrant destroy -f
