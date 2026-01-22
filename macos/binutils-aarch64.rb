class BinutilsAarch64 < Formula
  homepage "https://www.gnu.org/software/binutils/binutils.html"
  url "https://ftpmirror.gnu.org/binutils/binutils-2.45.1.tar.gz"
  mirror "https://ftp.gnu.org/gnu/binutils/binutils-2.45.1.tar.gz"
  sha256 "2b63ae0ad015eb2755294f127bfd179c1849979dd87b6e8e1a7376964a4323dc"

  # No --default-names option as it interferes with Homebrew builds.

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--target=aarch64-unknown-linux-gnu",
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
    assert .include? 'main'
    assert_equal 0, 0.exitstatus
  end
end
