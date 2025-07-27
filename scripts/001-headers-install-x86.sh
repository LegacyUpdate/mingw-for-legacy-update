#!/bin/bash
source $(dirname "$0")/variables.in

# The first package that we need to install is the MinGW Headers. These headers
# contain an implementation of the Win32 API.

ARCHITECTURE=x86
PACKAGE=mingw64-$ARCHITECTURE-headers-$MINGW_HEADER_V

# Create a separate scratch directory and change into it.
mkdir $PACKAGE
cd    $PACKAGE

# Extract the tarball and change into the directory.
tar -xvf ../mingw-w64-v$MINGW_HEADER_V.tar.bz2
cd          mingw-w64-v$MINGW_HEADER_V

# The source requires that we build it outside of the source tree. We'll work
# around this by creating a separete directory and changing into it.
mkdir build-x86-headers
cd    build-x86-headers

# Configure the headers. Explanations of the options will come after configure.
../mingw-w64-headers/configure              \
  --prefix=$MINGW_OPT-i686/i686-w64-mingw32 \
  --enable-sdk=all                          \
  --host=i686-w64-mingw32                   \
  --with-default-msvcrt=msvcrt

# --prefix=<...>: This switch will install the files into that directory.
# --enable-sdk=all: Installs all of the headers for MinGW.
# --host=i686-w64-mingw32: Builds files for the i686 version of MinGW.
# --with-default-msvcrt: Selects the default Visual C++ Runtime as the
#                        Microsoft Visual C++ Runtime version instead of the
#                        Universal C++ Runtime (which is only compatible with
#                        more recent versions of Windows. For LegacyUpdate, we
#                        need support for Windows 2000 at the earliest).

# This package doesn't do any compilation, so we can just install it!
sudo make install
