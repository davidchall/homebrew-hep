class Applgrid < Formula
  desc "Quickly reproduce NLO calculations with any input PDFs"
  homepage "https://applgrid.hepforge.org"
  url "https://applgrid.hepforge.org/downloads?f=applgrid-1.6.35.tgz"
  sha256 "5a9706ba9875aa958cc4f57abe467baa1ac4b5f01d07133dca3a0cb738cabf36"
  license "GPL-3.0-only"
  revision 1

  livecheck do
    url "https://applgrid.hepforge.org/downloads"
    regex(/href=.*?applgrid[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://ghcr.io/v2/davidchall/hep"
    sha256 cellar: :any, arm64_sonoma: "97fa0006304968864b47b5e60f2ad21dd59e69a03dc7897ea276a6e1a55b9515"
    sha256 cellar: :any, ventura:      "9947ebb029a46737c1de1a445b0c955f019a2525ed1ac638cadb64417deeaf9d"
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
