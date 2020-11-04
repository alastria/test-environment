#!/bin/bash

function superuser {
  if ( type "sudo"  > /dev/null 2>&1 )
  then
    sudo $@
  else
    eval $@
  fi
}

function checkgo {
  PATH=$PATH:/usr/local/go/bin
  if ( ! type "go" > /dev/null 2>&1 )
  then
    installgo
  else
    GOREL="go1.15.2.linux-amd64.tar.gz"
    V1=$(go version | grep -oP '\d+(?:\.\d+)+')
    V2=$(echo $GOREL | grep -oP '\d+(?:\.\d+)+')
    nV1=$(echo $V1 | sed 's/\.//g')
    nV2=$(echo $V2 | sed 's/\.//g')
    if (( $nV1 >= $nV2 )); then
      echo "Your current version of golang ($V1) is higher than the required to run Alastria nodes ($V2), so we will use it"
    else
      installgo
    fi
  fi
}

function installgo {
  echo "Installing Go"
  GOREL="go1.15.2.linux-amd64.tar.gz"
  echo "export PATH=$PATH:/usr/local/go/bin" >> /etc/bash.bashrc
  echo "export PATH=$PATH:/usr/local/go/bin" >> /root/.bashrc
  echo "export PATH=$PATH:/usr/local/go/bin" >> /home/vagrant/.bashrc
  echo "export PATH=$PATH:/usr/local/go/bin" >> /home/vagrant/.profile
  echo "Installing GO"
  wget "https://storage.googleapis.com/golang/$GOREL" -O /tmp/$GOREL
  pushd /tmp
  tar xvzf $GOREL
  superuser rm -rf /usr/local/go
  superuser mv /tmp/go /usr/local/go
  popd
  rm -rf /tmp/go
}

function installtessera {
  echo "Installing Tessera"
  git clone https://github.com/ConsenSys/tessera.git
  cd tessera
  git checkout 3c0fa760cd78bed01bf766ff06e85d87248016e7 #Tessera 20.10.0
  mvn install
}

function installquorum {
  if ( ! type "geth" > /dev/null 2>&1 )
  then
    echo "Installing QUORUM"
    pushd /tmp
    git clone https://github.com/ConsenSys/quorum.git
    cd quorum
    git checkout af7525189f2cee801ef6673d438b8577c8c5aa34 #20.10.0
    make all
    superuser cp build/bin/geth /usr/local/bin
    superuser cp build/bin/bootnode /usr/local/bin
    popd
    rm -rf /tmp/quorum
  fi
}

function gopath {
# Manage GOROOT variable
  if [[ -z "$GOROOT" ]]; then
    echo "[*] Trying default GOROOT. If the script fails please run $(pwd)/alastria-node/bootstrap.sh or configure GOROOT correctly"
    echo 'export GOROOT=/usr/local/go' >> /root/.bashrc
    echo 'export GOROOT=/usr/local/go' >> /etc/bash.bashrc
    echo 'export GOPATH=$(pwd)/alastria/workspace' >> /root/.bashrc
    echo 'export GOPATH=$(pwd)/alastria/workspace' >> /etc/bash.bashrc
    echo 'export PATH=$GOROOT/bin:$GOPATH/bin:$PATH' >> /root/.bashrc
    echo 'export PATH=$GOROOT/bin:$GOPATH/bin:$PATH' >> /etc/bash.bashrc
    export GOROOT=/usr/local/go
    export GOPATH=$(pwd)/alastria/workspace
    export PATH=$GOROOT/bin:$GOPATH/bin:$PATH
    echo "[*] GOROOT = $GOROOT, GOPATH = $GOPATH"
    mkdir -p "$GOPATH"/{bin,src}
  fi
}

function installalastria {
  set -e
  checkgo
  installconstellation
  fixconstellation
  installquorum
  gopath
  set +e
}

function uninstallalastria {
  superuser rm -rf /usr/local/go 2>/dev/null
  superuser rm /usr/local/bin/constellation-node 2>/dev/null
  superuser rm /usr/local/bin/geth 2>/dev/null
  rm -rf /tmp/* 2>/dev/null
}

if ( [ "uninstall" == "$1" ] )
then
  uninstallalastria
elif ( [ "reinstall" == "$1" ] )
then
   uninstallalastria
   installalastria
else
  installalastria
fi