#!/usr/bin/env bash

#== Bash helpers ==

function info {
  echo " "
  echo "--> $1"
  echo " "
}

#== Provision script ==

info "Starting testnet"
cd /home/vagrant/test-environment/infrastructure/testnet
bash bin/start_network.sh restart ${validator} ${general} --faulty-node ${faulty}
# bash bin/start_ethstats.sh
cd /home/vagrant/cbx-quorum-explorer
bash launch.sh