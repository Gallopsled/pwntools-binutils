#!/usr/bin/env python

#
# This script automates the process of uploading multiple variants
# of binutils to Launchpad.
#
# This process modifies the 'binutils-powerpc-cross' package, which
# is just an empty package that requires 'binutils-source' to be installed,
# and specifies an architecture for the build process.
#
# We change only the lines that are required to identify the package, and
# set the architecture and GNU triplet to build properly.
#
# Afterward, we digitally sign these changes, and upload them to Launchpad.
#
# From here, Launchpad will verify the digital signature on the changes, then
# build the .deb from source on Ubuntu's servers.  Ubuntu/Launchpad then
# digitally signs the .deb file which end-users download.
#
# If you run this process yourself, you should ensure you have a GPG key pair
# installed, and update DEBFULLNAME and DEBEMAIL to reflect your name, and the
# identifier assigned to the GPG key pair.
#
# At no point in time does Pwntools ever modify the source code to binutils,
# and at no point in time does the end-user have to trust Pwntools to not
# backdoor the binaries, since they are built by a trusted third party (Ubuntu).
#
# Optionally, these binaries can be built locally.  Uncomment the line that contains
# 'dpkg-buildpackage' to build the .deb files locally.
#

sudo apt-get build-dep binutils gnupg gnupg-agent
sudo apt-get install devscripts binutils-source

export DEBFULLNAME="Zach Riggle"
export DEBEMAIL="zachriggle@gmail.com"
export DIR=$PWD

set -ex

rm -rf binutils-*

for ARCH in aarch64 alpha arm avr cris hppa ia64 m68k mips mips64 msp430 powerpc powerpc64 s390 sparc vax xscale;
do
    cd $DIR
    rm -rf binutils-powerpc-cross-0.10
    apt-get source binutils-powerpc-cross
    cd $DIR/binutils-powerpc-cross-0.10
    sed -i "s|powerpc|$ARCH|ig" debian/control
    sed -i "s|CROSS_ARCH .*|CROSS_ARCH=$ARCH|ig" debian/rules
    sed -i "s|CROSS_GNU_TYPE .*|CROSS_ARCH=$ARCH-linux-gnu|ig" debian/rules

    dch --newversion 0.11pwntools5 --package binutils-$ARCH-cross "Create $ARCH version for pwntools"
    dch --release "Release"
    debuild -S -sa
    # Uncomment for local build
    # dpkg-buildpackage -us -uc -j8
done

cd $DIR

for CHANGES in *source.changes;
do
   dput ppa:pwntools/binutils $CHANGES
done
