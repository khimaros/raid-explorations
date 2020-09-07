#!/bin/bash

set -ex

zpool scrub rpool

zpool status rpool

zpool clear rpool
