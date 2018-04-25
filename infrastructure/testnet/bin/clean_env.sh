#!/bin/bash
# Prepare the node for a clean restart

echo "[!!] Run this script from the directory test-environment/infrastructure/testnet"
echo "[*] Preparing to clean the environment"
rm -Rf ./network/*
touch ./network/__env__
# mkdir ./network/logs
# touch ./network/logs/__env__
rm -Rf ./logs/*
touch ./logs/__env__