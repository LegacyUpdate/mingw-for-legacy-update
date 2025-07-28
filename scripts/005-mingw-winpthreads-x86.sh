#!/bin/bash
source $(dirname "$0")/variables.in

# This script installs the winpthreads library for GCC. It needs to be done
# after MinGW, but before GCC.

ARCHITECTURE=x86
PACKAGE=mingw64-$ARCHITECTURE-mingw_w64-winpthreads-$MINGW_PTHREAD_V

# Create a separate scratch directory and change into it.
mkdir $PACKAGE
cd    $PACKAGE

# Make sure that we use our new utilities
export PATH=$MINGW_OPT-i686/bin:$PATH

tar -xvf ../mingw-w64-v$MINGW_PTHREAD_V.tar.bz2
cd          mingw-w64-v$MINGW_PTHREAD_V/mingw-w64-libraries/winpthreads

# Configure the package. Explanations of the options will come after configure.
./configure --prefix=$MINGW_OPT-i686/i686-w64-mingw32 \
            --with-sysroot=$MINGW_OPT-i686            \
            --host=i686-w64-mingw32                   \
            --disable-lib64                           \
            --with-default-msvcrt=msvcrt             &&

# --- Descriptions go here ---
# --prefix=<...>: This switch will install the files into that directory.
# --with-sysroot: This switch tells the build system to treat /opt/[...] as
#                 the root directory.
# --host=i686-w64-mingw32: This uses the cross compiler that we just built.
# --disable-lib64: This switch forces the build system to disable building for
#                  the opposite architecture along with the current one being
#                  targetted.
# --with-default-msvcrt: Selects the default Visual C++ Runtime as the
#                        Microsoft Visual C++ Runtime version instead of the
#                        Universal C++ Runtime (which is only compatible with
#                        more recent versions of Windows. For LegacyUpdate, we
#                        need support for Windows 2000 at the earliest).

make -j4 &&

sudo make install
