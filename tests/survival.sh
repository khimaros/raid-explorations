#!/bin/bash

set -e

find /usr/bin -type f -exec md5sum '{}' ';' >/dev/null

find /usr/sbin -type f -exec md5sum '{}' ';' >/dev/null

find /boot -type f -exec md5sum '{}' ';' >/dev/null

echo PASS
