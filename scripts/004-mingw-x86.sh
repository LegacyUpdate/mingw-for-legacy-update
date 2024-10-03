#!/bin/bash

# This script installs the MinGW C Runtime and winpthreads libraries.

VERSION=12.0.0
ARCHITECTURE=x86
PACKAGE=mingw64-$ARCHITECTURE-mingw_w64-$VERSION

# Create a separate scratch directory and change into it.
mkdir    $PACKAGE
cd       $PACKAGE

tar -xvf ../mingw-w64-v$VERSION.tar.bz2
cd       mingw-w64-v$VERSION

# Configure the package. Explanations of the options will come after configure.
./configure --prefix=/opt/mingw64-LegacyUpdate-14.2.0-v1/x86       \
            --host=i686-w64-mingw32                                \
            --with-sysroot=/opt/mingw64-LegacyUpdate-14.2.0-v1/x86 \
            --with-libraries=winpthreads &&

# --- Descriptions go here ---
# --prefix=/opt/*: This switch will install the files into that directory.
# --host=i686-w64-mingw32: This uses the cross compiler that we just built.
# --with-libraries=winpthreads: Builds the winpthreads threading implementation.
# --with-sysroot=/opt/*: Treats this directory as the root directory

# --- Compilation and installation instructions go here ---
make &&

sudo make install
