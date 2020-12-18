#!/bin/bash
set -u
set -e

FAULTY_MODE=" "

echo "[!!] Run this script from the directory test-environment/infrastructure/testnet/"
MESSAGE='Usage: start_network <mode> <number-validators-nodes> <number-gws-nodes> --faulty_node <faulty-mode>
    mode: clean | restart
    number-validators-nodes: <number:int> (0-3)
    number-gws-nodes: <number:int> (0-4)
    --faulty_node <faulty-mode:int> (0-7)'
    FAULTY_FLAG=""
    FAULTY_MODE=""

if ( [ $# -lt 3 ] ); then
    echo "$MESSAGE"
    exit
fi

if ( [ $# -gt 3 ] ); then
    echo "[*] Enabled faulty node flag"
    FAULTY_FLAG="$4"
    FAULTY_MODE="$5"
fi

if ([ "clean" == "$1" ]); then
    echo "[*] Cleaning previous environments"
    ./bin/clean_env.sh
    ./bin/config_network.sh
    echo "New network created from scratch."
    echo "[*] Initializing quorum"
    geth --nousb --datadir /network/ init ../common/genesis.json
elif ([ "restart" == "$1" ]); then
    echo "[*] Restarting previous configuration"
fi

start_faulty_validator() {
    if ([ "--faulty_node" == "$FAULTY_FLAG" ]); then
        echo "[*] Starting faulty node"
        ./bin/start_faulty_node.sh validator1 $FAULTY_MODE
    else
        ./bin/start_node.sh validator1 $VAL_NUM
    fi
}

start_validators () {
    VAL_NUM=$1
    echo "[*] Starting validator nodes"
    mainaddress=$(cat /network/main/etherbase.txt | grep -Po "0x[0-9A-Fa-f]{40}")
    validator1adderss=$(cat /network/validator1/etherbase.txt | grep -Po "0x[0-9A-Fa-f]{40}")
    validator2address=$(cat /network/validator2/etherbase.txt | grep -Po "0x[0-9A-Fa-f]{40}") # ! It's not actually used anywhere
    if [ "$VAL_NUM" -eq "1" ]; then
        ./bin/start_node.sh main $VAL_NUM
    elif [ "$VAL_NUM" -eq "2" ]; then
        ./bin/start_node.sh main $VAL_NUM
        start_faulty_validator
        sleep 5
        echo "Main etherbase Address: $mainaddress"
        geth --exec 'istanbul.propose("0xb87dc349944cc47474775dde627a8a171fc94532", true)' attach /network/main/geth.ipc
    elif [ "$VAL_NUM" -eq "3" ]; then
        ./bin/start_node.sh main $VAL_NUM
        start_faulty_validator
        sleep 5
        geth --exec 'istanbul.propose("0xb87dc349944cc47474775dde627a8a171fc94532", true)' attach /network/main/geth.ipc
        ./bin/start_node.sh validator2
        sleep 5
        geth --exec 'istanbul.propose("0xD8CfEA3B26B879f9D208975dFE8460F27520876b", true)' attach /network/main/geth.ipc
        geth --exec 'istanbul.propose("0xD8CfEA3B26B879f9D208975dFE8460F27520876b", true)' attach /network/validator1/geth.ipc
    else
        echo "[!!] Number of validators not supported"
        exit
    fi
}

start_gws () {
    GW_NUM=$1
    echo "[*] Starting gateway nodes"
    if [ "$GW_NUM" -gt "4" ]; then
        echo "[!!] Number of general nodes not supported"
        exit
    fi
    for (( node=1; node<=$GW_NUM; node++ ))
    do
        ./bin/start_node.sh general$node $GW_NUM
    done
}

start_validators $2 #$4 $5
start_gws $3

set +u
set +e
