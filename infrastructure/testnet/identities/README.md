# Nodes identities
- Nodes identities are predefined. If new nodes with new identities want to be
created, you must run `./new_identity`. It will create a new folder in the
`identities/` location. These new identities should be included in the
`permissioned-nodes.json` and `statis-nodes.json` for them to join the network.

- Nodes can be started individually with `./start-node <NODE-NAME>`. Try to run
the main node first or the network will not work properly.

#ETHSTATS
- To run the ethstats run `./start_ethstats`. If you run ethstats from a different
machine, you must change the variable `ETHSTATS_IP` in `./start_node`, so nodes
start communicating their information to the correct server.