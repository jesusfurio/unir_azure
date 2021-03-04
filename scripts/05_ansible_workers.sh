#!/usr/bin/bash

CURRENT_DIR=$(pwd)

cd ../ansible || exit

ansible-playbook -i inventory -u terra workers.yml

cd "$CURRENT_DIR" || return
