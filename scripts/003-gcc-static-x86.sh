#!/bin/bash
source $(dirname "$0")/variables.in

# This script installs a static version of GCC. This is needed because we do
# not have a copy of the MinGW C Runtime installed yet, but we still need a
# way to compile it.

ARCHITECTURE=x86
PACKAGE=mingw64-$ARCHITECTURE-gcc-static-$GCC_V

# Create a separate scratch directory and change into it.
mkdir $PACKAGE
cd    $PACKAGE

# Make sure that we use our new utilities from binutils
export PATH=$MINGW_OPT-i686/bin:$PATH

# Extract the tarball and change into the directory.
tar -xvf ../gcc-$GCC_V.tar.xz
cd          gcc-$GCC_V

# Building GCC requires GMP, MPFR, and MPC. Let's have the build system build them.
tar -xvf ../../gmp-$GMP_V.tar.xz
tar -xvf ../../mpc-$MPC_V.tar.gz
tar -xvf ../../mpfr-$MPFR_V.tar.xz
mv -v gmp-$GMP_V   gmp
mv -v mpfr-$MPFR_V mpfr
mv -v mpc-$MPC_V   mpc

# Create a directory outside of the source tree.

mkdir build
cd    build

../configure --prefix=$MINGW_OPT-i686       \
             --with-sysroot=$MINGW_OPT-i686 \
             --target=i686-w64-mingw32      \
             --enable-languages=c,c++       \
             --disable-shared               \
             --disable-multilib             \
             --disable-threads             &&

# --- Descriptions go here ---
# --prefix=<...>:            This switch will install the files into that
#                            directory.
# --with-sysroot:            This switch tells the build system to treat
#                            /opt/[...] as the root directory.
# --target=i686-w64-mingw32: This switch tells the compiler to target the Win32
#                            architecture.
# --enable-languages=c,c++:  We only need the C and C++ languages to be built.
# --disable-shared:          Install a static version of GCC since we don't have
#                            the MinGW C Runtime yet.
# --disable-multilib:        Disable multilib support since it's not necessary
#                            here and causes problems.
# --disable-threads:         Disable threading support as we don't have a
#                            threading library just yet.

# Compile the static version of GCC.
make all-gcc -j4 &&

# Install the static version of GCC
sudo make install-gcc
