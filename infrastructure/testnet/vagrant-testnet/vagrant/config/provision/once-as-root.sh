#!/usr/bin/env bash

#== Import script args ==

timezone=$(echo "$1")
commit=$(echo "$2")
ubuntu=$(echo "$3")

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
if [ ${ubuntu} = 'bento/ubuntu-18.04' ]
  then
    apt-get install -y curl dirmngr apt-transport-https lsb-release ca-certificates
    curl -sL https://deb.nodesource.com/setup_12.x | sudo -E bash -
fi
apt-get install -y software-properties-common unzip wget git make gcc libsodium-dev build-essential libdb-dev zlib1g-dev libtinfo-dev libtinfo5 sysvbanner psmisc libleveldb-dev libdb5.3-dev dnsutils sudo netcat nodejs docker docker-compose
npm install -g truffle@5.1.48

info "Cloning and initializing testnet related repositories..."
cd /home/vagrant
git clone https://github.com/alastria/test-environment.git
cd test-environment
git checkout ${commit}
cd infrastructure/testnet
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

info "Finished installing VM"
