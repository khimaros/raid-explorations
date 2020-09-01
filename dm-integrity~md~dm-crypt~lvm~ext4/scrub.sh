#!/bin/bash

set -ex

mdadm --action=check /dev/md0

mdadm --wait /dev/md0
