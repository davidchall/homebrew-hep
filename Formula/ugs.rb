class Ugs < Formula
  desc "SLAC Unified Graphics System"
  homepage "http://ftp.riken.jp/pub/iris/ugs"
  url "http://ftp.riken.jp/iris/ugs/ugs.tar.gz"
  version "2.10e"
  sha256 "27bc46e975917bdf149e9ff6997885ffa24b0b1416bdf82ffaea5246b36e1f83"

  depends_on "homebrew/x11/imake" => :build
  depends_on "gcc" => :build
  depends_on :x11

  patch :p1 do
    url "https://gist.githubusercontent.com/veprbl/80ced2fcd27dddf48d8e/raw/38ac4ffeaf60a067b9753d91bafd859a3459a286/ugs_OSX_fix.patch"
    sha256 "71e9f95cd75561cf7c698da79c6f62902283a30bbf8a2b837dc394baa6762a02"
  end

  def install
    ENV.deparallelize

    system "xmkmf"
    system "make", "Makefiles"
    system "make", "clean"
    system "make"

    lib.install "ugs.a"
  end
end
