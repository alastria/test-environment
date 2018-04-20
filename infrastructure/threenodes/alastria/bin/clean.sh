#!/bin/bash
# Prepare the node for a clean restart

if ( [ "transactions" == "$1" ]); then
    echo "Cleaning transaction queue ..."
    rm */geth/transactions.rpl
else
    echo "Preparing the node for a clean restart ..."
    rm -Rf ./logs/*
    rm -Rf */geth/chainData
    rm -Rf */geth/chaindata
    rm -Rf */geth/nodes
    rm */geth/LOCK
    rm */geth/transactions.rpl
    rm */geth.ipc
    rm -Rf */quorum-raft-state
    rm -Rf */raft-snap
    rm -Rf */raft-wal
    rm -Rf */constellation/data
    rm */constellation/constellation.ipc
    rm */geth/transactions.rpl
fi
