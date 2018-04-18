#!/bin/bash
set -u
set -e

echo "[!!] Run this script from the directory test-environment/utils"
echo "[*] Cleaning previous environments"
./clean_env.sh

cp -rf identities/main network/main
./start_node.sh main
# cp -rf identities/main network/general1
# ./start_node.sh general1

set +u
set +e