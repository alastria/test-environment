#!/bin/bash
# set -u
# set -e

echo "[*] Building geth client for faulty nodes"
git clone https://github.com/alastria/geth_faulty_nodes
cd geth_faulty_nodes
make geth
echo "[*] Moving built geth"
mv build/bin/geth ../geth_faulty
cd ..
rm -rf geth_faulty_nodes/

# set +u
# set +e