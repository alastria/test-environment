# Alastria local test network.

The following project aims to provide you with the tools required to
deploy an Alastria test-net in your local environment.

- First of all, you need to install every required dependency:
```
./bin/bootstrap.sh
```
- If the installation was successful you can start your local test-net with the following
command:
```
./bin/start_network.sh clean <num-validators> <num-gws>
```
Running the script with the `clean` mode will remove every existing environment and
start a test-net from scratch. If you want to start an already existing environment,
you should use the `restart` mode. With `<num-validators>` and `<num-gws>` you are
able to determine the topology of your network. Bear in mind the maximum number of
each type of node supported currently.

- To stop a running network you can use the following command:
```
./bin/stop_network.sh
``` 

- And to clean an environment:
```
./bin/clean_env.sh
```

- To monitor the status of your network you can use the 
- You can start nodes individually using the following script:
```
./bin/start_node.sh <node-identity>
```
The `<node-identity>` value must be one of the identities available in the `/identities` folder.
You could create additional identities using the `./bin/new_identity.sh` script. However, you should
be carefully when running this script without a good knowledge of how it works, as if run in an
existing alastria-node, undesired changes could be performed. For additional information about
the operation of this script contact the team.

- Finally, you can connect to one of your nodes normally using the ipc socket or the RPC API. The
gateways nodes are assigned ports 22001, 22002, 22003 and 22004 respectively.
```
geth attach ./network/<node-identity>/geth.ipc
# Examples
geth attach ./network/general1/geth.ipc
geth attach http://127.0.0.1:22001
```
Using the RPC API of any of the nodes you can configure any of your preferred Ethereum tools (Truffle, Cakeshop, etc.).
The installation of this tools is not covered in this tutorial, if you need additional information please contact the team.

*NOTE*: All the scripts should be run from `test-environment/infrastructure/testnet/`.