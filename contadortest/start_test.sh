#!/bin/bash
set -u
set -e

_TOTAL="$1"
_OPERACION="$2"
_REPETICIONES="$3"
_TIME=$(date +%Y%m%d%H%M%S) 

for i in `seq 1 ${_TOTAL}`; do 
    truffle exec "${_OPERACION}"_Counter.js  --network localhost "${_REPETICIONES}" >> ~/alastria/logs/contadortest_"${_OPERACION}"_"${_TIME}"_"${i}".log & 
    # ./contadortest "${_OPERACION}" "${_REPETICIONES}" >> ~/alastria/logs/contadortest_"${_OPERACION}"_"${_TIME}"_"${i}".log & 
done

set +u
set +e