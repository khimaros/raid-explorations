#!/bin/bash

set -ex

for disk in sd{a,b}; do
  ./random_write.py /dev/${disk}3 10000
done
