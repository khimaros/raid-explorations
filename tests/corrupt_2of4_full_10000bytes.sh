#!/bin/bash

set -ex

for disk in sd{a,c}; do
  ./random_write.py /dev/${disk} 10000 0 0
done
