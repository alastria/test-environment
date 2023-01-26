#!/bin/bash

NODE_NAME=${1}
NODE_VERSION=${2}
NODE_KEY=${3}
NODE_TYPE=${4}
P2P_PORT=${5}
RPC_PORT=${6}

wget -O besu-${NODE_VERSION}.tar.gz https://hyperledger.jfrog.io/artifactory/besu-binaries/besu/${NODE_VERSION}/besu-${NODE_VERSION}.tar.gz

rm -rf ./data/${NODE_NAME} && mkdir -p ./data/${NODE_NAME}

tar zxvf besu-${NODE_VERSION}.tar.gz -C ./data/${NODE_NAME}

mkdir -p ./data/${NODE_NAME}/keys

cp ${NODE_KEY} ./data/${NODE_NAME}/keys/key
./data/${NODE_NAME}/besu-${NODE_VERSION}/bin/besu --data-path=./data/${NODE_NAME}/keys public-key export --to=./data/${NODE_NAME}/keys/key.pub
./data/${NODE_NAME}/besu-${NODE_VERSION}/bin/besu --data-path=./data/${NODE_NAME}/keys public-key export-address --to=./data/${NODE_NAME}/keys/nodeAddress

mkdir -p ./data/${NODE_NAME}/config

cp ./genesis.json ./data/${NODE_NAME}/config/genesis.json
case ${NODE_TYPE} in
	"validator")
		network_nodes=$(echo "[$(cat ./validator-nodes.json), $(cat ./regular-nodes.json)]" | jq '[.[0][], .[1][]]' | jq --arg ENODE "$(cat ./data/${NODE_NAME}/keys/key.pub | cut -c 3-)" 'del(.[] | select(. | contains($ENODE)))')
		echo "nodes-allowlist=$network_nodes" > ./data/${NODE_NAME}/config/allowed-nodes.toml
		echo $network_nodes > ./data/${NODE_NAME}/config/static-nodes.json
	;;
	"regular")
		echo "nodes-allowlist=$(cat ./validator-nodes.json)" > ./data/${NODE_NAME}/config/allowed-nodes.toml
		cp ./validator-nodes.json ./data/${NODE_NAME}/config/static-nodes.json
	;;
esac

./data/${NODE_NAME}/besu-${NODE_VERSION}/bin/besu \
	--logging=INFO \
	--permissions-accounts-contract-address=0x0000000000000000000000000000000000008888 \
	--permissions-accounts-contract-enabled=false \
	--permissions-nodes-contract-address=0x0000000000000000000000000000000000009999 \
	--permissions-nodes-contract-enabled=false \
	--data-path=./data/${NODE_NAME} \
	--node-private-key-file=./data/${NODE_NAME}/keys/key \
	--genesis-file=./data/${NODE_NAME}/config/genesis.json \
	--p2p-port=${P2P_PORT} \
	--min-gas-price=0 \
	--permissions-nodes-config-file-enabled=true \
	--permissions-nodes-config-file=./data/${NODE_NAME}/config/allowed-nodes.toml \
	--discovery-enabled=false \
	--static-nodes-file=./data/${NODE_NAME}/config/static-nodes.json \
	--rpc-http-enabled=true \
	--rpc-http-api=ETH,NET,WEB3,ADMIN,IBFT,PERM \
	--rpc-http-port=${RPC_PORT} \
	--rpc-http-host=0.0.0.0 \
	--rpc-http-cors-origins="*"
