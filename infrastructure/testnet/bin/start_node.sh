#!/bin/bash
set -u
set -e

echo "[!!] Excecute from alastria test-environment/infrastructure/testnet/"

MESSAGE='Usage: start_node <node_name>
    node_name: general1-n | main/validator1-n'

if ( [ $# -ne 2 ] ); then
    echo "$MESSAGE"
    exit
fi

PWD="$(pwd)"

_TIME=$(date +%Y%m%d%H%M%S)

NODE_NAME="$1"
PEER_NUMBER="$2"
NETID=9535753591
mapfile -t IDENTITY </network/"$NODE_NAME"/IDENTITY
mapfile -t NODE_TYPE </network/"$NODE_NAME"/NODE_TYPE
NODE_IP="127.0.0.1"
ETH_STATS_IP="127.0.0.1"

echo "[*] Starting $NODE_NAME"

generate_conf() {
   #define parameters which are passed in.
   NODE_IP="$1"
   TESSERA_PORT="$2"
   PEER_NUMBER="$3"
   PWD="$4"
   NODE_NAME="$5"

   mysql -uroot -p1234 <<< "CREATE DATABASE IF NOT EXISTS testnet_$NODE_NAME DEFAULT CHARACTER SET utf8;"

   #define the template
   # ! SPECIFICATIONS: https://docs.tessera.consensys.net/en/latest/HowTo/Configure/Tessera/ !
   #TODO: encrypt password: https://docs.tessera.consensys.net/en/latest/HowTo/Configure/Tessera/#database
   #TODO: see also: https://github.com/ConsenSys/tessera/tree/tessera-20.10.0#obfuscate-database-password-in-config-file
   cat << EOF
	{
		"serverConfigs": [
			{
			"app": "Q2T",
			"enabled": true,
			"serverAddress": "unix:$PWD/$NODE_NAME/tessera/c.ipc",
			"communicationType" : "REST"
			},
			{
			"app": "P2P",
			"enabled": true,
			"serverAddress": "http://$NODE_IP:$TESSERA_PORT/",
			"sslConfig": {
               "tls": "OFF"
           	},
			"communicationType" : "REST"
			}
		],
		"peer": [
EOF
	for (( port=1; port<$PEER_NUMBER; port++ ))
	do
	cat  << EOF
			{
				"url": "http://127.0.0.1:900$port"
			},
EOF
	done
	cat  << EOF
			{
				"url": "http://127.0.0.1:900$PEER_NUMBER"
			}
		],
		"disablePeerDiscovery": true,
		"keys": {
			"passwordFile": "$PWD/$NODE_NAME/passwords.txt",
			"keyData": [
				{
					"privateKeyPath": "$PWD/$NODE_NAME/tessera/keystore/node.key",
					"publicKeyPath": "$PWD/$NODE_NAME/tessera/keystore/node.pub"
				}
			]
      	},
		"jdbc": {
			"username": "tessera",
			"password": "1234",
			"url": "jdbc:mysql://localhost:3306/testnet_$NODE_NAME",
			"autoCreateTables": true
		}
	}
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

if [[ "$NODE_NAME" == "main" ]]; then
	PORT=0
elif [[ "$NODE_NAME" == "validator1" ]]; then
	PORT=5
elif [[ "$NODE_NAME" == "validator2" ]]; then
	PORT=6
elif [[ "${NODE_NAME:0:7}" == "general" ]]; then
	PORT=${NODE_NAME:7:1}
else
	PORT=7
fi

# tessera="java -jar /home/vagrant/tessera/tessera-dist/tessera-app/target/tessera-app-20.10.0-app.jar"
tessera="java -cp /home/vagrant/mysql.jar:/home/vagrant/tessera/tessera-dist/tessera-app/target/tessera-app-20.10.0-app.jar:. com.quorum.tessera.launcher.Main"
TESTNET_DIR="/home/vagrant/test-environment/infrastructure/testnet"
GLOBAL_ARGS="--networkid $NETID --identity $IDENTITY --rpc --rpcaddr 0.0.0.0 --rpcapi admin,db,eth,debug,miner,net,shh,txpool,personal,web3,quorum,istanbul --rpcport 2200$PORT --port 2100$PORT --targetgaslimit 18446744073709551615 --ethstats $IDENTITY:bb98a0b6442386d0cdf8a31b267892c1@$ETH_STATS_IP:3000 "
TESSERA_PORT="900$PORT"
if [ "$NODE_NAME" == "main"  -o "$NODE_NAME" == "validator1" -o "$NODE_NAME" == "validator2" ]; then
	nohup env PRIVATE_CONFIG=ignore geth --datadir /network/"$NODE_NAME" $GLOBAL_ARGS --mine --minerthreads 1 --syncmode "full" 2>> "${TESTNET_DIR}"/logs/quorum_"$NODE_NAME"_"${_TIME}".log &
else
	generate_conf "${NODE_IP}" "${TESSERA_PORT}" "${PEER_NUMBER}" /network "${NODE_NAME}" > /network/"$NODE_NAME"/tessera/tessera.json
	PWD="$(pwd)"
	nohup $tessera -configfile /network/"$NODE_NAME"/tessera/tessera.json 2>> "${TESTNET_DIR}"/logs/tessera_"$NODE_NAME"_"${_TIME}".log &
	check_port $TESSERA_PORT
	# nohup env PRIVATE_CONFIG=/network/"$NODE_NAME"/tessera/tessera.json geth --datadir /network/"$NODE_NAME" --debug $GLOBAL_ARGS 2>> "${TESTNET_DIR}"/logs/quorum_"$NODE_NAME"_"${_TIME}".log &
	nohup env PRIVATE_CONFIG=/network/"$NODE_NAME"/tessera/c.ipc geth --datadir /network/"$NODE_NAME" --debug $GLOBAL_ARGS 2>> "${TESTNET_DIR}"/logs/quorum_"$NODE_NAME"_"${_TIME}".log &
fi

echo "Verify if ${TESTNET_DIR}/logs/ have new files."

set +u
set +e

# TODO: Esto funciona en consola: sudo env PRIVATE_CONFIG=ignore geth --datadir network/main/ --networkid 9535753591 --identity network/main/IDENTITY --rpc --rpcaddr 0.0.0.0 --rpcapi admin,db,eth,debug,miner,net,shh,txpool,personal,web3,quorum,istanbul --rpcport 22000 --port 21000 --targetgaslimit 18446744073709551615

# TODO: start geth with --nousb option, as it erorrs a lot "Failed to enumerate USB devices". This does not impact in the initialization, however.
# TODO: check $GLOBAL_ARGS for starting general nodes.