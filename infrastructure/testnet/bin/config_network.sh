#!/bin/sh

echo "[!!] Run this script from the directory test-environment/infrastructure/testnet/"

echo "[*] Spreading permissioned nodes config files"
cp static-nodes.json permissioned-nodes.json ./identities/main/
cp static-nodes.json permissioned-nodes.json ./identities/validator1/
cp static-nodes.json permissioned-nodes.json ./identities/validator2/
cp static-nodes.json permissioned-nodes.json ./identities/general1/
cp static-nodes.json permissioned-nodes.json ./identities/general2/
cp static-nodes.json permissioned-nodes.json ./identities/general3/
cp static-nodes.json permissioned-nodes.json ./identities/general4/

echo "[*] Generating nodes in environment"
cp -rf identities/main /network/main
cp -rf identities/validator1 /network/validator1
cp -rf identities/validator2 /network/validator2
cp -rf identities/general1 /network/general1
cp -rf identities/general2 /network/general2
cp -rf identities/general3 /network/general3
cp -rf identities/general4 /network/general4
