#!/bin/bash
set -u
set -e
MESSAGE='Usage: stop_node <node_name>
    node-name: main | generalx | validatorx'

if ( [ $# -ne 1 ] ); then
    echo "$MESSAGE"
    exit
fi

case "$1" in 
  *validator*)
    pkill -f "identity $1"
    echo "[*] Killing node $1"
    ;;
   *general*)
    pkill -f "identity $1"
    pkill -f network/$1/constellation
    echo "[*] Killing node $1"
    ;;
   *main*)
    pkill -f "identity $1"
    echo "[*] Killing node $1"
    ;;
esac

set +u
set +e