#!/usr/bin/env bash

title_case()
{
    python -c 'import sys; print " ".join(map(str.title, sys.argv[1:]))' $*
}

ARCHES="aarch64 alpha arm avr cris hppa ia64 m68k mips mips64 msp430 powerpc powerpc64 s390 sparc vax xscale"

for arch in $ARCHES; do

file=binutils-$arch.rb

cat > $file <<EOF
class Binutils$(title_case $arch) < Formula
  homepage "http://www.gnu.org/software/binutils/binutils.html"
  url "http://ftpmirror.gnu.org/binutils/binutils-2.25.tar.gz"
  mirror "http://ftp.gnu.org/gnu/binutils/binutils-2.25.tar.gz"
  sha1 "f10c64e92d9c72ee428df3feaf349c4ecb2493bd"

  # No --default-names option as it interferes with Homebrew builds.

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--target=$arch-unknown-linux-gnu",
                          "--disable-static",
                          "--disable-multilib",
                          "--disable-nls",
                          "--disable-werror"
    system "make"
    system "make", "install"
    system "rm", "-rf", "#{prefix}/share/info"
  end

  test do
    assert `#{bin}/gnm #{bin}/gnm`.include? 'main'
    assert_equal 0, $?.exitstatus
  end
end
EOF

done