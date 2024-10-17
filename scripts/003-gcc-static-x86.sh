#!/bin/bash

# This script installs a static version of GCC. This is needed because we do
# not have a copy of the MinGW C Runtime installed yet, but we still need a
# way to compile it.

VERSION=14.2.0
ARCHITECTURE=x86
PACKAGE=mingw64-$ARCHITECTURE-gcc-static-$VERSION
GMP_VERSION=6.3.0
MPFR_VERSION=4.2.1
MPC_VERSION=1.3.1

# Create a separate scratch directory and change into it.
mkdir    $PACKAGE
cd       $PACKAGE

# Make sure that we use our new utilities from binutils
export PATH=/opt/gcc-14.2-binutils-2.43.1-mingw-v12.0.0-i686/bin:$PATH

# Extract the tarball and change into the directory.
tar -xvf ../gcc-$VERSION.tar.xz
cd       gcc-$VERSION

# Building GCC requires GMP, MPFR, and MPC. Let's have the build system build them.
tar -xvf ../../gmp-$GMP_VERSION.tar.xz
tar -xvf ../../mpc-$MPC_VERSION.tar.gz
tar -xvf ../../mpfr-$MPFR_VERSION.tar.xz
mv -v gmp-$GMP_VERSION/ gmp
mv -v mpfr-$MPFR_VERSION/ mpfr/
mv -v mpc-$MPC_VERSION/ mpc/

# The expressions are pretty complex to follow. What we are doing here is
# stripping the /mingw prefix from the path. It is hardcoded for some reason,
# and in previous versions of GCC this was fine. libtool interferes here though
# and compilation of everything after MinGW fails as a result.
#sed -i 's/${prefix}\/mingw//${prefix}\//g' configure
#sed -i "s#\\/mingw\\//opt/gcc-14.2-binutils-2.43.1-mingw-v12.0.0-i686//\//\\/}\\/#g" gcc/config/i386/mingw32.h
#             --with-native-system-header-dir=/opt/gcc-14.2-binutils-2.43.1-mingw-v12.0.0-i686/include \

# Create a directory outside of the source tree.

mkdir build
cd    build

../configure --prefix=/opt/gcc-14.2-binutils-2.43.1-mingw-v12.0.0-i686       \
             --with-sysroot=/opt/gcc-14.2-binutils-2.43.1-mingw-v12.0.0-i686 \
             --target=i686-w64-mingw32                                       \
             --enable-languages=c,c++                                        \
             --disable-shared                                                \
             --disable-multilib                                              \
             --disable-threads                                               &&

# --- Descriptions go here ---
# --prefix=/opt/*: This switch will install the files into that directory.
# --target=i686-w64-mingw32: This switch tells the compiler to target the Win32
#                            architecture.
# --enable-languages=c,c++:  We only need the C and C++ languages to be built.
# --disable-shared:          Install a static version of GCC since we don't have
#                            the MinGW C Runtime yet.
# --disable-threads:         Disable threading support as we don't have a
#                            threading library just yet.
# --disable-multilib:        Disable multilib support since it's not necessary
#                            here and causes problems.
# --with-native-system-header-dir: This switch tells GCC to use the headers
#                            installed by this directory when compiling itself.
# --with-sysroot:            This switch tells the build system to treat
#                            /opt/[...] as the root directory.

# Compile the static version of GCC.
make all-gcc -j4 &&

# Install the static version of GCC
sudo make install-gcc
