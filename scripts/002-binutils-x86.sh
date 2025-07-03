#!/bin/bash

# This script installs Binutils, which includes a linker and support programs.

VERSION=2.44
ARCHITECTURE=x86
PACKAGE=mingw64-$ARCHITECTURE-binutils-$VERSION

# Create a separate scratch directory and change into it.
mkdir    $PACKAGE
cd       $PACKAGE

# Extract the tarball and change into the directory.
tar -xvf ../binutils-$VERSION.tar.xz
cd       binutils-$VERSION

# This project needs to be built outside of it's source tree. We'll accomodate
# that by making a new directory and changing into it.
mkdir build
cd    build

# First we'll configure Binutils.
../configure --prefix=/opt/gcc-15.1-binutils-2.44-mingw-v13.0.0-i686       \
             --target=i686-w64-mingw32                                     \
             --disable-nls                                                 \
             --with-sysroot=/opt/gcc-15.1-binutils-2.44-mingw-v13.0.0-i686 \
             --disable-werror                                              &&

# --- Descriptions go here ---
# --prefix=/opt/*: This switch will install the files into that directory.
# --target=i686-w64-mingw32: This outputs files targeting the i686 version
#                            of MinGW.
# --disable-nls:      This switch disables installing files that allow for
#                     diagnostic output in other language than English.
# --disable-werror:   This switch tells the build system to not treat warnings
#                     as errors.
# --with-sysroot:     This switch tells the build system to treat /opt/[...] as
#                     the root directory.

# Next, we'll compile Binutils.
make -j4 &&

# Install Binutils next
sudo make install

# Remove an unnecessary library
sudo rm -v /opt/gcc-15.1-binutils-2.44-mingw-v13.0.0-i686/lib/bfd-plugins/libdep.so

# GCC requires a symlink of 'mingw' to be a mirror of the i686-w64-mingw32
# directory, and it needs to be in the same root.
cd /opt/gcc-15.1-binutils-2.44-mingw-v13.0.0-i686
sudo ln -sfv ./i686-w64-mingw32 ./mingw
sudo ln -sfv ./mingw/include include
