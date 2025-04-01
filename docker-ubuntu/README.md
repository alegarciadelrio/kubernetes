# Docker Setup for Ubuntu

This directory contains a script for installing Docker on Ubuntu systems.

## Overview

The `docker-setup.sh` script automates the installation of Docker Engine on Ubuntu. It follows the official Docker installation procedure, including:

1. Setting up Docker's official GPG key
2. Adding the Docker repository to APT sources
3. Installing Docker packages:
   - docker-ce (Docker Engine)
   - docker-ce-cli (CLI)
   - containerd.io (container runtime)
   - docker-buildx-plugin (BuildKit)
   - docker-compose-plugin (Docker Compose)
4. Creating a docker group and adding the current user to it for non-root access

## Requirements

- Ubuntu operating system
- sudo privileges
- Internet connection

## Usage

1. Make the script executable:
   ```bash
   chmod +x docker-setup.sh
   ```

2. Run the script:
   ```bash
   ./docker-setup.sh
   ```

3. Verify the installation:
   ```bash
   docker --version
   docker compose version
   ```

4. Test Docker with a simple container:
   ```bash
   docker run hello-world
   ```

## Notes

- After installation, you may need to log out and log back in for the group membership changes to take effect.
- This script is intended for Ubuntu systems only. For other distributions, refer to the [official Docker documentation](https://docs.docker.com/engine/install/).
- The script requires an active internet connection to download packages.

## Troubleshooting

If you encounter any issues:

1. Ensure your system is up to date:
   ```bash
   sudo apt-get update && sudo apt-get upgrade
   ```

2. Check if Docker service is running:
   ```bash
   sudo systemctl status docker
   ```

3. If you can't run Docker without sudo after installation, ensure you've logged out and back in, or run:
   ```bash
   newgrp docker
