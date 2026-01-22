#!/usr/bin/env bash
source ../common/arch.sh

title_case()
{
    python -c 'import sys;import re; print(" ".join(map(str.capitalize, [sys.argv[1].replace("_", "")])))' $*
}

# Fetch the latest binutils version using version sorting
echo "Fetching latest binutils version..."
LATEST_VERSION=$(curl -L -s https://ftpmirror.gnu.org/binutils/ | grep -oE 'binutils-[0-9]+\.[0-9]+(\.[0-9]+)?\.tar\.gz' | sed 's/binutils-//;s/\.tar\.gz//' | sort -V | tail -1)

if [ -z "$LATEST_VERSION" ]; then
    echo "Error: Could not fetch latest binutils version"
    exit 1
fi

echo "Latest binutils version: $LATEST_VERSION"

# Set URLs
BINUTILS_URL="https://ftpmirror.gnu.org/binutils/binutils-${LATEST_VERSION}.tar.gz"
BINUTILS_MIRROR="https://ftp.gnu.org/gnu/binutils/binutils-${LATEST_VERSION}.tar.gz"

# Download and calculate SHA256
echo "Downloading binutils-${LATEST_VERSION}.tar.gz to calculate SHA256..."
TEMP_FILE=$(mktemp)
if curl -L "$BINUTILS_URL" -o "$TEMP_FILE"; then
    BINUTILS_SHA256=$(shasum -a 256 "$TEMP_FILE" | awk '{print $1}')
    rm "$TEMP_FILE"
    echo "SHA256: $BINUTILS_SHA256"
else
    echo "Error: Could not download binutils tarball"
    rm "$TEMP_FILE"
    exit 1
fi

for arch in $ARCHES; do

file=binutils-$arch.rb

cat > $file <<EOF
class Binutils$(title_case $arch) < Formula
  homepage "https://www.gnu.org/software/binutils/binutils.html"
  url "$BINUTILS_URL"
  mirror "$BINUTILS_MIRROR"
  sha256 "$BINUTILS_SHA256"

  # No --default-names option as it interferes with Homebrew builds.

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--target=$arch-unknown-linux-gnu",
                          "--disable-static",
                          "--disable-multilib",
                          "--disable-nls",
                          "--disable-werror",
                          "--with-system-zlib"
    system "make", "MAKEINFO=true", "-j"
    system "make", "MAKEINFO=true", "install"
    system "rm", "-rf", "#{prefix}/share/info"
  end

  test do
    assert `#{bin}/gnm #{bin}/gnm`.include? 'main'
    assert_equal 0, $?.exitstatus
  end
end
EOF

done
