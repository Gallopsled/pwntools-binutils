#!/usr/bin/env bash
source ../common/arch.sh

title_case()
{
    python -c 'import sys;import re; print(" ".join(map(str.capitalize, [sys.argv[1].replace("_", "")])))' $*
}

for arch in $ARCHES; do

file=binutils-$arch.rb

cat > $file <<EOF
class Binutils$(title_case $arch) < Formula
  homepage "https://www.gnu.org/software/binutils/binutils.html"
  url "https://ftpmirror.gnu.org/binutils/binutils-2.34.tar.gz"
  mirror "https://ftp.gnu.org/gnu/binutils/binutils-2.34.tar.gz"
  sha256 "53537d334820be13eeb8acb326d01c7c81418772d626715c7ae927a7d401cab3"

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
    system "make", "-j"
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
