#!/bin/bash

# The first package that we need to install is the MinGW Headers. These headers
# contain an implementation of the Win32 API.

VERSION=12.0.0
ARCHITECTURE=x86
PACKAGE=mingw64-$ARCHITECTURE-headers-$VERSION

# Create a separate scratch directory and change into it.
mkdir    $PACKAGE
cd       $PACKAGE

# Extract the tarball and change into the directory.
tar -xvf ../mingw-w64-v$VERSION.tar.bz2
cd          mingw-w64-v$VERSION

# The source requires that we build it outside of the source tree. We'll work
# around this by creating a separete directory and changing into it.
mkdir build-x86-headers
cd    build-x86-headers

# Set some compiler flags to make sure that we output i486 binaries.
export CFLAGS="-march=i486 -mtune=i486"
export CXXFLAGS="-march=i486 -mtune=i486"

# Configure the headers. Explanations of the options will come after configure.
../mingw-w64-headers/configure --prefix=/opt/mingw64-LegacyUpdate-14.2.0-v1/x86 \
                               --enable-sdk=all                                 \
                               --host=i486-w64-mingw32

# --prefix=/opt/*: This switch will install the files into that directory.
# --enable-sdk=all: Installs all of the headers for MinGW.
# --host=i486-w64-mingw32: Builds files for the i486 version of MinGW.

# This package doesn't do any compilation, so we can just install it!
sudo make install
