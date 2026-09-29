#!/bin/bash
set -e

echo "Cloning and building raylib automatically..."
cd /tmp
git clone --depth 1 https://github.com
cd raylib/src

# Compile raylib for Desktop platform with shared/static flags
make PLATFORM=PLATFORM_DESKTOP

# Install raylib headers and binaries to standard system directories
sudo make install

echo "Raylib built and installed successfully!"