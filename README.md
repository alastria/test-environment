# Alastria (Quorum) Test Environments
In this repository you will find all the tools required to test, develop and experiment
with Alastria's GoQuorum network infrastructure on the Alastria Telsius network.

## Enodes

List of prelocated nodes:

```
validator01 nodekey01 59e64230962565f4401988148130218a47fd1a037e4fcff7618e82ecbe672fa2a031c4186107d78538e2db7568bcd31e8c2b9144686b3aa58461a37df5af4c5e
validator02 nodekey02 1e30a3a8aa755605907c142590bd1584a5bbb23330a8eddd35ef2642f84222dd27cf55c599d53f27aee72b4b81b5e979b621a1963c50a3408a87a1cd416228f3
validator03 nodekey03 31d7724ede621eb61f0907d0eb338b48401a12dee24b4aa5600713714fbf4b0f72b365c9e5320c5a3c50828c29d5c311186870b4a09fdcab681051d56fd19c33
validator04 nodekey04 0fea0c952632f1cb0d48a3e4dc10af22805f5bd7cf6c7cdb242f1bb2dc9b9e5edc764e2f3a3243835336608b320ccdc2df0cc3ba79b9cf7bb5c2b92654a26053
bootnode01  nodekey05 5c69ad0f0c1b3985ef66fdd61e55a88fb566e11c04cb802603aef72d5fdd5b64e8cecb9a44a86638feaee70d078ade16385994972c75eaa0074e520da10f82ce
general01   nodekey06 3e73ed11da8dc0346f2b85460c748e6a79a0f27e2122d9db7a8d86f6281df80810a4c5893e47a3331e15a58d48c6181b342b3c8c3d8394276b6f3efb7c0fa19d
temp01      nodekey07 8acc73a5fe7569ad88e639a9c5026d43802983f70b306ec0964ca4dbaaf6f2ee350c61c9481b38f1d8bcc37ca2bfc4392fd3891e314cbd00f9e08e984cf8d5c4
temp02      nodekey08 4eaeca34f0b209e08d3849b87800623fe5bcc005be39a64e654373ad427e7203210d0f8e7d7667d2590fee1466e2681bb325664c7d65170eb5cefa9dea7850bb
temp03      nodekey09 f82011508468173c9bef527e84551d4054095cd090b7d8d990620602bd26f967363af0605568b15bcddd8865fb0ed442d86296bd7856529828dacd59048e15a1
temp04      nodekey10 2cfb818cdc3ed1cbffb5b9d85c1cb20a49d0629edede393b0dc452fe49dfdfe8239ed9b20e146d905752ea62118f0f425784f493056726d22b19cd8911e2a521
```

## Contribute
If you want to contribute, you detect any bug or you want to give us feedback about the tools, please
do not hesitate in contacting us, or posting an issue. 

## RLT Data
Fist IBFT signers:
```
nodekey01 - 0x12880f549a47b8374ae6155063e39971c5438871
nodekey02 - 0xf78341e7dc842f525436e8c5657de2eece373b91
nodekey03 - 0x21c544e17bdddea40fc8889c60b29de25805f555
nodekey04 - 0x067d60b8b8569299ce766760c0347011dc1fba0b
```

To get working all the validator nodes, please, use 

* git@github.com:ConsenSys/istanbul-tools.git

for generating the recursive length prefix (RLP) for the network.

## Option 1 - Docker Compose

Start infraestructure:

```
$ cd docker-compose
$ docker-compose up -d
```

Edit docker-composer.yaml to fine tunning of version, port,...

Connect to a running geth:

```
$ docker exec -it alastria-validator-01 geth attach /root/alastria/data/geth.ipc
```

## Option 2 - Bare Metal

```
$ cd bare-metal
$ ./nodeStart.sh alastria-validator-01 v21.1.0 nodekey01 validator 21001
$ ./nodeStart.sh alastria-validator-02 v21.1.0 nodekey02 validator 21002
$ ./nodeStart.sh alastria-validator-03 v21.1.0 nodekey03 validator 21003
$ ./nodeStart.sh alastria-validator-04 v21.1.0 nodekey04 validator 21004
$ ./nodeStart.sh alastria-bootnode-01  v21.1.0 nodekey05 bootnode  21005
$ ./nodeStart.sh alastria-general-06   v21.1.0 nodekey06 general   21006
```

Edit args in nodeStart.sh to fine tunning of version, port,...

Connect to a running geth:

```
$ ./data/alastria-validator-01/bin/geth attach ./data/alastria-validator-01/geth.ipc
```
