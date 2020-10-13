# Alastria (Quorum) Test Environments Tidy Up Feature Branch

The purpose of this branch is to implement the last package updates so the test environment is as close as possible to the real Alastria-environment, and also to fix all known issues and extensively document the installation proccess so the environment can be installed and used out of the box.

This is the "main" branch for the task. The test environment consists of 5 separated implementations: ansible, docker, testnet, threenodes and performance. Each one of them will be dealt in a separated branch and then merged to this one.

# Test Environment Installation:

- **VAGRANT (preferred)**

  - Clone the project
  - Execute `vagrant up`
  - Once it finishes building you have to perform a `vagrant reload`
  - Then, you can communicate with the Virtual Machine through `vagrant ssh` command
  - Notes:

    You can change the parameters of the virtual machine in `vagrant/config/vconfig/vagrant-local-example.yml` BEFORE the first execution. The parameters are self-explanatory. The recommended parameters are the ones already in place.

    You require to have installed Virtualbox and Vagrant into your machine.

    If the `vagrant up` command stops shortly after first execution and there is not any error message, just keep executing it. Vagrant is installing its required plugins.

- **Ubuntu 20**

  - `$apt-get install -y npm software-properties-common unzip wget git make gcc libsodium-dev build-essential libdb-dev zlib1g-dev libtinfo-dev libtinfo5 sysvbanner psmisc libleveldb-dev libdb5.3-dev dnsutils sudo netcat nodejs docker docker-compose npm install -g truffle@5.1.48`

  - Geth 1.9.5. Recommended procedure:
    ```
    cd /usr/local
    git clone https://github.com/ethereum/go-ethereum.git
    PATH="$PATH:/usr/local/go-ethereum"
    cd go-ethereum
    git checkout v1.9.5
    make geth
    ```

# CHANGELOG

Note that this has been developed in Ubuntu 20.04 LTS. If neccessary it will be ported to Ubuntu 18.04 LTS.

- **infrastructure/testnet/bin/bootstrap.sh**

  - Added call to the bootstrap.sh of the repository of alastria-node, copied into `infrastructure/testnet/bin`
  - Changed variable definition: `"${pwd}"` => `"$(pwd)"`
  - Commented out the package installation for the time being, while development takes place. Possibly it will be removed or at least outsourced.
  - The script SHOULD be run using `sudo bash bin/bootstrap.sh` so it executes all the functions as it should.

- **infrastructure/testnet/bin/bootstrap-alastria-node.sh**

  - This is the alastria-node repository bootstrap script. Copied into this one for two reasons: the first is to reduce the time of execution at least while developing. The main reason, however, is to fix some issues with that script: this is a test environment and is meant for testing but also for enhancing the current working environment and more importantly, to have it working properly without strange workarounds. That said, it will remain as close as possible to the real environment (paths, software versions when possible, etc).
  - Changed all occurrences of `$HOME` beacuse it defaults to `/root` as soon as the first "superuser" function gets executed: `$HOME` => `$(pwd)`
  - Commented out last command of GOPATH function because it stopped script execution: `exec "$BASH"`
  - Commented out the package installation for the time being, while development takes place. Possibly it will be removed or at least outsourced.
  - Changed the `fixconstellation` function so it works standalone:

    ```
    if [ $sodiumrel = "notfound" ]
      then
        installedpath=$(whereis libsodium 2>/dev/null | grep libsodium.so |  cut -d ' ' -f2 | sed 's/libsodium.so//' | tr -d '[:space:]')
        if [[ -d $installedpath ]]
        then
          echo "The libsodium package version in the distribution mismatches the one linked in constellation. Symlinking"
          superuser ln -s $installedpath/libsodium.so /lib64/libsodium.so.18
          superuser cp $installedpath/libsodium.so $installedpath/libsodium.so.18
          superuser cp $installedpath/libleveldb.so $installedpath/libleveldb.so.1
          superuser ldconfig
        else
    ```

  - Changed Quorum version to Consensys 2.6 instead of Alastria 2.2 (this is an upcoming change to Alastria-node environment.

- **infrastructure/testnet/bin/start-node.sh**

  - Added the `env PRIVATE_CONFIG=ignore` modifier in the node initialization. This is due to the Quorum update and a temporary change just to have the script working properly.

- **TBD**:

  - Have a look at some potential problems of `set -e` command and maybe change all its occurrences:
    https://stackoverflow.com/questions/19622198/what-does-set-e-mean-in-a-bash-script
    https://stackoverflow.com/questions/3474526/stop-on-first-error
    http://mywiki.wooledge.org/BashFAQ/105
  - Consider to avoid the installation of packages or at least the apt-get-upgrade command.
  - **IMPORTANT**: Consider to lock package versions so there are no issues with that in the future. In the case of a container like docker or a Vagrant installation, the packages should already be installed. This can potentially break the scripts and lead to security and/or performance issues.

- **Other changes and notes**:

  - In Ubuntu 20 it has been mandatory to install libtinfo5 because it's the version used by Constellation
  - CBX Quorum explorer: (https://github.com/Councilbox/cbx-quorum-explorer/)[GitHub]

  File env.sh:

  ```
  QUORUM_ENDPOINTS=http://localhost:22000,localhos:22001,etc #It is irrelevant to add the http or not. BEWARE OF SPACES
  ENABLE_SSL=false #In lower case
  EXPLORER_PORT=8888
  API_DOMAIN=localhost
  MONGO_DATA_DIR=/home/vagrant/projects/cbx-quorum-explorer/mongo_data_dir #This file has to be created beforehand. It will be external to Docker.
  API_PORT=8886 #It MUST remain empty for local usage
  EXTERNAL_API_PORT=8885 #It MUST remain empty for local usage
  WEBAPP_VERSION=cbx-alastria-telsius
  ```

  The `docker-compose.yaml.template` file must be replaced with this one: https://gist.github.com/brunneis/f6ffc3898635f2ab5718f8ab0f5f6905

  The Docker container inside each folder must be built before executing `launch.sh` script:

  `$cd http_api`

  `$sudo ./build.sh`

  It is mandatory to execute `launch.sh` with sudo.
