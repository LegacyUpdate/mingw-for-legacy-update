#!/bin/bash

# This script installs the final version of GCC, which should also use the
# libraries installed in the last package.

VERSION=14.2.0
ARCHITECTURE=x86
PACKAGE=mingw64-$ARCHITECTURE-gcc-final-$VERSION
GMP_VERSION=6.3.0
MPFR_VERSION=4.2.2
MPC_VERSION=1.3.1

# Create a separate scratch directory and change into it.
mkdir    $PACKAGE
cd       $PACKAGE

# Extract the tarball and change into the directory.
tar -xvf ../gcc-$VERSION.tar.xz
cd       gcc-$VERSION

# Make sure that we use our new utilities
export PATH=/opt/gcc-14.2-binutils-2.44-mingw-v12.0.0-i686/bin:$PATH

# Building GCC requires GMP, MPFR, and MPC. Let's have the build system build them.
tar -xvf ../../gmp-$GMP_VERSION.tar.xz
tar -xvf ../../mpc-$MPC_VERSION.tar.gz
tar -xvf ../../mpfr-$MPFR_VERSION.tar.xz
mv -v gmp-$GMP_VERSION/ gmp
mv -v mpfr-$MPFR_VERSION/ mpfr/
mv -v mpc-$MPC_VERSION/ mpc/

# Create a directory outside of the source tree.

mkdir build
cd    build

../configure --prefix=/opt/gcc-14.2-binutils-2.44-mingw-v12.0.0-i686 \
             --target=i686-w64-mingw32                               \
             --enable-languages=c,c++                                \
             --enable-shared                                         \
             --disable-multilib                                      \
             --with-arch=i486                                        \
             --with-tune=i486                                        \
             --disable-bootstrap                                     \
             --enable-threads=posix                                  \
             --with-sysroot=/opt/gcc-14.2-binutils-2.44-mingw-v12.0.0-i686 &&

# --prefix=/opt/*: This switch will install the files into that directory.
# --target=i686-w64-mingw32: This switch tells the compiler to target the Win32
#                            architecture.
# --enable-languages=c,c++:  We only need the C and C++ languages to be built.
# --enable-shared:           Install shared libraries for GCC now that we can
#                            use them.
# --disable-multilib:        Disable multilib support since it's not necessary
#                            here and causes problems.
# --enable-threads=posix:    This switch allows MinGW to use the winpthreads
#                            library installed by the last package.
# --with-{arch,tune}=i486:   This switch tells the build system to default to
#                            generating code for i486. This is so that we can
#                            guarantee that whatever code gets output will run
#                            on this CPU.
# --with-sysroot:            This switch tells the build system to treat
#                            /opt/[...] as the root directory.

# Compile the final version of GCC.
make -j4 &&

# Install the final version of GCC
sudo make install
