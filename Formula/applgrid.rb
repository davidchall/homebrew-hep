class Applgrid < Formula
  desc "Quickly reproduce NLO calculations with any input PDFs"
  homepage "https://applgrid.hepforge.org"
  url "https://applgrid.hepforge.org/downloads?f=applgrid-1.6.32.tgz"
  sha256 "bca2dfbca5652688a45c5604e8ca0e7dac935ddd11198842f272ebbe3c43c505"
  license "GPL-3.0-only"

  livecheck do
    url "https://applgrid.hepforge.org/downloads"
    regex(/href=.*?applgrid[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://ghcr.io/v2/davidchall/hep"
    sha256 cellar: :any, monterey: "3a7c5052f4d8a59d94faf249b6fb4d4b0e5008934f0423248ccab693ea2adc32"
    sha256 cellar: :any, big_sur:  "a44edad11173836223cabc381f2a97c17d86219162179b7a987d52a028c52911"
    sha256 cellar: :any, catalina: "ee62df2ea1e2f7521766a79427b96b282f09322e2c2382066156c0dd3233c53e"
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
