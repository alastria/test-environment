#!/bin/sh
git clone https://github.com/alastria/alastria-node.git
cd alastria-node/
git checkout develop
./scripts/boostrap.sh
ln -s $(pwd)/alastria $HOME/alastria