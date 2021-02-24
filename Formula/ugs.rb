class Ugs < Formula
  desc "SLAC Unified Graphics System"
  homepage "http://ftp.riken.jp/pub/iris/ugs"
  url "http://ftp.riken.jp/iris/ugs/ugs.tar.gz"
  version "2.10e"
  sha256 "27bc46e975917bdf149e9ff6997885ffa24b0b1416bdf82ffaea5246b36e1f83"

  depends_on "gcc" => :build
  depends_on "imake" => :build
  depends_on "libice"
  depends_on "libsm"
  depends_on "libx11"
  depends_on "libxext"
  depends_on "libxt"

  patch :p1 do
    url "https://gist.githubusercontent.com/andriish/4df18144d5992c0d3301e3f0069b9218/raw/e18c51f5657b9ec8c519ed25cba838fc353fc35d/patch-ugs-1.txt"
    sha256 "3e8915fbeae36d4ade037940bb74a90208c0c9c53472ffe29632b85bb42c9eca"
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
