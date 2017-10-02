class BinutilsPowerpc < Formula
  homepage "http://www.gnu.org/software/binutils/binutils.html"
  url "http://ftpmirror.gnu.org/binutils/binutils-2.29.1.tar.gz"
  mirror "http://ftp.gnu.org/gnu/binutils/binutils-2.29.1.tar.gz"
  sha256 "0d9d2bbf71e17903f26a676e7fba7c200e581c84b8f2f43e72d875d0e638771c"

  # No --default-names option as it interferes with Homebrew builds.

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--target=powerpc-unknown-linux-gnu",
                          "--disable-static",
                          "--disable-multilib",
                          "--disable-nls",
                          "--disable-werror"
    system "make", "-j"
    system "make", "install"
    system "rm", "-rf", "#{prefix}/share/info"
  end

  test do
    assert .include? 'main'
    assert_equal 0, 0.exitstatus
  end
end
