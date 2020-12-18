#!/bin/bash
set -u
set -e

echo "Configure what the test will do:"
read -p 'Total tests to perform [1]: ' _TOTAL
_TOTAL=${_TOTAL:-1}
read -p 'Network (you can edit the truffle-config.js file) [main]: ' _NETWORK
_NETWORK=${_NETWORK:-main}
read -p 'Repetitions [1]: ' _REPETITIONS
_REPETITIONS=${_REPETITIONS:-1}
read -p 'Test Account (its position on web3.eth.getAccounts array (e.g.: 123) or hexadecimal value (starting with "0x"). Any other value will result in the creation of a new account) [0]: ' _ACCOUNT
_ACCOUNT=${_ACCOUNT:-0}
read -sp 'Password [1234]: ' _PASSWORD
_PASSWORD=${_PASSWORD:-1234}
echo ""
read -p 'Action to perform (currently supported: a, b, arrays) [a]: ' _OPERATION
_OPERATION=${_OPERATION:-a}
_TIME=$(date +%Y%m%d%H%M%S)

for i in `seq 1 ${_TOTAL}`; do
# TODO: PONER EL EJECUTABLE CON NODE, NO CON TRUFFLE. Hay que redefinir lo de artifacts.require
    truffle exec test.js  --network "${_NETWORK}" "${_REPETITIONS}" "${_ACCOUNT}" "${_PASSWORD}" "${_OPERATION}" >> logs/contadortest.log & 
    # truffle exec test.js  --network "${_NETWORK}" "${_REPETITIONS}" "${_ACCOUNT}" "${_PASSWORD}" "${_OPERATION}" >> logs/contadortest_"${_OPERATION}"_"${_TIME}"_"${i}".log & 
    # sleep 5
    # ./contadortest "${_OPERATION}" "${_REPETITIONS}" >> ~/alastria/logs/contadortest_"${_OPERATION}"_"${_TIME}"_"${i}".log & 
done

set +u
set +e
