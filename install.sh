#!/bin/sh
set -e

echo "Installing skeleton..."

# Download latest binary
curl -L https://github.com/<you>/<repo>/releases/latest/download/skeleton -o skeleton

# Make executable
chmod +x skeleton

# Move to path
sudo mv skeleton /usr/local/bin/skeleton

echo "Installed successfully!"
echo "Run: skeleton"
