## Creating a toolchain for use with LegacyUpdate

# Why?

LegacyUpdate's source code generates segmentation faults when using the default
installations of MinGW's cross compiler for x86_64 (and i686) on Ubuntu 22.04.
This has happened before, but is now holding up CI. We eventually intend to
support other architectures as well (ARMv7 and ARM64 through WindowsOnArm), but
this will come later.

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
sudo mkdir -pv /opt/gcc-14.2-binutils-2.43.1-mingw-v12.0.0-i686
sudo mkdir -pv /opt/gcc-14.2-binutils-2.43.1-mingw-v12.0.0-x86_64
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

# Stage 4: Install Binutils for the x86 version.

```
sh ../scripts/002-binutils-x86.sh
```

# Stage 5: Install the static version of GCC for the x86 version.

The static version is needed to build the MinGW C Runtime, winpthreads, and
other important components which are required to build the full GCC.

```
sh ../scripts/003-gcc-static-x86.sh
```

# Stage 6: Install the MinGW C Runtime and other Win32 libraries for the x86 version.

```
sh ../scripts/004-mingw-x86.sh
```

# Stage 7: Install the MinGW winpthreads library for the x86 version.

This includes a POSIX threading implementation, which is needed by GCC. Some
people have had success building this as part of MinGW's C Runtime, but in our
case, since we're not using any system libraries, we'll need to build it
separately. Without this we'll get a bunch of linker errors.

```
sh ../scripts/005-mingw-winpthreads-x86.sh
```

# Stage 8: Install the final version of GCC for the x86 version.

This version is a more complete version of GCC that now has all of it's
libraries, includes plugin support, and knows how to use the MinGW C Runtime.

```
sh ../scripts/006-gcc-x86.sh
```
