#!/usr/bin/bash

KEY_PATH=~/.ssh/id_rsa

if ! test -f "$KEY_PATH"; then
  ssh-keygen ssh-keygen -t rsa -b 4096 -C Azure -N '' -f "$KEY_PATH" <<<y
else
  echo "$KEY_PATH already exists"
fi

echo "This is your public key"
cat "$KEY_PATH"
