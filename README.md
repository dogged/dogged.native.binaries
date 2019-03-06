Dogged.Native.Binaries
======================
[![Build Status](https://dev.azure.com/ethomson/dogged.native.binaries/_apis/build/status/dogged.native.binaries?branchName=master)](https://dev.azure.com/ethomson/dogged.native.binaries/_build/latest?definitionId=57&branchName=master)

[Dogged](https://github.com/ethomson/dogged) and is a .NET wrapper around
[libgit2](https://github.com/libgit2/libgit2); since libgit2 is a native
library written in portable C, it requires compilation on your platform.

This repository provides the build scripts and continuous integration
setup to create the Dogged.Native.Binaries nuget package, which itself
provides the native binaries on commonly used platforms (Linux, Windows
and macOS).

These scripts and configuration are available under the MIT license, see
the included file `LICENSE` for details.  libgit2 itself is available
under the GNU Public License (GPL) with a linking exception, see its
[COPYING](https://github.com/libgit2/libgit2/blob/master/COPYING) file
for details.
