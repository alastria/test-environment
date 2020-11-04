#!/bin/bash
set -u
set -e

echo "[!!] Excecute from alastria test-environment/infrastructure/testnet/"

MESSAGE='Usage: start_node <node_name>
    node_name: general1-n | main/validator1-n'


if ( [ $# -ne 1 ] ); then
    echo "$MESSAGE"
    exit
fi

PWD="$(pwd)"

_TIME=$(date +%Y%m%d%H%M%S)

NODE_NAME="$1"
NETID=9535753591
mapfile -t IDENTITY </network/"$NODE_NAME"/IDENTITY
mapfile -t NODE_TYPE </network/"$NODE_NAME"/NODE_TYPE
NODE_IP="127.0.0.1"
ETH_STATS_IP="127.0.0.1"

echo "[*] Starting $NODE_NAME"

generate_conf() {
   #define parameters which are passed in.
   NODE_IP="$1"
   CONSTELLATION_PORT="$2"
   OTHER_NODES="$3"
   PWD="$4"
   NODE_NAME="$5"

   #define the template.
   cat  << EOF
# Externally accessible URL for this node (this is what's advertised)
url = "http://$NODE_IP:$CONSTELLATION_PORT/"
# Port to listen on for the public API
port = $CONSTELLATION_PORT
# Socket file to use for the private API / IPC
socket = "$PWD/$NODE_NAME/constellation/c.ipc"
# Initial (not necessarily complete) list of other nodes in the network.
# Constellation will automatically connect to other nodes not in this list
# that are advertised by the nodes below, thus these can be considered the
# "boot nodes."
othernodes = [$OTHER_NODES]
# The set of public keys this node will host
publickeys = ["$PWD/$NODE_NAME/constellation/keystore/node.pub"]
# The corresponding set of private keys
privatekeys = ["$PWD/$NODE_NAME/constellation/keystore/node.key"]
# Optional file containing the passwords to unlock the given privatekeys
# (one password per line -- add an empty line if one key isn't locked.)
passwords = "$PWD/$NODE_NAME/passwords.txt"
# Where to store payloads and related information
storage = "$PWD/$NODE_NAME/constellation/data"
# Verbosity level (each level includes all prior levels)
#   - 0: Only fatal errors
#   - 1: Warnings
#   - 2: Informational messages
#   - 3: Debug messages
verbosity = 3
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
		[ $RETVAL -eq 0 ] && echo "[*] constellation node at $PORT_TO_TEST is now up."
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

TESTNET_DIR="/home/vagrant/test-environment/infrastructure/testnet"
OTHER_NODES="`cat ${TESTNET_DIR}/identities/CONSTELLATION_NODES`"
GLOBAL_ARGS="--networkid $NETID --identity $IDENTITY --rpc --rpcaddr 0.0.0.0 --rpcapi admin,db,eth,debug,miner,net,shh,txpool,personal,web3,quorum,istanbul --rpcport 2200$PUERTO --port 2100$PUERTO --targetgaslimit 18446744073709551615 --ethstats $IDENTITY:bb98a0b6442386d0cdf8a31b267892c1@$ETH_STATS_IP:3000 "
CONSTELLATION_PORT="900$PUERTO"
if [ "$NODE_NAME" == "main"  -o "$NODE_NAME" == "validator1" -o "$NODE_NAME" == "validator2" ]; then
	nohup env PRIVATE_CONFIG=ignore geth --datadir /network/"$NODE_NAME" $GLOBAL_ARGS --mine --minerthreads 1 --syncmode "full" 2>> "${TESTNET_DIR}"/logs/quorum_"$NODE_NAME"_"${_TIME}".log &
else
	# TODO: Add every regular node for the constellation communication
	generate_conf "${NODE_IP}" "${CONSTELLATION_PORT}" "$OTHER_NODES" /network "${NODE_NAME}" > /network/"$NODE_NAME"/constellation/constellation.conf
	PWD="$(pwd)"
	nohup constellation-node /network/"$NODE_NAME"/constellation/constellation.conf 2>> "${TESTNET_DIR}"/logs/constellation_"$NODE_NAME"_"${_TIME}".log &
	check_port $CONSTELLATION_PORT
	nohup env PRIVATE_CONFIG=/network/"$NODE_NAME"/constellation/constellation.conf geth --datadir /network/"$NODE_NAME" --debug $GLOBAL_ARGS 2>> "${TESTNET_DIR}"/logs/quorum_"$NODE_NAME"_"${_TIME}".log &
fi

echo "Verify if ${TESTNET_DIR}/logs/ have new files."

set +u
set +e

# TODO: Esto funciona en consola: sudo env PRIVATE_CONFIG=ignore geth --datadir network/main/ --networkid 9535753591 --identity network/main/IDENTITY --rpc --rpcaddr 0.0.0.0 --rpcapi admin,db,eth,debug,miner,net,shh,txpool,personal,web3,quorum,istanbul --rpcport 22000 --port 21000 --targetgaslimit 18446744073709551615

# TODO: start geth with --nousb option, as it erorrs a lot "Failed to enumerate USB devices". This does not impact in the initialization, however.