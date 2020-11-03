#!/usr/bin/env bash

#== Import script args ==

timezone=$(echo "$1")
commit=$(echo "$2")
ubuntu=$(echo "$3")
validator=$(echo "$4")
general=$(echo "$5")
faulty=$(echo "$6")

#== Bash helpers ==

function info {
  echo " "
  echo "--> $1"
  echo " "
}

#== Provision script ==

info "Provision-script user: `whoami`"
export DEBIAN_FRONTEND=noninteractive

info "Configuring timezone"
timedatectl set-timezone ${timezone} --no-ask-password

info "Configuring keyboard layout"
L='es' && sudo sed -i 's/XKBLAYOUT=\"\w*"/XKBLAYOUT=\"'$L'\"/g' /etc/default/keyboard

# info "Updating OS software..."
apt-get update
# apt-get upgrade -y

info "Installing software..."
    apt-get install -y curl dirmngr apt-transport-https lsb-release ca-certificates
    curl -sL https://deb.nodesource.com/setup_12.x | sudo -E bash -
apt-get install -y software-properties-common unzip wget git make gcc libsodium-dev build-essential libdb-dev zlib1g-dev libtinfo-dev libtinfo5 sysvbanner psmisc libleveldb-dev libdb5.3-dev dnsutils sudo netcat docker docker-compose nodejs
npm install -g keythereum@1.2.0

info "Cloning and initializing testnet related repositories..."
# git checkout ${commit}
cp /home/vagrant/test-environment/infrastructure/testnet/network /
cd /home/vagrant/test-environment/infrastructure/testnet
bash bin/bootstrap.sh
cd /home/vagrant
git clone https://github.com/Councilbox/cbx-quorum-explorer.git
cd cbx-quorum-explorer
mkdir mongo_data_dir
bash -c "curl https://raw.githubusercontent.com/alastria/test-environment/feature/tidyup-testnet/infrastructure/common/docker-compose.yaml.template > docker-compose.yaml.template"
read -r -d '' env << EOF
QUORUM_ENDPOINTS=localhost:22000,localhost:22001,localhost:22002,localhost:22003,localhost:22005
QUORUM_HOST=localhost
ENABLE_SSL=false
EXPLORER_PORT=8888
API_DOMAIN=localhost
MONGO_DATA_DIR=/home/vagrant/cbx-quorum-explorer/mongo_data_dir
API_PORT=
EXTERNAL_API_PORT=
WEBAPP_VERSION=alastria-telsius
EOF
echo "$env" > env.sh
bash build.sh
bash launch.sh

echo "Initializing testnet with ${validator} validator nodes, ${general} general nodes and ${faulty} nodes."
cd /home/vagrant/test-environment/infrastructure/testnet
bash bin/start_network.sh clean ${validator} ${general} --faulty-node ${faulty}
bash bin/stop_network.sh

info "Finished installing VM"
