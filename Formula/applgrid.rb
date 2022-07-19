class Applgrid < Formula
  desc "Quickly reproduce NLO calculations with any input PDFs"
  homepage "https://applgrid.hepforge.org"
  url "https://applgrid.hepforge.org/downloads?f=applgrid-1.6.28.tgz"
  sha256 "df42ed93ab43e467e87f34b90f426ce5b0f988901a6583f200e2254d08e0ca01"
  license "GPL-3.0-only"

  livecheck do
    url "https://applgrid.hepforge.org/downloads"
    regex(/href=.*?applgrid[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://ghcr.io/v2/davidchall/hep"
    sha256 cellar: :any, monterey: "b2e7cc54c0371d649ab23120eb916239ead89004de77e0e345cfaf1c5d963a60"
    sha256 cellar: :any, big_sur:  "dd2847ec25410db823b7e02ef8c3b4e6b9ea911a6c867bc90bb4d8547d926a1a"
    sha256 cellar: :any, catalina: "11bad5decf5f98bb6341bc16c576e662e788d170076591e1576e974d99d07af4"
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
