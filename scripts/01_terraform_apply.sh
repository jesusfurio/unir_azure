#!/usr/bin/bash

CURRENT_DIR=$(pwd)

cd ../terraform || exit

terraform init

init=$?
if [ -$init -eq 0 ]; then
  terraform plan
fi

plan=$?
if [ -$plan -eq 0 ]; then
  terraform apply -auto-approve
fi

cd "$CURRENT_DIR" || return
