#!/bin/bash
set -u
set -e

echo "Excecute from alastria folder"

_TIME=$(date +%Y%m%d%H%M%S)

cd ~/alastria/cakeshop
java -jar ~/alastria/cakeshop/cakeshop.war 2>> ~/alastria/logs/cakeshop_"${_TIME}".log &

echo "Verify if ~/alastria/logs/ have new files."

set +u
set +e