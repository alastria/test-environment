# Alastria (Besu) Test Environments
In this repository you will find all the tools required to test, develop and experiment
with Alastria's Besu network infrastructure on the Alastria B network.

## Enodes

List of prelocated nodes:

```
validator01 nodekey01 59e64230962565f4401988148130218a47fd1a037e4fcff7618e82ecbe672fa2a031c4186107d78538e2db7568bcd31e8c2b9144686b3aa58461a37df5af4c5e
validator02 nodekey02 1e30a3a8aa755605907c142590bd1584a5bbb23330a8eddd35ef2642f84222dd27cf55c599d53f27aee72b4b81b5e979b621a1963c50a3408a87a1cd416228f3
validator03 nodekey03 31d7724ede621eb61f0907d0eb338b48401a12dee24b4aa5600713714fbf4b0f72b365c9e5320c5a3c50828c29d5c311186870b4a09fdcab681051d56fd19c33
validator04 nodekey04 0fea0c952632f1cb0d48a3e4dc10af22805f5bd7cf6c7cdb242f1bb2dc9b9e5edc764e2f3a3243835336608b320ccdc2df0cc3ba79b9cf7bb5c2b92654a26053
regular01 nodekey05 5c69ad0f0c1b3985ef66fdd61e55a88fb566e11c04cb802603aef72d5fdd5b64e8cecb9a44a86638feaee70d078ade16385994972c75eaa0074e520da10f82ce
temp01 nodekey06 3e73ed11da8dc0346f2b85460c748e6a79a0f27e2122d9db7a8d86f6281df80810a4c5893e47a3331e15a58d48c6181b342b3c8c3d8394276b6f3efb7c0fa19d
```

## Contribute
If you want to contribute, you detect any bug or you want to give us feedback about the tools, please
do not hesitate in contacting us, or posting an issue. 

## Generate the RLP encoded `extraData` string for genesis file
* https://besu.hyperledger.org/en/stable/private-networks/reference/cli/subcommands/#generate-blockchain-config

```
$ cat 2encode.json
[
"0x12880f549a47b8374ae6155063e39971c5438871",
"0xf78341e7dc842f525436e8c5657de2eece373b91",
"0x21c544e17bdddea40fc8889c60b29de25805f555",
"0x067d60b8b8569299ce766760c0347011dc1fba0b"
]
```

```
$ besu rlp encode --from=2encode.json --type=IBFT_EXTRA_DATA
0xf87ea00000000000000000000000000000000000000000000000000000000000000000f8549412880f549a47b8374ae6155063e39971c543887194f78341e7dc842f525436e8c5657de2eece373b919421c544e17bdddea40fc8889c60b29de25805f55594067d60b8b8569299ce766760c0347011dc1fba0b808400000000c0
```

## Option 1 - Bare Metal

```
$ cd bare-metal
$ ./nodeStart.sh validator01 22.1.0 nodekey01 validator 30301 8541
$ ./nodeStart.sh validator02 22.1.0 nodekey02 validator 30302 8542
$ ./nodeStart.sh validator03 22.1.0 nodekey03 validator 30303 8543
$ ./nodeStart.sh validator04 22.1.0 nodekey04 validator 30304 8544
$ ./nodeStart.sh regular01 22.1.0 nodekey05 regular 30305 8545
```

Edit args in nodeStart.sh to fine tunning of version, port,...
