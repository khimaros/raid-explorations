#!/bin/bash

set -ex

apt install -y sysbench

mkdir benchmark

pushd benchmark

sysbench fileio prepare

sysbench fileio run --file-test-mode=rndwr --time=0 --events=5000

sysbench fileio run --file-test-mode=seqwr --time=0 --events=20000

popd

rm -rf benchmark
