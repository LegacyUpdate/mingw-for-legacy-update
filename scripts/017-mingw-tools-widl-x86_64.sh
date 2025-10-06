#!/bin/bash
source $(dirname "$0")/variables.in

# This script installs the MinGW tools that are used by LegacyUpdate. LegacyUpdate
# needs at least widl, but we can add others later if needed (e.g. gendef, genidl,
# genpeimg).

ARCHITECTURE=x86_64
PACKAGE=mingw64-$ARCHITECTURE-mingw_w64-widl-$MINGW_V

# Create a separate scratch directory and change into it.
mkdir $PACKAGE
cd    $PACKAGE

# Make sure that we use our new utilities
export PATH=$MINGW_OPT-x86_64/bin:$PATH

tar -xvf ../mingw-w64-v$MINGW_V.tar.bz2
cd          mingw-w64-v$MINGW_V/mingw-w64-tools/widl

# Configure the package. Note that we're using the --program-prefix option to
# match what is currently used in LegacyUpdate's build/shared.mk file, and to
# prevent conflicts between the x86_64 and i686 versions of the utility.
./configure --prefix=$MINGW_OPT-x86_64             \
            --target=x86_64-w64-mingw32            \
            --program-prefix="x86_64-w64-mingw32-" &&

# Compile widl.
make -j4 &&

# Install widl.
sudo make install
