#!/bin/bash

# The first package that we need to install is the MinGW Headers. These headers
# contain an implementation of the Win32 API.

VERSION=12.0.0
ARCHITECTURE=x86_64
PACKAGE=mingw64-$ARCHITECTURE-headers-$VERSION

# Create a separate scratch directory and change into it.
mkdir    $PACKAGE
cd       $PACKAGE

# Extract the tarball and change into the directory.
tar -xvf ../mingw-w64-v$VERSION.tar.bz2
cd          mingw-w64-v$VERSION

# The source requires that we build it outside of the source tree. We'll work
# around this by creating a separete directory and changing into it.
mkdir build-x86_64-headers
cd    build-x86_64-headers

# Configure the headers. Explanations of the options will come after configure.
../mingw-w64-headers/configure --prefix=/opt/gcc-14.2-binutils-2.43.1-mingw-v12.0.0-x86_64/x86_64-w64-mingw32 \
                               --enable-sdk=all                                                           \
                               --host=x86_64-w64-mingw32

# --prefix=/opt/*: This switch will install the files into that directory.
# --enable-sdk=all: Installs all of the headers for MinGW.
# --host=x86_64-w64-mingw32: Builds files for the x86_64 version of MinGW.

# This package doesn't do any compilation, so we can just install it!
sudo make install
