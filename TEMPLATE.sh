#!/bin/bash

# Insert description of the script here

VERSION=
ARCHITECTURE=
PACKAGE=mingw64-$ARCHITECTURE-[packagename]-$VERSION

# Create a separate scratch directory and change into it.
mkdir    $PACKAGE
cd       $PACKAGE

# Extract the tarball and change into the directory.
tar -xvf ../[tarball]
cd       [directory]

# Set some compiler flags to make sure that we output i486 binaries.
# Comment this out if you're not building for i486.
export CFLAGS="-march=i486 -mtune=i486"
export CXXFLAGS="-march=i486 -mtune=i486"

# Configure the headers. Explanations of the options will come after configure.
[Configuration Commands Here]

# --- Descriptions go here ---
# --prefix=/opt/*: This switch will install the files into that directory.

# --- Compilation and installation instructions go here ---
