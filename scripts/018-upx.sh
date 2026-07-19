#!/bin/bash

source $(dirname "$0")/variables.in

# This script builds UPX and places it in /opt. We need a newer version of UPX
# than what we can get in Ubuntu 24.04 in order to prevent getting false
# positives from VirusTotal.

PACKAGE=upx-$UPX_V

# Create a separate scratch directory and change into it.
mkdir    $PACKAGE
cd       $PACKAGE

# Extract the tarball and change into the directory.
tar -xvf ../upx-$UPX_V-src.tar.xz
cd       upx-$UPX_V-src

# Configuring and compiling UPX is a bit of an adventure every time
# that it needs to be done. It's extremely non-standard, and uses arguments
# to it's Makefile to set pretty much any options - and it uses these flags
# to call CMake. We do want it to check whitespace though, and want -Werror
# to __NOT__ be set due to conflicts with the version of GCC shipped with
# Ubuntu 24.04. We're also using the bundled LZMA SDK to prevent conflicts
# with newer versions of XZ.

make CHECK_WHITESPACE=/bin/true    \
     CXXFLAGS_WERROR=""            \
     UPX_LZMA_VERSION=0x465        \
     UPX_LZMADIR=./vendor/lzma-sdk \
     UPX_CMAKE_CONFIG_FLAGS="-DUPX_CONFIG_DISABLE_WERROR=1 -DUPX_CONFIG_DISABLE_SANITIZE=1" &&

# Check the version to make sure we're not showing a git revision.
./build/release/upx --version &&

# Run the tests. We generally don't do this, but this is our only defense against
# a miscompile that generates illegal instructions on a user's system.
make -C build/release test 2>&1 | tee $DIR/upx-$UPX_V-tests.log

# Continuing with the non-standard, there's no install target in the Makefile!
# We don't need the manual pages or anything special, so let's just create a
# directory and then dump the binary into it.
sudo mkdir -pv /opt/upx-$UPX_V/bin &&
sudo cp -v build/release/upx /opt/upx-$UPX_V/bin
