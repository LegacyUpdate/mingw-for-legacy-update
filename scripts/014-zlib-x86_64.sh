#!/bin/bash
source $(dirname "$0")/variables.in

# This script builds a copy of zlib for MinGW. We need this to compile a new
# version of NSIS.

ARCHITECTURE=x86_64
PACKAGE=mingw64-$ARCHITECTURE-zlib-$ZLIB_V
export PATH=$MINGW_OPT-x86_64/bin:$PATH

# Create a separate scratch directory and change into it.
mkdir $PACKAGE
cd    $PACKAGE

# Extract the tarball and change into the directory.
tar -xvf ../zlib-$ZLIB_V.tar.gz
cd          zlib-$ZLIB_V

# First, tell the zlib build system to use the MinGW version of dllwrap.
sed -i -e "s/dllwrap/x86_64-w64-mingw32-dllwrap/" win32/Makefile.gcc

# Configure the build. Explanations of the options will come after configure.
CC=x86_64-w64-mingw32-gcc              \
./configure --prefix=$MINGW_OPT-x86_64 \
            -shared                    \
            -static                   &&

# --- Descriptions go here ---
# --prefix=<...>: This switch will install the files into that directory.
# -shared and -static: Builds both static and shared versions of zlib.

# --- Compilation and installation instructions go here ---

make -f win32/Makefile.gcc       \
CC="x86_64-w64-mingw32-gcc"      \
AR="x86_64-w64-mingw32-ar"       \
RC="x86_64-w64-mingw32-windres"  \
STRIP="x86_64-w64-mingw32-strip" \
IMPLIB=libz.dll.a                &&

# Install zlib into the toolchain
sudo cp -v zlib.h zconf.h    $MINGW_OPT-x86_64/include
sudo cp -v libz.a libz.dll.a $MINGW_OPT-x86_64/lib
sudo mkdir -pv               $MINGW_OPT-x86_64/lib/pkgconfig
sudo cp -v zlib.pc           $MINGW_OPT-x86_64/lib/pkgconfig
