#!/bin/bash
source $(dirname "$0")/variables.in

# This script installs the final version of GCC, which should also use the
# libraries installed in the last package.

ARCHITECTURE=x86
PACKAGE=mingw64-$ARCHITECTURE-gcc-final-$GCC_V

# Create a separate scratch directory and change into it.
mkdir $PACKAGE
cd    $PACKAGE

# Extract the tarball and change into the directory.
tar -xvf ../gcc-$GCC_V.tar.xz
cd          gcc-$GCC_V

# Make sure that we use our new utilities
export PATH=$MINGW_OPT-i686/bin:$PATH

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

../configure --prefix=$MINGW_OPT-i686  \
             --target=i686-w64-mingw32 \
             --enable-languages=c,c++  \
             --enable-shared           \
             --disable-multilib        \
             --with-arch=i486          \
             --with-tune=i486          \
             --disable-bootstrap       \
             --enable-threads=posix    \
             --with-sysroot=$MINGW_OPT-i686 &&

# --prefix=<...>: This switch will install the files into that directory.
# --target=i686-w64-mingw32: This switch tells the compiler to target the Win32
#                            architecture.
# --enable-languages=c,c++:  We only need the C and C++ languages to be built.
# --enable-shared:           Install shared libraries for GCC now that we can
#                            use them.
# --disable-multilib:        Disable multilib support since it's not necessary
#                            here and causes problems.
# --with-{arch,tune}=i486:   This switch tells the build system to default to
#                            generating code for i486. This is so that we can
#                            guarantee that whatever code gets output will run
#                            on this CPU.
# --disable-bootstrap: This switch explictly disables performing the bootstrap
#                      process in GCC. The process builds several stages, with
#                      previous stages building the following stages. We don't
#                      need the benefits of performing this process and it
#                      saves time.
# --enable-threads=posix:    This switch allows MinGW to use the winpthreads
#                            library installed by the last package.
# --with-sysroot:            This switch tells the build system to treat
#                            /opt/[...] as the root directory.

# Compile the final version of GCC.
make -j4 &&

# Install the final version of GCC
sudo make install
