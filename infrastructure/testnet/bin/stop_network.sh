#!/bin/bash
set -u
set -e

pkill -f geth || true
pkill -f java

set +u
set +e