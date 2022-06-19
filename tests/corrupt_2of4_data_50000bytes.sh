#!/bin/bash

set -ex

for disk in sd{a,c}; do
  ./random_write.py /dev/${disk}3 50000
done
