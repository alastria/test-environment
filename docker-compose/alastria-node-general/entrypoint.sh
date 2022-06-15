#!/bin/bash

source /root/geth.common.sh
source /root/geth.node.${NODE_TYPE}.sh

export PRIVATE_CONFIG="ignore"
/usr/local/bin/geth --datadir /root/alastria/data ${GLOBAL_ARGS} ${METRICS} ${NODE_ARGS} ${LOCAL_ARGS} &

sleep infinity
