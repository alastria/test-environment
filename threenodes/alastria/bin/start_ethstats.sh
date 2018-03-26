#!/bin/bash
set -u
set -e

echo "Excecute from alastria folder"

EPWD="$(pwd)"

_TIME=$(date +%Y%m%d%H%M%S)

if [[ ! -d "./eth-netstats" ]]; then
    git clone https://github.com/cubedro/eth-netstats
    cd eth-netstats
    npm install
    sudo npm install -g grunt-cli
else 
    cd eth-netstats
fi

nohup env WS_SECRET=bb98a0b6442386d0cdf8a31b267892c1 npm start >> "${EPWD}"/logs/netstat_"${_TIME}".log &

echo "Verify if ${EPWD}/logs/ have new files."

set +u
set +e