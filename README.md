## Creating a toolchain for use with LegacyUpdate

# Why?

LegacyUpdate's source code generates segmentation faults when using the default
installations of MinGW's cross compiler for x86_64 (and i686) on Ubuntu 22.04.
This has happened before, but is now holding up CI. We eventually intend to
support other architectures as well (ARMv7 and ARM64 through WindowsOnArm), but
this will come later as this is needed for LegacyUpdate 1.10.

## Versions used

GCC 14.2.0

Binutils 2.43.1

MinGW 12.0.0

GMP 6.3.0

MPFR 4.2.1

MPC 1.3.1

## Build Process

# Stage 1: Create a directory in /opt to hold our toolchain

```
sudo mkdir -pv /opt/mingw64-LegacyUpdate-14.2.0-v1
```

# Stage 2: Download the required files

NOTE: This assumes that you've downloaded this repository from Github and have
already changed into the directory.

```
mkdir scratch
cd    scratch
wget  https://sourceforge.net/projects/mingw-w64/files/mingw-w64/mingw-w64-release/mingw-w64-v12.0.0.tar.bz2
wget  https://ftp.gnu.org/gnu/gcc/gcc-14.2.0/gcc-14.2.0.tar.xz
wget  https://sourceware.org/pub/binutils/releases/binutils-2.43.1.tar.xz
wget  https://ftp.gnu.org/gnu/mpfr/mpfr-4.2.1.tar.xz
wget  https://ftp.gnu.org/gnu/gmp/gmp-6.3.0.tar.xz
wget  https://ftp.gnu.org/gnu/mpc/mpc-1.3.1.tar.gz
```

# Stage 3: Install the headers for the x86 version.

```
sh ../scripts/001-headers-install-x86.sh
```
