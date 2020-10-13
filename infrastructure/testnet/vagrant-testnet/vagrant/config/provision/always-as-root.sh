#!/usr/bin/env bash

#== Bash helpers ==

function info {
  echo " "
  echo "--> $1"
  echo " "
}

#== Provision script ==

info "starting testnet"
# cd /usr/local/go-ethereum/test-environment/infrastructure/testnet #By an error in the provisioner, the test environment was installed here. Fixed. Added this for testing purposes
cd /home/vagrant/test-environment/infrastructure/testnet
bash bin/start_network.sh clean 2 3
bash bin/start_ethstats.sh
cd /home/vagrant/cbx-quorum-explorer
bash launch.sh