#!/bin/bash

set -ex

for disk in sd{a,c}; do
  ./random_write.py /dev/${disk} 50000 0 0
done
