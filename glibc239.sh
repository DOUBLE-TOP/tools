#!/bin/bash

set -e

GLIBC_VERSION="2.39"
INSTALL_DIR="/root/glibc-$GLIBC_VERSION"
BUILD_DIR="/tmp/glibc-build"
SRC_DIR="/tmp/glibc-src"

# Install dependencies
echo "Installing build dependencies..."
sudo apt update
sudo apt install -y build-essential manpages-dev

# Download GLIBC source
mkdir -p "$SRC_DIR"
cd "$SRC_DIR"
echo "Downloading GLIBC $GLIBC_VERSION source..."
wget http://ftp.gnu.org/gnu/libc/glibc-$GLIBC_VERSION.tar.gz

echo "Extracting source..."
tar -xf glibc-$GLIBC_VERSION.tar.gz
cd glibc-$GLIBC_VERSION

# Create build directory
mkdir -p "$BUILD_DIR"
cd "$BUILD_DIR"

echo "Configuring GLIBC..."
"$SRC_DIR/glibc-$GLIBC_VERSION/configure" \
  --prefix="$INSTALL_DIR" \
  --disable-werror

echo "Building GLIBC (this may take 10+ minutes)..."
make -j"$(nproc)"

echo "Installing GLIBC to $INSTALL_DIR..."
make install

# Cleanup
rm -rf "$SRC_DIR" "$BUILD_DIR"

echo -e "\n✅ GLIBC $GLIBC_VERSION installed to $INSTALL_DIR"
