#!/bin/bash

set -ex

zpool scrub -w bpool

zpool status bpool

zpool clear bpool

zpool scrub -w rpool

zpool status rpool

zpool clear rpool
