#!/bin/bash

# We need a copy of NSIS to fix a security vulnerability in the version of NSIS
# that Ubuntu 24.04 ships with.

VERSION=3.11
PACKAGE=nsis-$VERSION-src
export PATH=/opt/gcc-15.1-binutils-2.44-mingw-v13.0.0-i686/bin:$PATH
export PATH=/opt/gcc-15.1-binutils-2.44-mingw-v13.0.0-x86_64/bin:$PATH

# Create a separate scratch directory and change into it.
mkdir    $PACKAGE
cd       $PACKAGE

# Extract the tarball and change into the directory.
tar -xvf ../$PACKAGE.tar.bz2
cd       $PACKAGE

# This package uses SCons as it's build system, which requires all of the
# configuration options to be set as variables.

# Compile the package. Note that we skip the NSIS Menu utility because it needs
# WxWidgets.

scons VERSION=$VERSION                   \
      PREFIX=/opt/nsis-$VERSION          \
      PREFIX_CONF=/opt/nsis-$VERSION/etc \
      SKIPUTILS="NSIS Menu"              \
      STRIP_CP=false                     \
      NSIS_MAX_STRLEN=8192               \
      ZLIB_W32=/opt/gcc-15.1-binutils-2.44-mingw-v13.0.0-i686/lib &&

sudo scons VERSION=$VERSION                   \
           PREFIX=/opt/nsis-$VERSION          \
           PREFIX_CONF=/opt/nsis-$VERSION/etc \
           SKIPUTILS="NSIS Menu"              \
           STRIP_CP=false                     \
           NSIS_MAX_STRLEN=8192               \
           ZLIB_W32=/opt/gcc-15.1-binutils-2.44-mingw-v13.0.0-i686/lib install
