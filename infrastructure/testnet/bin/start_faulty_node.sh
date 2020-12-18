#!/bin/bash
set -u
set -e

echo "[!!] Excecute from alastria test-environment/infrastructure/testnet/"

MESSAGE='Usage: start_faulty_node <node_name> <faulty_mode>
    node_name: general1-n | main/validator1-n'


if ( [ $# -ne 2 ] ); then
    echo "$MESSAGE"
    exit
fi

PWD="$(pwd)"

_TIME=$(date +%Y%m%d%H%M%S)

FAULTY_MODE="1"
NODE_NAME="$1"
NETID=9535753591
mapfile -t IDENTITY </network/"$NODE_NAME"/IDENTITY
mapfile -t NODE_TYPE </network/"$NODE_NAME"/NODE_TYPE
NODE_IP="127.0.0.1"
ETH_STATS_IP="127.0.0.1"

echo "[*] Starting $NODE_NAME"

generate_conf() {
	#TODO: modify this script to bring up faulty nodes.
   #define parameters which are passed in.
   NODE_IP="$1"
   TESSERA_PORT="$2"
   OTHER_NODES="$3"
   PWD="$4"
   NODE_NAME="$5"

   #define the template.
   cat  << EOF
# Externally accessible URL for this node (this is what's advertised)
url = "http://$NODE_IP:$TESSERA_PORT/"
# Port to listen on for the public API
port = $TESSERA_PORT
# Socket file to use for the private API / IPC
socket = "$PWD/$NODE_NAME/tessera/c.ipc"
# Initial (not necessarily complete) list of other nodes in the network.
# Tessera will automatically connect to other nodes not in this list
# that are advertised by the nodes below, thus these can be considered the
# "boot nodes."
othernodes = [$OTHER_NODES]
# The set of public keys this node will host
publickeys = ["$PWD/$NODE_NAME/tessera/keystore/node.pub"]
# The corresponding set of private keys
privatekeys = ["$PWD/$NODE_NAME/tessera/keystore/node.key"]
# Optional file containing the passwords to unlock the given privatekeys
# (one password per line -- add an empty line if one key isn't locked.)
passwords = "$PWD/$NODE_NAME/passwords.txt"
# Where to store payloads and related information
storage = "$PWD/$NODE_NAME/tessera/data"
# Verbosity level (each level includes all prior levels)
#   - 0: Only fatal errors
#   - 1: Warnings
#   - 2: Informational messages
#   - 3: Debug messages
verbosity = 2
EOF
}

check_port() {
	PORT_TO_TEST="$1"
	RETVAL=1
	
	set +u
	set +e

	while [ $RETVAL -ne 0 ]
	do
		netcat -z -v localhost $PORT_TO_TEST
		RETVAL=$?
		[ $RETVAL -eq 0 ] && echo "[*] tessera node at $PORT_TO_TEST is now up."
		[ $RETVAL -ne 0 ] && sleep 1
		
	done

	set -u
	set -e	
}

PUERTO=0
if [[ "$NODE_NAME" == "main" ]]; then
	PUERTO=0
elif [[ "$NODE_NAME" == "general1" ]]; then
	PUERTO=1
elif [[ "$NODE_NAME" == "general2" ]]; then
	PUERTO=2
elif [[ "$NODE_NAME" == "general3" ]]; then
	PUERTO=3
elif [[ "$NODE_NAME" == "general4" ]]; then
	PUERTO=4
elif [[ "$NODE_NAME" == "validator1" ]]; then
	PUERTO=5
elif [[ "$NODE_NAME" == "validator2" ]]; then
	PUERTO=6
else
	PUERTO=7
fi

OTHER_NODES="`cat ${PWD}/identities/TESSERA_NODES`"
GLOBAL_ARGS="--networkid $NETID --identity $IDENTITY --rpc --rpcaddr 0.0.0.0 --rpcapi admin,db,eth,debug,miner,net,shh,txpool,personal,web3,quorum,istanbul --rpcport 2200$PUERTO --port 2100$PUERTO --targetgaslimit 18446744073709551615 --ethstats $IDENTITY:bb98a0b6442386d0cdf8a31b267892c1@$ETH_STATS_IP:3000 "
FAULTY_ARGS="--istanbul.faultymode $2 "
TESSERA_PORT="900$PUERTO"
if [ "$NODE_NAME" == "main"  -o "$NODE_NAME" == "validator1" -o "$NODE_NAME" == "validator2" ]; then
	nohup ./geth_faulty --datadir /network/"$NODE_NAME" $GLOBAL_ARGS $FAULTY_ARGS --mine --minerthreads 1 --syncmode "full" 2>> "${PWD}"/logs/quorum_"$NODE_NAME"_"${_TIME}".log &
else

	generate_conf "${NODE_IP}" "${TESSERA_PORT}" "${PEER_NUMBER}" /network "${NODE_NAME}" > /network/"$NODE_NAME"/tessera/tessera.json
	PWD="$(pwd)"
	nohup $tessera -configfile /network/"$NODE_NAME"/tessera/tessera.json 2>> "${TESTNET_DIR}"/logs/tessera_"$NODE_NAME"_"${_TIME}".log &
	check_port $TESSERA_PORT
	# nohup env PRIVATE_CONFIG=/network/"$NODE_NAME"/tessera/tessera.json geth --datadir /network/"$NODE_NAME" --debug $GLOBAL_ARGS 2>> "${TESTNET_DIR}"/logs/quorum_"$NODE_NAME"_"${_TIME}".log &
	nohup env PRIVATE_CONFIG=/network/"$NODE_NAME"/tessera/c.ipc geth --datadir /network/"$NODE_NAME" --debug $GLOBAL_ARGS 2>> "${TESTNET_DIR}"/logs/quorum_"$NODE_NAME"_"${_TIME}".log &


	# TODO: Add every regular node for the tessera communication
	generate_conf "${NODE_IP}" "${TESSERA_PORT}" "$OTHER_NODES" /network "${NODE_NAME}" > /network/"$NODE_NAME"/tessera/tessera.conf
	PWD="$(pwd)"
	nohup #TODO: tessera command (using the alias from start_network) tessera-node /network/"$NODE_NAME"/tessera/tessera.conf 2>> "${PWD}"/logs/tessera_"$NODE_NAME"_"${_TIME}".log &
	check_port $TESSERA_PORT
	nohup env PRIVATE_CONFIG=/network/"$NODE_NAME"/tessera/tessera.conf ./geth_faulty --datadir /network/"$NODE_NAME" --debug $GLOBAL_ARGS $FAULTY_ARGS 2>> "${PWD}"/logs/quorum_"$NODE_NAME"_"${_TIME}".log &
fi

echo "Verify if ${PWD}/logs/ have new files."

set +u
set +e
