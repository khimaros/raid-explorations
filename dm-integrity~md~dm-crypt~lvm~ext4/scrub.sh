#!/bin/bash

set -ex

mdadm --action=check /dev/${ROOT_MD}

mdadm --wait /dev/${ROOT_MD}
