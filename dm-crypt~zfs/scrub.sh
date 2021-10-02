#!/bin/bash

set -ex

zpool scrub bpool

while zpool status bpool | grep -q 'scan:  *scrub in progress'; do
   sleep 5
done

zpool status bpool

zpool clear bpool

zpool scrub bpool

while zpool status rpool | grep -q 'scan:  *scrub in progress'; do
   sleep 5
done

zpool status rpool

zpool clear rpool
