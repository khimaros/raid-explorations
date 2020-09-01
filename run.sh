#!/bin/bash

set -ex

[[ -f ./default/apt.sh ]] && ./default/apt.sh

./prepare.sh

./default/format.sh

./install.sh

./default/finish.sh
