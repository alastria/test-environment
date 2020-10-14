#!/usr/bin/env bash

#== Import script args ==

timezone=$(echo "$1")
domain=$(echo "$2")
frontendport=$(echo "$3")
backendport=$(echo "$4")

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

info "Updating OS software..."
apt-get update
apt-get upgrade -y

info "Installing software..."
apt-get install -y npm software-properties-common unzip wget git make gcc libsodium-dev build-essential libdb-dev zlib1g-dev libtinfo-dev libtinfo5 sysvbanner psmisc libleveldb-dev libdb5.3-dev dnsutils sudo netcat nodejs docker docker-compose
npm install -g truffle@5.1.48

info "Cloning and initializing testnet related repositories..."
cd /home/vagrant
git clone https://github.com/alastria/test-environment.git
cd test-environment
git checkout 33dc30bf0e78ea697479a55fec061d4f9a849f76 
cd infrastructure/testnet
bash bin/bootstrap.sh
cd /home/vagrant
git clone https://github.com/Councilbox/cbx-quorum-explorer.git
cd cbx-quorum-explorer
mkdir mongo_data_dir
bash -c "curl https://gist.githubusercontent.com/brunneis/f6ffc3898635f2ab5718f8ab0f5f6905/raw/83a39419fea1ac6acc53230d83320f337d9df3ad/docker-compose.yaml.template > docker-compose.yaml.template"
sed -n 'H;${x;s/^\n//;s/  http-api:/&\n    network_mode: "host"/;p;}' docker-compose.yaml.template | tee docker-compose.yaml.template 2>/dev/null
read -r -d '' env << EOF
QUORUM_ENDPOINTS=localhost:22000,localhost:22001,localhost:22002,localhost:22003,localhost:22005
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
