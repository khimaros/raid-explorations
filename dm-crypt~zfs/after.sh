#!/bin/bash

set -ex

egrep "^.*? (/boot|/boot/efi) " /proc/self/mounts > /etc/fstab

