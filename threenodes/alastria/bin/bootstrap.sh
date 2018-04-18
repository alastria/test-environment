#!/bin/sh
git clone https://github.com/alastria/alastria-node.git
cd alastria-node/
git checkout develop
ls
cd ..
ln -s $(pwd)/alastria $HOME/alastria
sudo -H ~/alastria/alastria/alastria-node/scripts/bootstrap.sh