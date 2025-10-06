#!/bin/bash
source $(dirname "$0")/variables.in

# This script installs the MinGW C Runtime.

ARCHITECTURE=x86_64
PACKAGE=mingw64-$ARCHITECTURE-mingw_w64-$MINGW_V

# Create a separate scratch directory and change into it.
mkdir $PACKAGE
cd    $PACKAGE

# Make sure that we use our new utilities
export PATH=$MINGW_OPT-x86_64/bin:$PATH

tar -xvf ../mingw-w64-v$MINGW_V.tar.bz2
cd          mingw-w64-v$MINGW_V

# Apply patches to fix problems with stack smashing protection, and provide
# emulation of several functions needed to prevent underflows in the stat32
# functions. Some strange behavior with these functions can cause problems on
# 64-bit versions of Windows XP, Server 2003, Vista, and Server 2008 in particular.
# This gets fixed by providing emulation of _fstat32i64, _stat32i64, _wstat32i64,
# _fstat32, _stat32, and _wstat32 for 64-bit msvcrt builds in MinGW.
patch -Np1 -i ../../patches/001-mingw-stack-smashing-protection-fix.patch &&
patch -Np1 -i ../../patches/002-mingw-underflow-check-stat32i64.patch &&
patch -Np1 -i ../../patches/003-mingw-emulation-_fstat32-_stat32-_wstat32-functions-for-64-bit-msvcrt.patch &&
patch -Np1 -i ../../patches/004-mingw-emulation-_fstat32i64-_stat32i64-_wstat32i64-for-64-bit-msvcrt.patch &&
patch -Np1 -i ../../patches/005-mingw-regenerate-crt_Makefile-after-emulation-fixes.patch &&
patch -Np1 -i ../../patches/006-mingw-check-compiler-support-for-stack-protection.patch &&

# Configure the package. Explanations of the options will come after configure.
./configure --prefix=$MINGW_OPT-x86_64/x86_64-w64-mingw32 \
            --with-sysroot=$MINGW_OPT-x86_64              \
            --host=x86_64-w64-mingw32                     \
            --disable-lib32                               \
            --with-default-msvcrt=msvcrt                 &&

# --- Descriptions go here ---
# --prefix=<...>: This switch will install the files into that directory.
# --with-sysroot: This switch tells the build system to treat /opt/[...] as
#                 the root directory.
# --host=x86_64-w64-mingw32: This uses the cross compiler that we just built.
# --disable-lib32: This switch forces the build system to disable building for
#                  the opposite architecture along with the current one being
#                  targetted.
# --with-default-msvcrt: Selects the default Visual C++ Runtime as the
#                        Microsoft Visual C++ Runtime version instead of the
#                        Universal C++ Runtime (which is only compatible with
#                        more recent versions of Windows. For LegacyUpdate, we
#                        need support for Windows 2000 at the earliest).

make -j4 &&

sudo make install
