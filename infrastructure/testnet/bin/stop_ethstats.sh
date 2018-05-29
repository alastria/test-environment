#!/bin/bash
set -u
set -e

echo "[!!] Run this script from the directory test-environment/infrastructure/testnet/"

pkill -f "./bin/www"

set +u
set +e
