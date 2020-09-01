#!/bin/bash

set -ex

btrfs scrub start -d -B /

btrfs device stats -d -z /

