#!/bin/bash

set -ex

zpool scrub rpool

while zpool status rpool | grep -q 'scan:  *scrub in progress'; do
   sleep 5
done

zpool status rpool

zpool clear rpool
