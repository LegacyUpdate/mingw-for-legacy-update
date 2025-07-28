#!/bin/bash
source $(dirname "$0")/variables.in

# This script installs Binutils, which includes a linker and support programs.

ARCHITECTURE=x86
PACKAGE=mingw64-$ARCHITECTURE-binutils-$BINUTILS_V

# Create a separate scratch directory and change into it.
mkdir $PACKAGE
cd    $PACKAGE

# Extract the tarball and change into the directory.
tar -xvf ../binutils-$BINUTILS_V.tar.xz
cd          binutils-$BINUTILS_V

# This project needs to be built outside of it's source tree. We'll accomodate
# that by making a new directory and changing into it.
mkdir build
cd    build

# First we'll configure Binutils.
../configure --prefix=$MINGW_OPT-i686       \
             --target=i686-w64-mingw32      \
             --disable-nls                  \
             --with-sysroot=$MINGW_OPT-i686 \
             --disable-werror              &&

# --- Descriptions go here ---
# --prefix=<...>: This switch will install the files into that directory.
# --target=i686-w64-mingw32: This outputs files targeting the i686 version
#                            of MinGW.
# --disable-nls:      This switch disables installing files that allow for
#                     diagnostic output in other language than English.
# --with-sysroot:     This switch tells the build system to treat /opt/[...] as
#                     the root directory.
# --disable-werror:   This switch tells the build system to not treat warnings
#                     as errors.

# Next, we'll compile Binutils.
make -j4 &&

# Install Binutils next
sudo make install

# Remove an unnecessary library
sudo rm -v $MINGW_OPT-i686/lib/bfd-plugins/libdep.so

# GCC requires a symlink of 'mingw' to be a mirror of the i686-w64-mingw32
# directory, and it needs to be in the same root.
cd $MINGW_OPT-i686
sudo ln -sfv ./i686-w64-mingw32 ./mingw
sudo ln -sfv ./mingw/include include
