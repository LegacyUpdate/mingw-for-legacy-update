#!/bin/bash

# This script installs the MinGW C Runtime.

VERSION=12.0.0
ARCHITECTURE=x86
PACKAGE=mingw64-$ARCHITECTURE-mingw_w64-$VERSION

# Create a separate scratch directory and change into it.
mkdir    $PACKAGE
cd       $PACKAGE

# Make sure that we use our new utilities
export PATH=/opt/gcc-14.2-binutils-2.43.1-mingw-v12.0.0-i686/bin:$PATH

tar -xvf ../mingw-w64-v$VERSION.tar.bz2
cd       mingw-w64-v$VERSION

# Configure the package. Explanations of the options will come after configure.
./configure --prefix=/opt/gcc-14.2-binutils-2.43.1-mingw-v12.0.0-i686/i686-w64-mingw32 \
            --with-sysroot=/opt/gcc-14.2-binutils-2.43.1-mingw-v12.0.0-i686 \
            --host=i686-w64-mingw32                                         &&

# --- Descriptions go here ---
# --prefix=/opt/*: This switch will install the files into that directory.
# --host=i686-w64-mingw32: This uses the cross compiler that we just built.
# --with-sysroot: This switch tells the build system to treat /opt/[...] as
#                 the root directory.

make -j4 &&

sudo make install
