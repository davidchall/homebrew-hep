class Ugs < Formula
  desc "SLAC Unified Graphics System"
  homepage "https://ftp.riken.jp/pub/iris/ugs"
  url "https://ftp.riken.jp/iris/ugs/ugs.tar.gz"
  version "2.10e"
  sha256 "27bc46e975917bdf149e9ff6997885ffa24b0b1416bdf82ffaea5246b36e1f83"

  livecheck do
    skip "No version information available"
  end

  bottle do
    root_url "https://ghcr.io/v2/davidchall/hep"
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_sonoma: "e020736a601e25a6f1978a31aed7f3e9be93b980586bccc5db23a368c9669f60"
    sha256 cellar: :any_skip_relocation, ventura:      "3c9bbb99d0b67e3778683a1c56342a7c3f56dd1e0281400c65b0025b47706056"
  end

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
    # fix compiler errors
    inreplace "src/aux.c",
      "#include <stdlib.h>\n",
      "#include <stdlib.h>\n#include <string.h>\n"
    inreplace "src/drivers/rotated.c",
      "#include <stdio.h>\n",
      "#include <stdlib.h>\n#include <stdio.h>\n#include <string.h>\n"

    ENV.deparallelize

    system "xmkmf"
    system "make", "Makefiles"
    system "make", "clean"
    system "make"

    lib.install "ugs.a"
  end

  test do
    assert_predicate lib/"ugs.a", :exist?
  end
end
