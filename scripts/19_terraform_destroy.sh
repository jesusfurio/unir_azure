#!/usr/bin/bash

CURRENT_DIR=$(pwd)

cd ../terraform || exit

terraform destroy -auto-approve

cd "$CURRENT_DIR" || return
