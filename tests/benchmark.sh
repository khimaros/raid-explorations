#!/bin/bash

set -e

apt install -y sysbench

mkdir benchmark

pushd benchmark

sysbench fileio prepare

for i in 1 2 3 4; do
    echo
    echo "[*] rndwr benchmark #$i"
    sysbench fileio run --file-test-mode=rndwr --time=0 --events=5000 | egrep '(total time|95th percentile):' | sed -r 's/[[:space:]]+/ /g'
done

for i in 1 2 3 4; do
    echo
    echo "[*] seqwr benchmark #$i"
    sysbench fileio run --file-test-mode=seqwr --time=0 --events=20000 | egrep '(total time|95th percentile):' | sed -r 's/[[:space:]]+/ /g'
done

popd

rm -rf benchmark
