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

sudo apt-get build-dep binutils
sudo apt-get install devscripts binutils-source gnupg gnupg-agent

export DEBFULLNAME="Zach Riggle"
export DEBEMAIL="zachriggle@gmail.com"
export DIR=$PWD
export VERSION=10

set -ex

rm -rf binutils-*

for RELEASE in precise trusty;
do

for ARCH in aarch64 alpha arm avr cris hppa ia64 m68k mips mips64 msp430 powerpc powerpc64 s390 sh sparc vax xscale;
do
    cd $DIR
    rm -rf binutils-powerpc-cross-0.10
    apt-get source  binutils-powerpc-cross

    mv $DIR/binutils-powerpc-cross-0.10 xxx
    mv xxx $DIR/binutils-$ARCH-cross-0.10

    cd $DIR/binutils-$ARCH-cross-0.10

    MIN_VER_BINUTILS=2.22
    CROSS_ARCH=$ARCH
    CROSS_GNU_TYPE=$CROSS_ARCH-linux-gnu

    cp debian/control.in debian/control

    for var in MIN_VER_BINUTILS CROSS_ARCH CROSS_GNU_TYPE;
    do
        sed -Ei "s|$var|${!var}|ig"               debian/control
    done

    # Actually need to remove CROSS_GNU_TYPE from rules
    sed -Ei 's|CROSS_GNU_TYPE := .*||ig' debian/rules

    # Need to make CROSS_ARCH be a GNU triplet
    sed -Ei "s|CROSS_ARCH.*:=.*|CROSS_ARCH := $CROSS_GNU_TYPE|ig" debian/rules


    dch --distribution $RELEASE --newversion 0.11pwntools$VERSION~$RELEASE --package binutils-$ARCH-cross "Create $ARCH version for pwntools"
    dch --release "Release"
    debuild -S -sa

    # Uncomment for local build
    # dpkg-buildpackage -us -uc -j8

    rm -rf $PWD
    cd ..
done

done

cd $DIR


for CHANGES in *source.changes;
do
   dput ppa:pwntools/binutils $CHANGES
done
