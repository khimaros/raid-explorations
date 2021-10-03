#!/bin/bash

set -ex

zpool scrub -w bpool

zpool clear bpool

zpool status bpool


zpool scrub -w rpool

zpool clear rpool

#zpool resilver rpool

zpool status rpool
