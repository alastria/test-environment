#!/bin/sh
echo "[*] Executing alastria-node bootstrap"
sudo bash -H bin/bootstrap-alastria-node.sh

if [ $ -eq 4 ]
    then
        echo "Script execution stopped. Check last message and try again"
        exit 4
else
    echo "[*] Building fauty-node compatible geth client"
    sudo bash bin/build_faulty_nodes.sh
fi