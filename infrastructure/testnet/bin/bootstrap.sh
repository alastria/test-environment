#!/bin/sh
echo "[*] Installing required dependencies"
PWD="$(pwd)"
echo "Skipping installation during development"
# sudo apt-get install wget git sudo netcat npm nodejs golang
# When using docker images
# sudo apt-get install wget git sudo netcat

# git clone https://github.com/alastria/alastria-node.git
# cd alastria-node/
# git checkout testnet2

# cd ..
# sudo -H $PWD/alastria-node/scripts/bootstrap.sh

# echo "$PWD"
sudo bash -H bin/bootstrap-alastria-node.sh
# sudo bash -H bin/bootstrap-alastria-node-PR.sh
# rm -rf alastria-node

echo "[*] Building fauty-node compatible geth client"
./bin/build_faulty_nodes.sh
