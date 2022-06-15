# validator ARGS for validator node
# NODE_ARGS=" --maxpeers 32 --mine --minerthreads $(grep -c "processor" /proc/cpuinfo)"
NODE_ARGS=" --maxpeers 32 --mine --miner.threads 1 --miner.gasprice 0"

# The Ethstats server where to send the info
# METRICS=" --ethstats $NODE_NAME:1bdf9149555dbb77ec68aadce67897cf@netstats.core-redt.alastria.io"
