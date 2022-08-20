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
    sha256 cellar: :any, monterey: "2e3e3ffe97c23eb24c3f395ee2a06b3b9e8592ab7bfd1667509713b5e0ca5bb8"
    sha256 cellar: :any, big_sur:  "4ab060b1878b06eaaee47d99f34f0d68f48042641f7b9891e99aaf9da2067597"
    sha256 cellar: :any, catalina: "022ed6893763da687242f0d4b08cb59a606217a8dd07cec6556b9e5db72088fa"
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
