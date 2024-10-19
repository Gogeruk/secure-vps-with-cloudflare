#!/bin/bash

### exit immediately if a command exits with a non-zero status
set -e

echo "Setting up UFW default policies..."

### set default policies
sudo ufw default deny incoming
sudo ufw default allow outgoing

### allow SSH connections
sudo ufw allow ssh

### enable UFW
echo "Enabling UFW..."
sudo ufw enable

echo "UFW setup complete."
