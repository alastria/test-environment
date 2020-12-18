#!/bin/bash

echo "[!!] Run this script from the directory test-environment/infrastructure/testnet/"

testnodes=( main validator1 validator2 general1 general2 general3 general4 )

echo "[*] Spreading permissioned nodes config files"
for node in "${testnodes[@]}"
	do
  		cp static-nodes.json permissioned-nodes.json ./identities/${node}/
	done

echo "[*] Generating nodes in environment"
for node in "${testnodes[@]}"
	do
		cp -rf identities/${node} /network/${node}
	done

echo "Generated new environment. A new etherbase will be initialized for each node."
read -p "A new etherbase account will be generated for each node. Their password will be 'Passw0rd'. Would you like to change that? [yes|NO]" CHANGEDEFAULT
CHANGEDEFAULT=${CHANGEDEFAULT:-NO}
for node in "${testnodes[@]}"
	do
    if [[ ${CHANGEDEFAULT,,} == y || ${CHANGEDEFAULT,,} == yes ]]; then
      read -p "Please, enter the password for the etherbase account on ${node} node: [Passw0rd]" PASSWORD
      PASSWORD=${PASSWORD:-Passw0rd}
      cat > /network/${node}/passwords.txt << EOF
$PASSWORD
EOF
    else
    cat > /network/${node}/passwords.txt << EOF
Passw0rd
EOF
    fi
		geth --datadir=/network/${node} --password /network/${node}/passwords.txt account new > /network/${node}/etherbase.txt
	done

echo "Editing the genesis file with the new information..."
cat > ../common/genesis.json << EOF
{
  "alloc": {
EOF
for node in "${testnodes[@]::${#testnodes[@]}-1}"
	do
	address=$(cat /network/${node}/etherbase.txt | grep -Po "0x[0-9A-Fa-f]{40}")
	cat >> ../common/genesis.json << EOF
    "$address": {
      "balance": "1000000000000000000000000000"
    },
EOF
	done
address=$(cat /network/general4/etherbase.txt | grep -Po "0x[0-9A-Fa-f]{40}")
cat >> ../common/genesis.json << EOF
    "$address": {
      "balance": "1000000000000000000000000000"
    }
EOF
mainaddress=$(cat /network/main/etherbase.txt | grep -Po "0x[0-9A-Fa-f]{40}")
cat >> ../common/genesis.json << EOF
  },
  "coinbase": "0x0000000000000000000000000000000000000000",
  "config": {
    "chainId": 9535753591,
    "homesteadBlock": 0,
    "byzantiumBlock": 0,
    "constantinopleBlock":0,
    "petersburgBlock": 0,
    "istanbulBlock": 0,
    "eip150Block": 0,
    "eip150Hash": "0x0000000000000000000000000000000000000000000000000000000000000000",
    "eip155Block": 0,
    "eip158Block": 0,
    "isQuorum": true,
    "maxCodeSizeConfig" : [
      {
        "block" : 0,
        "size" : 32
      }
    ],
    "istanbul": {
      "epoch": 30000,
      "policy": 0,
      "ceil2Nby3Block": 0
    }
  },
  "gasLimit": "0x2FEFD800",
  "difficulty": "0x1",
  "mixHash": "0x63746963616c2062797a616e74696e65206661756c7420746f6c6572616e6365",
  "nonce": "0x0",
  "parentHash": "0x0000000000000000000000000000000000000000000000000000000000000000",
  "timestamp": "0x00"
}
EOF
echo "Generated genesis file."

# Complete previous genesis file lines, for reference until development is completed.
# },
#   "coinbase": "$mainaddress",
#   "config": {
#     "chainId": 9535753591,
#     "homesteadBlock": 0,
#     "byzantiumBlock": 0,
#     "constantinopleBlock":0,
#     "petersburgBlock": 0,
#     "istanbulBlock": 0,
#     "eip150Block": 0,
#     "eip150Hash": "0x0000000000000000000000000000000000000000000000000000000000000000",
#     "eip155Block": 0,
#     "eip158Block": 0,
#     "isQuorum": true,
#     "maxCodeSizeConfig" : [
#       {
#         "block" : 0,
#         "size" : 32
#       }
#     ],
#     "istanbul": {
#       "epoch": 10,
#       "policy": 0,
#       "ceil2Nby3Block": 0
#     }
#   },
#   "extraData": "0x0000000000000000000000000000000000000000000000000000000000000000f85ad594b87dc349944cc47474775dde627a8a171fc94532b8410000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000c0",
#   "gasLimit": "0x2FEFD800",
#   "difficulty": "0x1",
#   "mixHash": "0x63746963616c2062797a616e74696e65206661756c7420746f6c6572616e6365",
#   "nonce": "0x0",
#   "parentHash": "0x0000000000000000000000000000000000000000000000000000000000000000",
#   "timestamp": "0x00"
# }