# Alastria (Quorum) Test Environments Tidy Up Feature Branch

<!-- TODO: UPDATE THJIS FILE -->

The purpose of this branch is to implement the last package updates so the test environment is as close as possible to the real Alastria-environment, and also to fix all known issues and extensively document the installation proccess so the environment can be installed and used out of the box.

This is the "main" branch for the task. The test environment consists of 5 separated implementations: ansible, docker, testnet, threenodes and performance. Each one of them will be dealt in a separated branch and then merged to this one.

A decision has been made about scripts: considering that the system is installed from scratch, at least in the vagrant and docker scripts, there makes no sense to use variables to pass the paths and execute scripts, like $HOME, $(pwd), "if type go", etc, because we should know exactly where those executables and paths are. So to make the installation less prone to errors, from this commit on the paths will be hardcoded.

# Test Environment Installation:

- **VAGRANT (preferred)**

  - Clone the project
  - Modify the "commit" parameter in the `vagrant/config/vconfig/vagrant-local-example.yml`. It is recommended to use the same commit this README you are reading belongs to.
  - You can also modify any other parameter you want. For example, the "ubuntu" parameter.
  - Execute `vagrant up` (currently in the folder `infrastructure/testnet/vagrant-testnet`)
  - Once it finishes building, you have to perform a `vagrant reload`, as it is prompted from console. This is just to reboot the machine, but it works out of the box.
  - Then, you can communicate with the Virtual Machine through `vagrant ssh` command and view the ethstats and the block explorer from [http://localhost:3000](http://localhost:3000) and [http://localhost:8888](http://localhost:8888), respectively.
  - Notes:

    You can change the parameters of the virtual machine in `vagrant/config/vconfig/vagrant-local-example.yml` BEFORE the first execution. The parameters are self-explanatory. The recommended parameters are the ones already in place. If you change the ethstats or block_explorer ports, use them instead of the ones in the previous paragraph.

    You must have Virtualbox and Vagrant installed into your machine.

    If the `vagrant up` command stops shortly after first execution and there is not any error message, just keep executing it. Vagrant is installing its required plugins.

    In the following screenshot you can see a working configuration. The two main parameters probably will have to change are highlighted (this is an example, you don't have to use the actual parameters you see here):

    ![vagrant-local-example.yml](/infrastructure/common/vagrant-example.png?raw=true)
    
- **Ubuntu 18**

  - Follow Ubuntu 20 instructions below

- **Ubuntu 20**

  - Install necessary packages: `$apt-get install -y npm software-properties-common unzip wget git make gcc libsodium-dev build-essential libdb-dev zlib1g-dev libtinfo-dev libtinfo5 sysvbanner psmisc libleveldb-dev libdb5.3-dev dnsutils sudo netcat nodejs docker docker-compose`
  `npm install -g truffle@5.1.48`

  - Clone this project

  - Navigate to the testnet folder: `cd test-environment/infrastructure/testnet`

  - Execute the bootstrap script: `sudo bash bin/bootstrap.sh`

  - Now you can open up a parallel terminal and clone the cbx-quorum-explorer project: `git clone https://github.com/Councilbox/cbx-quorum-explorer.git`

  - Navigate to the newly cloned directory: `cd cbx-quorum-explorer`

  - Create a new folder, that the explorer will use to store its database. It can be wherever you want; we will assume it is the following: `mkdir mongo_data_dir`

  - Modify the docker-compose.yaml.template, that does not work, with the command: `curl https://raw.githubusercontent.com/alastria/test-environment/feature/tidyup-testnet/infrastructure/common/docker-compose.yaml.template > docker-compose.yaml.template`

  - Change the env.sh file with these parameters (see explanation below, in the "notes" section):

  ```
  QUORUM_ENDPOINTS=localhost:22000,localhost:22001,localhost:22002,localhost:22003,localhost:22005
  ENABLE_SSL=false
  EXPLORER_PORT=8888
  API_DOMAIN=localhost
  MONGO_DATA_DIR=/path/to/mongo_data_dir
  API_PORT=
  EXTERNAL_API_PORT=
  WEBAPP_VERSION=alastria-telsius
  ```

  - Build the docker scripts: `bash build.sh`

  - In the terminal where the bootstrap script was running, once it finishes, bring the node up: `sudo bash bin/start_network.sh`

  - Execute the docker container construction processes in the other terminal: `bash launch.sh`

  - Check localhost:8888 to see the block explorer running. You can customize the port in the vagrant-local-example file and in the EXPLORER_PORT variable of the env.sh file.

  - You can execute `sudo bash bin/start_ethstats.sh` to see ethstats. Open localhost:3000 in a browser.

  - You can send transactions through geth or truffle. Just use a terminal to execute either of them. Alternatively, you can now clone the alastria-lib-example and alastria-lib repositories. [WIP]

  <!-- - Geth 1.9.5. Recommended procedure: -- IS INSTALLED ALONG QUORUM
    ```
    cd /usr/local
    git clone https://github.com/ethereum/go-ethereum.git
    PATH="$PATH:/usr/local/go-ethereum"
    cd go-ethereum
    git checkout v1.9.5
    make geth
    ``` -->


# CHANGELOG

Note that this has been developed in Ubuntu 20.04 LTS.
WIP: porting to Ubuntu 18.04 LTS.

- **infrastructure/testnet/bin/bootstrap.sh**

  - Added call to the bootstrap.sh of the repository of alastria-node, copied into `infrastructure/testnet/bin`
  - Deleted the package installation instructions. The necessary packages are documented or will be installed in the Vagrant provisioner.
  - The script SHOULD be run using `sudo bash bin/bootstrap.sh` so it executes all the functions as it should.


- **infrastructure/testnet/bin/bootstrap-alastria-node.sh**

  - This is the alastria-node repository bootstrap script. Copied into this one for two reasons: the first is to reduce the time of execution at least while developing. The main reason, however, is to fix some issues with that script: this is a test environment and is meant for testing but also for enhancing the current working environment and more importantly, to have it working properly without strange workarounds. That said, it will remain as close as possible to the real environment (paths, software versions when possible, etc).
  - Deleted all occurrences of `$HOME` beacuse it defaults to `/root` as soon as the first "superuser" function gets executed. Now the paths are absolute.
  - Deleted last command of GOPATH function because it stopped script execution: `exec "$BASH"`
  - Deleted the package installation instructions. The necessary packages are documented or will be installed in the Vagrant provisioner.
  - Hardcoded the paths for the `fixconstellation` function because the libsodium installation is known. If using another OS, please, change the paths accordingly.
  - Changed Quorum version to Consensys 2.6 instead of Alastria 2.2 (this is an upcoming change to Alastria-node environment.
  - Fixed functions "fixconstellation", "installquorum" and "installgo".

- **infrastructure/testnet/bin/start-node.sh**

  - Added the `env PRIVATE_CONFIG=ignore` modifier in the node initialization. This is due to the Quorum update and a temporary change just to have the script working properly.


- **infrastructure/testnet/vagrant-testnet/vagrant/config/provision/once-as-root.sh**

  - Cleaned the script as much as possible.

- **infrastructure/testnet/vagrant-testnet/vagrant/config/provision/always-as-root.sh**

  - Commented out the start ethstats command. Ethstats is known for clogging up the machines where it runs. You can always start it manually.
  

- **TBD**:

  - Have a look at some potential problems of `set -e` command and maybe change all its occurrences:
    https://stackoverflow.com/questions/19622198/what-does-set-e-mean-in-a-bash-script
    https://stackoverflow.com/questions/3474526/stop-on-first-error
    http://mywiki.wooledge.org/BashFAQ/105
  - **IMPORTANT**: Consider to lock package versions so there are no issues with that in the future. In the case of a container like docker or a Vagrant installation, the packages should already be installed. This can potentially break the scripts and lead to security and/or performance issues.

- **Other changes and notes**:

  - The commit used in the provisioner should be the last stable testnet commit. It will already be in place, but double-check that.
