# pwntools binutils scripts

[`pwntools`](http://pwntools.com) depends on `binutils` in order to perform assembly and disassembly of various architectures.

This is a repository of binutils installation scripts for various operating systems, specifically for cross-installations (e.g. assembling VAX on Mac OSX).

Select the directory that corresponds to your operating system, and run `install.sh`.  If you're curious or want to audit our methodology files used by `install.sh` are generated with `generate.sh`.

## Ubuntu

**NOTE**: As of Ubuntu 16.04 (Xenial), there are [packages for most architectures](https://launchpad.net/ubuntu/xenial/+source/binutils).  You should just be able to `apt-get install binutils-arm-gnueabihf binutils-mipsel-linux-gnu`.

The Ubuntu installation process uses a [Personal Package Archive (PPA) hosted by Ubuntu's Launchpad](https://launchpad.net/~pwntools/+archive/ubuntu/binutils).  These work by modifying a single `binutils-cross` `.deb` source archive, and changing the architecture.

No source code is changed, as the `binutils-cross` targets rely on the `binutils-source` package being installed, which is completely separate.

The builds are performed by Ubuntu, on Ubuntu's servers, against digitally signed source changes uploaded by pwntools maintainers.

## Mac OS X

The Mac OS X installation process uses the [`homebrew`](http://brew.sh) package manager to build binutils from source.

The scripts generated are based on the original [binutils recipe](https://github.com/Homebrew/homebrew/blob/master/Library/Formula/binutils.rb) used by `homebrew`.

The binaries are built on your machine, with source fetched directly from the gnu.org server.
