#!/bin/bash

ssh-keygen -t ed25519 -f /home/autotunnel/.ssh/id_ed25519 -q -P ""
ssh-copy-id -f -i /home/autotunnel/.ssh/id_ed25519 "$1"@"$2"
exit