#!/bin/bash

# Load configuration variables
source "$(dirname "$0")/config.sh"

# Get the hostname of the machine
RUNNER=$(hostname)

# Ensure script runs with sudo privileges where necessary
if [[ $EUID -ne 0 ]]; then
    echo "Please run as root or with sudo privileges."
    exit 1
fi

# Create actions-runner directory
mkdir -p $RUNNER_DIR
chown ubuntu:ubuntu $RUNNER_DIR
chmod 0755 $RUNNER_DIR

# Download GitHub Actions Runner
curl -o $RUNNER_DIR/actions-runner.tar.gz -L "https://github.com/actions/runner/releases/download/v${RUNNER_VERSION}/actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz"

# Extract GitHub Actions Runner
tar -xzf $RUNNER_DIR/actions-runner.tar.gz -C $RUNNER_DIR
chown -R ubuntu:ubuntu $RUNNER_DIR

# Fetch GitHub registration token
REGISTRATION_TOKEN=$(curl -X POST -H "Authorization: Bearer $GITHUB_PAT" -H "Accept: application/vnd.github+json" -H "X-GitHub-Api-Version: 2022-11-28" "https://api.github.com/orgs/$GITHUB_ORGANIZATION/actions/runners/registration-token" | jq -r .token)

# Check if the registration token was retrieved successfully
if [[ -z "$REGISTRATION_TOKEN" || "$REGISTRATION_TOKEN" == "null" ]]; then
    echo "Failed to retrieve registration token. Please check your GitHub PAT and organization name."
    exit 1
fi

# Configure GitHub Actions Runner with the system hostname
sudo -u ubuntu bash -c "cd $RUNNER_DIR && ./config.sh --url https://github.com/$GITHUB_ORGANIZATION --token $REGISTRATION_TOKEN --name \"$RUNNER\" --work _work --labels \"$RUNNER\" --unattended"

# Install and start the runner service
cd $RUNNER_DIR
./svc.sh install
./svc.sh start

echo "GitHub Actions Runner setup complete for hostname: $RUNNER"
