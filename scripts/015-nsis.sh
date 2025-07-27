#!/bin/bash
source $(dirname "$0")/variables.in

# We need a copy of NSIS to fix a security vulnerability in the version of NSIS
# that Ubuntu 24.04 ships with.

PACKAGE=nsis-$NSIS_V-src
export PATH=$MINGW_OPT-i686/bin:$PATH
export PATH=$MINGW_OPT-x86_64/bin:$PATH

# Create a separate scratch directory and change into it.
mkdir $PACKAGE
cd    $PACKAGE

# Extract the tarball and change into the directory.
tar -xvf ../$PACKAGE.tar.bz2
cd          $PACKAGE

# This package uses SCons as it's build system, which requires all of the
# configuration options to be set as variables.

# Compile the package. Note that we skip the NSIS Menu utility because it needs
# WxWidgets.

scons VERSION=$NSIS_V                   \
      PREFIX=/opt/nsis-$NSIS_V          \
      PREFIX_CONF=/opt/nsis-$NSIS_V/etc \
      SKIPUTILS="NSIS Menu"             \
      STRIP_CP=false                    \
      NSIS_MAX_STRLEN=8192              \
      ZLIB_W32=$MINGW_OPT-i686/lib &&

sudo scons VERSION=$NSIS_V                   \
           PREFIX=/opt/nsis-$NSIS_V          \
           PREFIX_CONF=/opt/nsis-$NSIS_V/etc \
           SKIPUTILS="NSIS Menu"             \
           STRIP_CP=false                    \
           NSIS_MAX_STRLEN=8192              \
           ZLIB_W32=$MINGW_OPT-i686/lib install
