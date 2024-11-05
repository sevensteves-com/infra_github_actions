#!/bin/bash

# Load configuration variables
source "$(dirname "$0")/config.sh"

# Ensure script runs with sudo privileges where necessary
if [[ $EUID -ne 0 ]]; then
    echo "Please run as root or with sudo privileges."
    exit 1
fi

# Fetch the GitHub removal token
echo "Fetching GitHub Actions Runner removal token..."
REMOVAL_TOKEN=$(curl -X POST -H "Authorization: Bearer $GITHUB_PAT" -H "Accept: application/vnd.github+json" -H "X-GitHub-Api-Version: 2022-11-28" "https://api.github.com/orgs/$GITHUB_ORGANIZATION/actions/runners/remove-token" | jq -r .token)

# Check if the removal token was retrieved successfully
if [[ -z "$REMOVAL_TOKEN" || "$REMOVAL_TOKEN" == "null" ]]; then
    echo "Failed to retrieve removal token. Please check your GitHub PAT and organization name."
    exit 1
fi

# Stop the runner service
echo "Stopping the GitHub Actions Runner service..."
cd $RUNNER_DIR
./svc.sh stop

# Uninstall the runner service
echo "Uninstalling the GitHub Actions Runner service..."
./svc.sh uninstall

# Remove the runner from GitHub
echo "Removing the GitHub Actions Runner from GitHub..."
./config.sh remove --token "$REMOVAL_TOKEN"

# Remove the runner directory
echo "Removing GitHub Actions Runner directory..."
rm -rf $RUNNER_DIR

echo "GitHub Actions Runner uninstalled successfully."
