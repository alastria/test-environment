#!/bin/bash

function installgo {
  GO="/tmp/go1.9.5.linux-amd64.tar.gz"
  /bin/tar zxvf $GO -C /usr/local
  gopath
}

function installconstellation {
  CONSTELLATION="/tmp/constellation-0.3.2-ubuntu1604.tar.xz"
  /bin/tar Jxvf $CONSTELLATION -C /usr/local
  constellationpath
}

function installquorum {
   cd /tmp
   /usr/bin/git clone https://github.com/alastria/quorum.git
   cd quorum
   /usr/bin/git checkout 775aa2f5a6a52d9d84c85d5ed73521a1ea5b15b3
   /usr/bin/make all
   cp build/bin/geth /usr/local/bin
   cp build/bin/bootnode /usr/local/bin
}

function gopath {
    echo "export GOROOT=/usr/local/go" >> $HOME/.bashrc
    echo "export GOPATH=$HOME/alastria/workspace" >> $HOME/.bashrc
    echo "export PATH=$PATH:$GOROOT/bin:$GOPATH/bin" >> $HOME/.bashrc
    export GOROOT=/usr/local/go
    export GOPATH=$HOME/alastria/workspace
    export PATH=$PATH:$GOROOT/bin:$GOPATH/bin
}

function constellationpath {
    echo "export PATH=$PATH:/usr/local/constellation-0.3.2-ubuntu1604" >> $HOME/.bashrc
    export PATH=$PATH:/usr/local/constellation-0.3.2-ubuntu1604
}

function installalastria {
  set -e
  
  installgo
  installconstellation
  installquorum
  
  set +e
}

installalastria
