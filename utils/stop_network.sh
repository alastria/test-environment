#!/bin/bash
set -u
set -e

pkill -f geth
pkill -f constellation-node

set +u
set +e