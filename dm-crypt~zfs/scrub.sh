#!/bin/bash

set -ex

zpool scrub -w bpool

zpool clear bpool


zpool scrub -w rpool

zpool clear rpool

#zpool resilver rpool
