#!/bin/sh

NODE_IP=127.0.0.1
NODE_TYPE=validator-main
NODE_NAME=main

git clone https://github.com/alastria/alastria-node
/root/alastria-node/scripts/bootstrap.sh

if [[ "$NODE_TYPE" == "validator-main" ]]; then
	cd /root/alastria-node/scripts/
	./init.sh $NODE_IP validator $NODE_NAME
else
	./init.sh $NODE_IP $NODE_TYPE $NODE_NAME
fi
