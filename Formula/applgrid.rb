class Applgrid < Formula
  desc "Quickly reproduce NLO calculations with any input PDFs"
  homepage "https://applgrid.hepforge.org"
  url "https://applgrid.hepforge.org/downloads?f=applgrid-1.6.35.tgz"
  sha256 "5a9706ba9875aa958cc4f57abe467baa1ac4b5f01d07133dca3a0cb738cabf36"
  license "GPL-3.0-only"

  livecheck do
    url "https://applgrid.hepforge.org/downloads"
    regex(/href=.*?applgrid[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://ghcr.io/v2/davidchall/hep"
    sha256 cellar: :any, ventura:  "4de2471b234046a62e80738fbbb1384e55d7f36b28ffb849395ab1d024bfce0b"
    sha256 cellar: :any, monterey: "9c04c9bbb5e4b6a3415803ade5ed87eaaa36c8a7df25a154f303a2f49cdbb17d"
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
