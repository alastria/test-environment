# Install Alastria using Docker
If you want to test Alastria using Docker then you have two options.

## Alastria base image
I built a base Docker image with all common components for validator and regular nodes. You can build this image
executing the task `make build-base-image`. If you use a proxy, this task automatically uses it to build the image.
This can take a while.

## Makefile tasks
You can execute multiple tasks provided by the [Makefile](Makefile).

| **Name**                	| **Description**                                                              	|
|-------------------------	|------------------------------------------------------------------------------	|
| `build`                 	| Builds the base and node Alastria images                                     	|
| `build-base-image`      	| Build only the Alastria base image                                           	|
| `build-alastria`        	| Build the Alastria node image                                                	|
| `install-test-complete` 	| Execute the Alastria node indicated by it's type, name, and different ports 	|
| `install-test-basic`    	| Execute the Alastria node indicated by it's type and name                    	|
| `node-shell`            	| Obtain a shell into a running node                                           	|
| `clean`                   | Remove **all** Alastria docker images                                         |
| `stop`                    | Stop **all** Alastria running nodes                                           |

For each task you can use different values to customize it:

| **Name** 	| **Description**                                     	| **Used in**                                      	|
|----------	|-----------------------------------------------------	|--------------------------------------------------	|
| `TYPE`   	| Type of the node, `main`, `general1` .... Mandatory 	| `install-test-complete` and `install-test-basic` 	|
| `NAME`   	| Name of the running container. Mandatory            	| `install-test-complete` and `install-test-basic` 	|

For a complete list of customizable port parameters see the [network](#network) section.


## Install using Vagrant
Start the [`Vagrantfile`](Vagrantfile) of this repo to install all dependencies, `docker`, `make` etc.

```bash
$ vagrant up --provision-with shell
```
When done, go to the `/vagrant` directory and build the image

```bash
$ make build
```
The result image will be something like `alastria-node:0.1-31fdd47d00`, where `0.1` is the base version, and `31fdd47d00` is the
hash of the `Dockerfile`, so when the Dockerfile changes, it automatically rebuilds.

```bash
REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
alastria-base       latest              99c40f8fba36        About an hour ago   1.97GB
alastria-node       0.1-f0ac32baea      99c40f8fba36        About an hour ago   1.97GB
```

## Build `Dockerfile` and run Alastria
If you don't want to use `make build`, then you need to build the base image first

```bash
$ docker build -t alastria-base -f Dockerfile.base .
```
> **Tip** You can use `--build-arg http_proxy=` to pass your proxy config 

When done, build the alastria-node image
```bash
$ docker build -t alastria-node .
```

## Start shell in Alastria node
If you want to digg in the Alastria node, you can execute the task
```bash
$ make node-shell
```
If no image exists, first it create one, and then give you a fresh shell.
* Check [Makefile](Makefile) for more details

### Starting
You can execute the task `make install-test-basic` with the type of the node in the `TYPE` argument to start a node and the `NAME` that will have. If all is ok, the output will be something like this:
```bash
vagrant@ubuntu-xenial:/vagrant$ make install-test-basic NAME=main TYPE=main
docker run -it alastria-node:0.1-800760ca2a main
[!!] Run this script from the directory test-environment/infrastructure/testnet/
[*] Cleaning previous environments
[!!] Run this script from the directory test-environment/infrastructure/testnet
[*] Preparing to clean the environment
[!!] Run this script from the directory test-environment/infrastructure/testnet/
[*] Spreading permissioned nodes config files
[*] Generating nodes in environment
[*] Starting validator nodes
[!!] Number of validators not supported. Please contact @arochaga or any Alastria member for support
[!!] Excecute from alastria test-environment/infrastructure/testnet/
[*] Starting main
Verify if /opt/test-environment/infrastructure/testnet/logs/ have new files.
```
> :warning: **Important** :warning: `NAME` and `TYPE` are mandatory to start a node successfully

Also, you can start directly an Alastria node without using `make`. For example, if you want to start a validator node, then you need to execute:

```bash
$ docker run -it alastria-node:0.1-34fr23 general1
```
And the result, if all is ok will be:

```bash
vagrant@ubuntu-xenial:/vagrant$ docker run -it alastria-node:0.1-800760ca2a general1
[!!] Run this script from the directory test-environment/infrastructure/testnet/
[*] Cleaning previous environments
[!!] Run this script from the directory test-environment/infrastructure/testnet
[*] Preparing to clean the environment
[!!] Run this script from the directory test-environment/infrastructure/testnet/
[*] Spreading permissioned nodes config files
[*] Generating nodes in environment
[*] Starting validator nodes
[!!] Number of validators not supported. Please contact @arochaga or any Alastria member for support
[!!] Excecute from alastria test-environment/infrastructure/testnet/
[*] Starting general1
localhost [127.0.0.1] 9001 (?) : Connection refused
localhost [127.0.0.1] 9001 (?) : Connection refused
localhost [127.0.0.1] 9001 (?) : Connection refused
localhost [127.0.0.1] 9001 (?) : Connection refused
localhost [127.0.0.1] 9001 (?) : Connection refused
localhost [127.0.0.1] 9001 (?) : Connection refused
localhost [127.0.0.1] 9001 (?) : Connection refused
localhost [127.0.0.1] 9001 (?) : Connection refused
localhost [127.0.0.1] 9001 (?) : Connection refused
localhost [127.0.0.1] 9001 (?) : Connection refused
localhost [127.0.0.1] 9001 (?) : Connection refused
localhost [127.0.0.1] 9001 (?) : Connection refused
localhost [127.0.0.1] 9001 (?) : Connection refused
localhost [127.0.0.1] 9001 (?) : Connection refused
localhost [127.0.0.1] 9001 (?) : Connection refused
localhost [127.0.0.1] 9001 (?) open
[*] constellation node at 9001 is now up.
Verify if /opt/test-environment/infrastructure/testnet/logs/ have new files.
```
See the next section if you want to tune the network options.

## Network
List of exposed ports by default:


| **Ports**                            	| **Description**                          	| **Makefile parameter**               	|
|--------------------------------------	|------------------------------------------	|--------------------------------------	|
| `9000/tcp`                           	| Constellation communication              	| `CONSTELLATION_PORT`                 	|
| `21000-21010/tcp`  `21000-21010/udp` 	| Communication between `geth`  processes  	| `GETH_PORT_TCP`  and `GETH_PORT_UDP` 	|
| `22000-22010/tcp`                    	| RPC communication                        	| `RPC_PORT`                           	|

Modify the host ports if you want to run validator nodes and regular nodes in the same machine. As the [Alastria documentation](https://github.com/alastria/alastria-node#requisitos-del-sistema) says, the container **must** use
the ports:
* `8443/tcp`
* `9000/tcp` Constellation
* `21000/tcp/udp` geth proccesses
* `22000/tcp` rpc
> **Tip** Configure your firewall using `ufw`

For more info see:
* [Alastria documentation](https://github.com/alastria/alastria-node#requisitos-del-sistema)
* [Makefile](Makefile)
* [UFW](https://help.ubuntu.com/community/UFW)
