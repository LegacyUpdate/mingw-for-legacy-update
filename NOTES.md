## Notes used while building the toolchain

# Download links:

MinGW: https://sourceforge.net/projects/mingw-w64/files/mingw-w64/mingw-w64-release/mingw-w64-v14.0.0.tar.bz2

GCC: https://ftp.gnu.org/gnu/gcc/gcc-16.1.0/gcc-16.2.0.tar.xz

Binutils: https://sourceware.org/pub/binutils/releases/binutils-2.47.tar.xz

GMP: https://ftp.gnu.org/gnu/gmp/gmp-6.3.0.tar.xz

MPFR: https://ftp.gnu.org/gnu/mpfr/mpfr-4.2.2.tar.xz

MPC: https://ftp.gnu.org/gnu/mpc/mpc-1.4.1.tar.gz

zlib: https://www.zlib.net/zlib-1.3.2.tar.gz

nsis: https://prdownloads.sourceforge.net/nsis/NSIS%203/3.12/nsis-3.12-src.tar.bz2

UPX: https://github.com/upx/upx/releases/download/v5.2.0/upx-5.2.0-src.tar.xz

# Install dependencies
build-essential cmake texinfo bison scons libz-dev bzip2 # Ubuntu does not ship with bzip2 or zlib by default
