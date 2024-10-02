## Creating a toolchain for use with LegacyUpdate

# Why?

LegacyUpdate's source code generates segmentation faults when using the default
installations of MinGW's cross compiler for x86_64 (and i686) on Ubuntu 22.04.
This has happened before, but is now holding up CI. We eventually intend to
support other architectures as well (ARMv7 and ARM64 through WindowsOnArm), so
this toolchain also supports these other architectures.

# How?

# Versions used

# Build Process
