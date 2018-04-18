#!/bin/bash 
current=`pwd` 
MESSAGE='Usage: new-identity <mode> <node-type> <node-name>
    mode: CURRENT_HOST_IP | auto | backup
    node-type: validator | general
    node-name: NODE_NAME (example: Alastria)'

if ([ "clean" == "$1" ]); then
    echo "[*] Cleaning permissioned-nodes config files"
    echo "[]" > ~/alastria-node/data/static-nodes.json
    echo "[]" > ~/alastria-node/data/permissioned-nodes_validator.json
    echo "[]" > ~/alastria-node/data/permissioned-nodes_general.json
    exit
fi

if ( [ $# -ne 3 ] ); then
    echo "$MESSAGE"
    exit
fi

NODE_IP=$1
NODE_TYPE=$2
NODE_NAME=$3

echo "[!!] Run this script from the directory test-environment/utils"
cd ~/alastria-node/scripts

if ([ "$NODE_TYPE" == "validator-main" ]); then   
	./init.sh $NODE_IP validator $NODE_NAME
    cd $current
    cp ./nodekey ~/alastria/data/geth/nodekey
else
	./init.sh $NODE_IP $NODE_TYPE $NODE_NAME
fi

cd $current
mv ~/alastria/data ./identities/$NODE_NAME
# mv ./identities/data ./identities/$NODE_NAME