#!/usr/bin/env bash

if [ -z $1 ]; then
    echo [-] Missing node type
    exit
fi

# Hack, to create folders in network dir we need to execute clean task first...
./bin/start_network.sh clean 0 0

./bin/start_node.sh $1 dockerfile
