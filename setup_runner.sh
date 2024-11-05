#!/bin/bash

# Load configuration variables
source "$(dirname "$0")/config.sh"

# Ensure jq is installed for JSON parsing
if ! command -v jq &> /dev/null; then
    echo "jq is required but not installed. Please install jq and try again."
    exit 1
fi

# Get the hostname of the machine
RUNNER=$(hostname)

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
cd $RUNNER_DIR
./config.sh --url https://github.com/$GITHUB_ORGANIZATION --token "$REGISTRATION_TOKEN" --name "$VM_NAME" --work _work --labels "$VM_NAME,aws,disposable" --unattended

# Install the runner service (requires sudo)
sudo ./svc.sh install

# Start the runner service (requires sudo)
sudo ./svc.sh start

echo "GitHub Actions Runner setup complete for hostname: $RUNNER"
