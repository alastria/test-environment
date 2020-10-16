#!/bin/sh
echo "[*] Executing alastria-node bootstrap"
sudo bash -H bin/bootstrap-alastria-node.sh

echo "[*] Building fauty-node compatible geth client"
sudo bash bin/build_faulty_nodes.sh
