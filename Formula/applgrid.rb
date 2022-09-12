class Applgrid < Formula
  desc "Quickly reproduce NLO calculations with any input PDFs"
  homepage "https://applgrid.hepforge.org"
  url "https://applgrid.hepforge.org/downloads?f=applgrid-1.6.32.tgz"
  sha256 "bca2dfbca5652688a45c5604e8ca0e7dac935ddd11198842f272ebbe3c43c505"
  license "GPL-3.0-only"
  revision 1

  livecheck do
    url "https://applgrid.hepforge.org/downloads"
    regex(/href=.*?applgrid[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://ghcr.io/v2/davidchall/hep"
    sha256 cellar: :any, monterey: "06262f4f18ce2c07a6c88b6f1160e28d9a846f89f753325466ac4864b0f38989"
    sha256 cellar: :any, big_sur:  "2115b5c60f82f50ba40bf1f610b5cb3a93ed7746f3ac498538bf38b099141227"
    sha256 cellar: :any, catalina: "1ee5e7acea696de64b178b8b001c13033886956f50c9dcc1befa7de774c864b4"
  end

  depends_on "gcc" # for gfortran
  depends_on "hoppet" => :recommended
  depends_on "lhapdf" => :recommended
  depends_on "root"   => :recommended

  def install
    args = %W[
      --disable-dependency-tracking
      --disable-silent-rules
      --prefix=#{prefix}
    ]

    args << "--without-root" if build.without? "root"

    system "./configure", *args
    system "make"
    system "make", "install"
  end

  test do
    system bin/"applgrid-config", "--version"
  end
end
