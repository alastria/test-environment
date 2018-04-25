#!/bin/sh
#!/bin/bash
set -u
set -e

MESSAGE='Usage: test <mode>
    mode: build-images
    '

if ( [ $# -ne 1 ] ); then
    echo "$MESSAGE"
    exit
fi


if ( [ ! $# -ne 1 ] && [ "build-images" == "$1" ]); then 
    docker build --build-arg nodetype="validator" -t alastria/validator-node .
    docker build --build-arg nodetype="general" -t alastria/general-node .
fi

set +u
set +e
