class Applgrid < Formula
  desc "Quickly reproduce NLO calculations with any input PDFs"
  homepage "https://applgrid.hepforge.org"
  url "https://applgrid.hepforge.org/downloads?f=applgrid-1.6.31.tgz"
  sha256 "ab134e4e7727f964e87b9d4b8ff2eac5794cf5629ae19b87674077f8cd5d168b"
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
