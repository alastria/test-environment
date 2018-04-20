#!/bin/bash
set -u
set -e


echo "[!!] Run this script from the directory test-environment/infrastructure/testnet/"
MESSAGE='Usage: start_network <mode>
    mode: clean | restart
    number-validators-nodes: <number:int> (0-3)
    number-gws-nodes: <number:int> (0-4)'


if ( [ $# -ne 3 ] ); then
    echo "$MESSAGE"
    exit
fi

if ([ "clean" == "$1" ]); then
    echo "[*] Cleaning previous environments"
    ./bin/clean_env.sh
    ./bin/config_network.sh
elif ([ "restart" == "$1" ]); then
    echo "[*] Restarting previous configuration"
fi

start_validators () {
    VAL_NUM=$1
    echo "[*] Starting validator nodes"
    if [ "$VAL_NUM" -eq "1" ]; then
        ./bin/start_node.sh main
    elif [ "$VAL_NUM" -eq "2" ]; then
        ./bin/start_node.sh main
        ./bin/start_node.sh validator1
        geth --exec 'istanbul.propose("0xB50001FfA410F4D03663D69540c1C8e1C017e7e6", true)' attach network/main/geth.ipc
    elif [ "$VAL_NUM" -eq "3" ]; then
        ./bin/start_node.sh main
        ./bin/start_node.sh validator1
        geth --exec 'istanbul.propose("0xB50001FfA410F4D03663D69540c1C8e1C017e7e6", true)' attach network/main/geth.ipc
        ./bin/start_node.sh validator2
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

    if [ "$VAL_NUM" -eq "1" ]; then
        ./bin/start_node.sh general1
    elif [ "$VAL_NUM" -eq "2" ]; then
        ./bin/start_node.sh general1
        ./bin/start_node.sh general2

    elif [ "$VAL_NUM" -eq "3" ]; then
        ./bin/start_node.sh general1
        ./bin/start_node.sh general2
        ./bin/start_node.sh general3
    elif [ "$VAL_NUM" -eq "4" ]; then
        ./bin/start_node.sh general1
        ./bin/start_node.sh general2
        ./bin/start_node.sh general3
        ./bin/start_node.sh general4
    else
        echo "[!!] Number of validators not supported. Please contact @arochaga or any Alastria member for support"
        exit
    fi
}

start_validators $2
start_gws $3






set +u
set +e