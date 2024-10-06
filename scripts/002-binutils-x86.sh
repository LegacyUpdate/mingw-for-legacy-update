#!/bin/bash

# This script installs Binutils, which includes a linker and support programs.

VERSION=2.43.1
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
../configure --prefix=/opt/gcc-14.2-binutils-2.43.1-mingw-v12.0.0-i686 \
             --target=i686-w64-mingw32                                 \
             --disable-multilib                                        \
             --disable-nls                                             \
             --disable-werror                                          &&

# --- Descriptions go here ---
# --prefix=/opt/*: This switch will install the files into that directory.
# --target=i686-w64-mingw32: This outputs files targeting the i686 version
#                            of MinGW.
# --disable-multilib: This switch disables multilib support. We don't need it
#                     here, and we'll get a broken toolchain if we enable it.
# --disable-nls:      This switch disables installing files that allow for
#                     diagnostic output in other language than English.
# --disable-werror:   This switch allows the build system to not treat warnings
#                     as errors.

# Next, we'll compile Binutils.
make &&

# Install Binutils next
sudo make install

# Remove an unnecessary library
sudo rm -v /opt/gcc-14.2-binutils-2.43.1-mingw-v12.0.0-i686/lib/bfd-plugins/libdep.so
