#!/bin/bash
set -u
set -e

echo "Configure what the test will do:"
read -p 'Total tests to perform: ' _TOTAL
read -p 'Network (use "localhost" for the one pre-configured or edit the truffle-config.js file): ' _NETWORK
read -p 'Repetitions: ' _REPETITIONS
read -p 'Test Account (its position on web3.eth.getAccounts array or hexadecimal value (starting with "0x"). Any other value will result in the creation of a new account): ' _ACCOUNT
read -sp 'Password: ' _PASSWORD
read -p 'Action to perform (currently supported: a, b, arrays): ' _OPERATION

_TIME=$(date +%Y%m%d%H%M%S) 

for i in `seq 1 ${_TOTAL}`; do 
    truffle exec test.js  --network "${_NETWORK}" a q w x "${_REPETITIONS}" "${_ACCOUNT}" "${_PASSWORD}" "${_OPERATION}" >> logs/contadortest_"${_OPERATION}"_"${_TIME}"_"${i}".log & 
    sleep 5
    # ./contadortest "${_OPERATION}" "${_REPETITIONS}" >> ~/alastria/logs/contadortest_"${_OPERATION}"_"${_TIME}"_"${i}".log & 
done

set +u
set +e
