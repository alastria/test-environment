#!/bin/bash

#NODE_NAME=alastria-validator-01
#NODE_VERSION=v21.1.0
#NODE_KEY=nodekey01
#NODE_TYPE=validator
#NODE_PORT=21001

NODE_NAME=${1}
NODE_VERSION=${2}
NODE_KEY=${3}
NODE_TYPE=${4}
NODE_PORT=${5}

#apt-get update 
#apt-get -y install wget nano vim cron && apt-get -y autoremove && apt-get -y clean
#apt-get install -y golang

wget -O geth_${NODE_VERSION}_linux_amd64.tar.gz https://artifacts.consensys.net/public/go-quorum/raw/versions/${NODE_VERSION}/geth_${NODE_VERSION}_linux_amd64.tar.gz

##
rm -rf ./data/${NODE_NAME}

mkdir -p ./data/${NODE_NAME}/bin
tar zxvf geth_${NODE_VERSION}_linux_amd64.tar.gz -C ./data/${NODE_NAME}/bin

mkdir -p ./data/${NODE_NAME}/geth

cp ${NODE_KEY} ./data/${NODE_NAME}/geth/nodekey
cp nodes-${NODE_TYPE}.json ./data/${NODE_NAME}/static-nodes.json
cp nodes-${NODE_TYPE}.json ./data/${NODE_NAME}/permissioned-nodes.json

./data/${NODE_NAME}/bin/geth --datadir ./data/${NODE_NAME} init ./genesis.json

source ./geth.common.sh
source ./geth.node.${NODE_TYPE}.sh

export PRIVATE_CONFIG="ignore"
./data/${NODE_NAME}/bin/geth --datadir ./data/${NODE_NAME} ${GLOBAL_ARGS} ${METRICS} ${NODE_ARGS} ${LOCAL_ARGS} > ./data/${NODE_NAME}/log
