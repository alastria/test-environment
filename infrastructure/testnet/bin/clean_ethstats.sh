
#!/bin/bash
set -u
set -e

echo "[!!] Run this script from the directory test-environment/infrastructure/testnet/"
if [[ -d "./eth-netstats" ]]; then
	rm -rf ./eth-netstats
fi

echo "Removing netstats dependencies"

set +u
set +e
