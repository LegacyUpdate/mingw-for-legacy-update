## Notes used while building the toolchain

# Download links:

MinGW: https://sourceforge.net/projects/mingw-w64/files/mingw-w64/mingw-w64-release/mingw-w64-v12.0.0.tar.bz2

GCC: https://ftp.gnu.org/gnu/gcc/gcc-14.2.0/gcc-14.2.0.tar.xz

Binutils: https://sourceware.org/pub/binutils/releases/binutils-2.43.1.tar.xz

GMP: https://ftp.gnu.org/gnu/gmp/gmp-6.3.0.tar.xz

MPFR: https://ftp.gnu.org/gnu/mpfr/mpfr-4.2.2.tar.xz

MPC: https://ftp.gnu.org/gnu/mpc/mpc-1.3.1.tar.gz

zlib: https://www.zlib.net/zlib-1.3.1.tar.gz

nss: https://prdownloads.sourceforge.net/nsis/NSIS%203/3.11/nsis-3.11-src.tar.bz2

# Install dependencies
mingw-w64-i686-dev gcc-mingw-w64 build-essential texinfo bison scons libz-dev bzip2 # Ubuntu does not ship with bzip2 by default
