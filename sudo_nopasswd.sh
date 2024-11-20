#!/bin/bash

if [ "$EUID" -ne 0 ]; then
  echo "Please run this script as root or with sudo"
  exit 1
fi

USERNAME="${1:-$USER}"

echo "$USERNAME ALL=(ALL) NOPASSWD:ALL" | sudo tee /etc/sudoers.d/"$USERNAME"-nopasswd

sudo chmod 0440 /etc/sudoers.d/"$USERNAME"-nopasswd
