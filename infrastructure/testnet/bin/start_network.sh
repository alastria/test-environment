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
elif ([ "restart" == "$1" ]); then
    echo "[*] Restarting previous configuration"
fi

start_faulty_validator() {
    if ([ "--faulty_node" == "$FAULTY_FLAG" ]); then
        echo "[*] Starting faulty node"
        ./bin/start_faulty_node.sh validator1 $FAULTY_MODE
    else
        ./bin/start_node.sh validator1
    fi
}

start_validators () {
    VAL_NUM=$1
    echo "[*] Starting validator nodes"
    if [ "$VAL_NUM" -eq "1" ]; then
        ./bin/start_node.sh main
    elif [ "$VAL_NUM" -eq "2" ]; then
        ./bin/start_node.sh main
        start_faulty_validator
        sleep 15
        geth --exec 'istanbul.propose("0xB50001FfA410F4D03663D69540c1C8e1C017e7e6", true)' attach network/main/geth.ipc
    elif [ "$VAL_NUM" -eq "3" ]; then
        ./bin/start_node.sh main
        start_faulty_validator
        sleep 15
        geth --exec 'istanbul.propose("0xB50001FfA410F4D03663D69540c1C8e1C017e7e6", true)' attach network/main/geth.ipc
        ./bin/start_node.sh validator2
        sleep 15
        geth --exec 'istanbul.propose("0xD8CfEA3B26B879f9D208975dFE8460F27520876b", true)' attach network/main/geth.ipc
        geth --exec 'istanbul.propose("0xD8CfEA3B26B879f9D208975dFE8460F27520876b", true)' attach network/validator1/geth.ipc
    else
        echo "[!!] Number of validators not supported. Please contact @arochaga or any Alastria member for support"
        exit
    fi
}

start_gws () {
    GW_NUM=$1
    echo "[*] Starting gw nodes"

    if [ "$GW_NUM" -eq "1" ]; then
        ./bin/start_node.sh general1
    elif [ "$GW_NUM" -eq "2" ]; then
        ./bin/start_node.sh general1
        ./bin/start_node.sh general2

    elif [ "$GW_NUM" -eq "3" ]; then
        ./bin/start_node.sh general1
        ./bin/start_node.sh general2
        ./bin/start_node.sh general3
    elif [ "$GW_NUM" -eq "4" ]; then
        ./bin/start_node.sh general1
        ./bin/start_node.sh general2
        ./bin/start_node.sh general3
        ./bin/start_node.sh general4
    else
        echo "[!!] Number of validators not supported. Please contact @arochaga or any Alastria member for support"
        exit
    fi
}

start_validators $2 #$4 $5
start_gws $3

set +u
set +e
