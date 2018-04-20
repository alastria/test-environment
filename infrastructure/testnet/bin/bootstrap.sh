#!/bin/sh
echo "[*] Installing required dependencies"
PWD="${pwd}"

cd ~
git clone https://github.com/alastria/alastria-node.git
cd alastria-node/
git checkout develop

cd ..
ln -s $(pwd)/alastria $HOME/alastria
sudo -H ~/alastria/alastria/alastria-node/scripts/bootstrap.sh