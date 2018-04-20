#!/bin/bash
set -u
set -e

echo "[!!] Run this script from the directory test-environment/utils"
MESSAGE='Usage: start_network <mode>
    mode: clean | restart'

if ([ "clean" == "$1" ]); then
    echo "[*] Cleaning previous environments"
    ./clean_env.sh
    ./config_network.sh
elif ([ "restart" == "$1" ]); then
    echo "[*] Restarting previous configuration"
fi

if ( [ $# -ne 1 ] ); then
    echo "$MESSAGE"
    exit
fi

echo "[*] Starting validator nodes"
./start_node.sh main
./start_node.sh validator1
geth --exec 'istanbul.propose("0xB50001FfA410F4D03663D69540c1C8e1C017e7e6", true)' attach network/main/geth.ipc
./start_node.sh validator2
geth --exec 'istanbul.propose("0xD8CfEA3B26B879f9D208975dFE8460F27520876b", true)' attach network/main/geth.ipc
geth --exec 'istanbul.propose("0xD8CfEA3B26B879f9D208975dFE8460F27520876b", true)' attach network/validator1/geth.ipc

echo "[*] Starting gw nodes"
./start_node.sh general1
./start_node.sh general2
./start_node.sh general3




set +u
set +e