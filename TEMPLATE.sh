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

# Configure the headers. Explanations of the options will come after configure.
[Configuration Commands Here]

# --- Descriptions go here ---
# --prefix=/opt/*: This switch will install the files into that directory.

# --- Compilation and installation instructions go here ---
