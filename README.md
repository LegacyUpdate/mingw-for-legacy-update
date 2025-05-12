## Creating a toolchain for use with LegacyUpdate

# Why?

LegacyUpdate's source code generates segmentation faults when using the default
installations of MinGW's cross compiler for x86_64 (and i686) on Ubuntu 22.04.
This has happened before, but is now holding up CI. We eventually intend to
support other architectures as well (ARMv7 and ARM64 through WindowsOnArm), but
this will come later.

## Versions used

GCC 15.1.0

Binutils 2.44

MinGW 12.0.0

GMP 6.3.0

MPFR 4.2.2

MPC 1.3.1

zlib 1.3.1

NSIS 3.11

## Build Process

# Stage 1: Create a directory in /opt to hold our toolchain

```
sudo mkdir -pv /opt/gcc-15.1-binutils-2.44-mingw-v12.0.0-i686
sudo mkdir -pv /opt/gcc-15.1-binutils-2.44-mingw-v12.0.0-x86_64
```

# Stage 2: Download the required files

NOTE: This assumes that you've downloaded this repository from Github and have
already changed into the directory.

```
mkdir scratch
cd    scratch
wget  https://sourceforge.net/projects/mingw-w64/files/mingw-w64/mingw-w64-release/mingw-w64-v12.0.0.tar.bz2
wget  https://ftp.gnu.org/gnu/gcc/gcc-15.1.0/gcc-15.1.0.tar.xz
wget  https://sourceware.org/pub/binutils/releases/binutils-2.44.tar.xz
wget  https://ftp.gnu.org/gnu/mpfr/mpfr-4.2.2.tar.xz
wget  https://ftp.gnu.org/gnu/gmp/gmp-6.3.0.tar.xz
wget  https://ftp.gnu.org/gnu/mpc/mpc-1.3.1.tar.gz
wget  https://www.zlib.net/zlib-1.3.1.tar.gz
wget  https://prdownloads.sourceforge.net/nsis/NSIS%203/3.11/nsis-3.11-src.tar.bz2
```

# Stage 3: Install the headers for the x86 version.

This package includes the headers for the Win32 API provided by MinGW, and is
needed for all of the packages used in the toolchain.

```
sh ../scripts/001-headers-install-x86.sh
```

# Stage 4: Install Binutils for the x86 version.

Binutils provides the linker for the GNU Toolchain as well as several other
useful utilities for using ELF (and in our case later) PE binaries and libraries.
In our case it also includes utilities for creating DLLs, manipulating Windows
resources, and more.

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

This package contains the libraries which implement the Win32 API.

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

# Stage 8.5: Install a copy of zlib (if you are compiling NSIS).

This step is only required if you are also compiling a custom version of NSIS.
For LegacyUpdate, this is required to use NSIS 3.11 on Ubuntu 22.04, which we
need to use to fix a security vulnerability in NSIS. NSIS requires zlib to be
installed in both the x86 and x86_64 versions of MinGW.

```
sh ../scripts/013-zlib-x86.sh
```

# Stage 9: Test the compiler for x86.

The next step is to test our compiler. We'll use a C file that prints a line of
text to the screen. After the file is compiled, you should copy it to a Windows
computer and run it from a command prompt.

First, compile the program with:

```
PATH=/opt/gcc-15.1-binutils-2.44-mingw-v12.0.0-i686/bin:$PATH \
i686-w64-mingw32-gcc ../testfiles/printf.c -o printf-x86.exe -v -Wl,--verbose &> debug.log
```

Next, check to see if a .exe file exists:

```
ls -l *.exe
```

If printf-x86.exe exists, the compiler is now working. If it does not exist,
please review the output of debug.log to determine what happened.

One final check that we can do at this stage is to check the file format of the
program that was just compiled:

```
file printf-x86.exe
```

That should result in the following output:

```
printf-x86.exe: PE32 executable (console) Intel 80386, for MS Windows, 15 sections
```

# Stage 10: Remove some unnecessary files from the toolchain for x86.

There's quite a few things here which just take up space, but won't be needed
in the CI system. We'll remove things like manual pages and info documents, as
well as strip the binaries of debugging information. Without this, the toolchain
is 1.8GB. After this, it is 1.3GB.

```
sudo rm -rf /opt/gcc-15.1-binutils-2.44-mingw-v12.0.0-i686/share/{man,info}
sudo strip --strip-unneeded /opt/gcc-15.1-binutils-2.44-mingw-v12.0.0-i686/lib/*
sudo strip --strip-unneeded /opt/gcc-15.1-binutils-2.44-mingw-v12.0.0-i686/mingw/lib/*
sudo strip --strip-unneeded /opt/gcc-15.1-binutils-2.44-mingw-v12.0.0-i686/bin/*
```

# Stage 11: Create a tarball with the MinGW toolchain just created for x86.

The final part of building the MinGW toolchain for x86 is to compress and upload
it for use with the LegacyUpdate CI system. If you are using these instructions
for another purpose, you can safely ignore this section.

```
cd /opt
sudo tar -cJvf gcc-15.1-binutils-2.44-mingw-v12.0.0-i686.tar.xz gcc-15.1-binutils-2.44-mingw-v12.0.0-i686/
```

# Stage 12: Install the headers for the x86_64 version.

This package includes the headers for the Win32 API provided by MinGW, and is
needed for all of the packages used in the toolchain.

```
sh ../scripts/007-headers-install-x86_64.sh
```

# Stage 13: Install Binutils for the x86_64 version.

Binutils provides the linker for the GNU Toolchain as well as several other
useful utilities for using ELF (and in our case later) PE binaries and libraries.
In our case it also includes utilities for creating DLLs, manipulating Windows
resources, and more.

```
sh ../scripts/008-binutils-x86_64.sh
```

# Stage 14: Install the static version of GCC for the x86_64 version.

The static version is needed to build the MinGW C Runtime, winpthreads, and
other important components which are required to build the full GCC.

```
sh ../scripts/009-gcc-static-x86_64.sh
```

# Stage 15: Install the MinGW C Runtime and other Win32 libraries for the x86_64 version.

This package contains the libraries which implement the Win32 API.

```
sh ../scripts/010-mingw-x86_64.sh
```

# Stage 16: Install the MinGW winpthreads library for the x86_64 version.

This includes a POSIX threading implementation, which is needed by GCC. Some
people have had success building this as part of MinGW's C Runtime, but in our
case, since we're not using any system libraries, we'll need to build it
separately. Without this we'll get a bunch of linker errors.

```
sh ../scripts/011-mingw-winpthreads-x86_64.sh
```

# Stage 17: Install the final version of GCC for the x86_64 version.

This version is a more complete version of GCC that now has all of it's
libraries, includes plugin support, and knows how to use the MinGW C Runtime.

```
sh ../scripts/012-gcc-x86_64.sh
```

# Stage 17.5: Install a copy of zlib (if you are compiling NSIS).

This step is only required if you are also compiling a custom version of NSIS.
For LegacyUpdate, this is required to use NSIS 3.11 on Ubuntu 22.04, which we
need to use to fix a security vulnerability in NSIS. NSIS requires zlib to be
installed in both the x86 and x86_64 versions of MinGW.

```
sh ../scripts/014-zlib-x86_64.sh
```

# Stage 18: Test the compiler for x86_64.

The next step is to test our compiler. We'll use a C file that prints a line of
text to the screen. After the file is compiled, you should copy it to a Windows
computer and run it from a command prompt.

First, compile the program with:

```
PATH=/opt/gcc-15.1-binutils-2.44-mingw-v12.0.0-x86_64/bin:$PATH \
x86_64-w64-mingw32-gcc ../testfiles/printf.c -o printf-x86_64.exe -v -Wl,--verbose &> debug.log
```

Next, check to see if a .exe file exists:

```
ls -l *.exe
```

If printf-x86_64.exe exists, the compiler is now working. If it does not exist,
please review the output of debug.log to determine what happened.

One final check that we can do at this stage is to check the file format of the
program that was just compiled:

```
file printf-x86_64.exe
```

That should result in the following output:

```
./printf-x86_64.exe: PE32+ executable (console) x86-64, for MS Windows, 18 sections
```
# Stage 19: Remove some unnecessary files from the toolchain for x86_64.

There's quite a few things here which just take up space, but won't be needed
in the CI system. We'll remove things like manual pages and info documents, as
well as strip the binaries of debugging information. Without this, the toolchain
is 1.9GB. After this, it is 1.4GB.

```
sudo rm -rf /opt/gcc-15.1-binutils-2.44-mingw-v12.0.0-x86_64/share/{man,info}
sudo strip --strip-unneeded /opt/gcc-15.1-binutils-2.44-mingw-v12.0.0-x86_64/lib/*
sudo strip --strip-unneeded /opt/gcc-15.1-binutils-2.44-mingw-v12.0.0-x86_64/mingw/lib/*
sudo strip --strip-unneeded /opt/gcc-15.1-binutils-2.44-mingw-v12.0.0-x86_64/bin/*
```

# Stage 20: Create a tarball with the MinGW toolchain just created for x86_64.

The final part of building the MinGW toolchain for x86_64 is to compress and upload
it for use with the LegacyUpdate CI system. If you are using these instructions
for another purpose, you can safely ignore this section.

```
cd /opt
sudo tar -cJvf gcc-15.1-binutils-2.44-mingw-v12.0.0-x86_64.tar.xz gcc-15.1-binutils-2.44-mingw-v12.0.0-x86_64/
```

# Stage 21: Create a directory to hold our new copy of NSIS

```
sudo mkdir -pv /opt/nsis-3.11
```

# Stage 22: Install our new copy of NSIS

Because of a security vulnerability, we need to update our copy of NSIS. The
version shipped with Ubuntu 24.04 does not have the fix. If you are installing
a copy of NSIS, make sure that you have installed the optional copies of zlib
with the instructions listed above. If you have an existing toolchain, you can
run scripts 013 and 014 separately without recompiling the entire toolchain.

```
sh ../scripts/015-nsis.sh
```

# Stage 23: Create a tarball with our new copy of NSIS.

```
cd /opt
sudo tar -cJvf nsis-3.11-ubuntu-24.04.tar.xz nsis-3.11/
```
