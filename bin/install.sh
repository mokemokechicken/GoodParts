#!/bin/sh

ROOT=$(cd $(dirname $0); cd ..; pwd)

cd "${ROOT}"/vendor/state-machine-generator
make
cp smc_compiler "${ROOT}/bin"

