#!/bin/bash
# set -u
# set -e

echo "[*] Building geth client for faulty nodes"
if [[ ! -d geth_faulty_nodes ]]; then
    git clone https://github.com/alastria/geth_faulty_nodes
fi
cd geth_faulty_nodes
make geth
echo "[*] Moving built geth"
mv build/bin/geth ../geth_faulty
cd ..
# rm -rf geth_faulty_nodes/

# set +u
# set +e