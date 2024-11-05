#!/bin/bash

# Load configuration variables
source "$(dirname "$0")/runner_config.sh"

# Ensure script runs with sudo privileges where necessary
if [[ $EUID -ne 0 ]]; then
    echo "Please run as root or with sudo privileges."
    exit 1
fi

# Stop the runner service
echo "Stopping the GitHub Actions Runner service..."
cd $RUNNER_DIR
./svc.sh stop

# Uninstall the runner service
echo "Uninstalling the GitHub Actions Runner service..."
./svc.sh uninstall

# Remove the runner directory
echo "Removing GitHub Actions Runner directory..."
rm -rf $RUNNER_DIR

echo "GitHub Actions Runner uninstalled successfully."
