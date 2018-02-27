#!/bin/bash
set -u
set -e

echo "Excecute from alastria folder"

_TIME=$(date +%Y%m%d%H%M%S)

CARPETA="$1"
NETID=9535753591
mapfile -t IDENTITY <~/alastria/"$CARPETA"/IDENTITY
mapfile -t NODE_TYPE <~/alastria/"$CARPETA"/NODE_TYPE

PUERTO=0
if [[ "$CARPETA" == "validator" ]]; then
	PUERTO=0
else
	if [[ "$CARPETA" == "general1" ]]; then
		PUERTO=1
	else
		PUERTO=2
	fi
fi

GLOBAL_ARGS="--networkid $NETID --identity $IDENTITY --rpc --rpcaddr 0.0.0.0 --rpcapi admin,db,eth,debug,miner,net,shh,txpool,personal,web3,quorum,istanbul --rpcport 2200$PUERTO --port 2100$PUERTO "

if [[ "$CARPETA" == "validator" ]]; then
	nohup geth --datadir ~/alastria/"$CARPETA" $GLOBAL_ARGS --mine --minerthreads 1 --syncmode "full" 2>> ~/alastria/logs/quorum_"$CARPETA"_"${_TIME}".log &
else
	nohup constellation-node ~/alastria/"$CARPETA"/constellation/constellation.conf 2>> ~/alastria/logs/constellation_"$CARPETA"_"${_TIME}".log &
	sleep 15
	nohup PRIVATE_CONFIG=~/alastria/"$CARPETA"/constellation/constellation.conf geth --datadir ~/alastria/"$CARPETA" --debug $GLOBAL_ARGS 2>> ~/alastria/logs/quorum_"$CARPETA"_"${_TIME}".log &
fi

echo "Verify if ~/alastria/logs/ have new files."

set +u
set +e