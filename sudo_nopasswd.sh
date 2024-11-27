#!/bin/bash

# Ensure the script is run as root
if [ "$EUID" -ne 0 ]; then
  echo "Please run this script as root or with sudo"
  exit 1
fi

# Get the username of the user who invoked sudo
USERNAME="${SUDO_USER:-$USER}"

# Check if the username is valid
if id "$USERNAME" >/dev/null 2>&1; then
  echo "Configuring passwordless sudo for user: $USERNAME"
else
  echo "User $USERNAME does not exist. Exiting."
  exit 1
fi

# Add the sudoers configuration for the user
SUDOERS_FILE="/etc/sudoers.d/${USERNAME}-nopasswd"
echo "$USERNAME ALL=(ALL) NOPASSWD:ALL" > "$SUDOERS_FILE"

# Set the correct permissions
chmod 0440 "$SUDOERS_FILE"

echo "Passwordless sudo has been configured for user: $USERNAME."
