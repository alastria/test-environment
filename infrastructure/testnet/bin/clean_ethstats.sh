
#!/bin/bash
set -u
set -e

if [[ ! -d "./eth-netstats" ]]; then
	rm -rf ./eth-netstats
fi

echo "Removing netstats dependencies"

set +u
set +e
