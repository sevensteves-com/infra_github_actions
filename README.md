# GitHub Actions Runner Setup and Uninstall Scripts

This repository contains scripts to **install** and **uninstall** a self-hosted GitHub Actions Runner on an Ubuntu server.

## Files

- **`setup_runner.sh`**: Sets up and configures the GitHub Actions Runner as a service on the system.
- **`uninstall_runner.sh`**: Stops, uninstalls, and deregisters the GitHub Actions Runner from GitHub, then cleans up files.
- **`config.sh`**: Configuration file containing variables needed by both setup and uninstall scripts.

## Prerequisites

- **Ubuntu** server.
- **`jq`** installed for parsing JSON responses.
- A **GitHub Personal Access Token (PAT)** with permissions to manage Actions Runners in your organization.

## Setup Instructions

1. **Clone the Repository**

   ```
   git clone https://github.com/your-username/your-repo.git
   cd your-repo
   ```

2. **Edit the Configuration File**

   Open `runner_config.sh` and set your GitHub organization, PAT, and other configurations:

   ```
   # runner_config.sh

   GITHUB_ORGANIZATION="your_organization"
   GITHUB_PAT="your_personal_access_token"
   RUNNER_VERSION="2.320.0"
   RUNNER_DIR="/home/ubuntu/actions-runner"
   ```

3. **Run the Setup Script**

   Execute the `setup_runner.sh` script to set up the GitHub Actions Runner:

   ```
   ./setup_runner.sh
   ```

   This script will:
   - Create the necessary directory.
   - Download, extract, and configure the GitHub Actions Runner.
   - Install and start the runner as a service.

## Uninstall Instructions

To fully remove the GitHub Actions Runner, deregister it from GitHub, and clean up all associated files, run the `uninstall_runner.sh` script:

```
./uninstall_runner.sh
```

This script will:
- Stop and uninstall the runner service.
- Remove the runner from GitHub.
- Delete the runner directory from the server.

## Important Notes

- **Do not run these scripts with `sudo`**; `sudo` is used internally as needed.
- Ensure the **GitHub PAT** in `runner_config.sh` has sufficient permissions to create and remove runners (repo, admin:org).
"""
