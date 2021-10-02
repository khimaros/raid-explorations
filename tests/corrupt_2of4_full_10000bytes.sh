#!/bin/bash

set -ex

for disk in sd{a,b}; do
  ./random_write.py /dev/${disk} 10000 0 0
done
