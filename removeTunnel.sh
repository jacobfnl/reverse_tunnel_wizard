#!/bin/bash

if [ "$(whoami)" != 'root' ]; then
  echo "You must execute this script as root/sudo."
  echo "Exiting... "
  exit 1
fi

# disable the systemD service and remove
systemctl stop watchmen.service
systemctl disable watchmen.service

rm /etc/systemd/system/watchmen.service

# remove the user
deluser --remove-home autotunnel
