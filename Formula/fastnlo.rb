require_relative "../lib/download_pdfs"

class Fastnlo < Formula
  desc "Fast pQCD calculations for PDF fits"
  homepage "https://fastnlo.hepforge.org"
  url "https://fastnlo.hepforge.org/code/v25/fastnlo_toolkit-2.5.0-2826.tar.gz"
  version "2.5.0"
  sha256 "eda20c6023a41c2ff5ec21d88847ebc6fb522714c38afad2ec1437d9c1a2132d"
  license "GPL-3.0-only"
  revision 1

  livecheck do
    url :homepage
    regex(%r{href=.*?code/v\d+/fastnlo_toolkit[._-]v?(\d+(?:\.\d+)+)-\d+\.t}i)
  end

  bottle do
    root_url "https://ghcr.io/v2/davidchall/hep"
    sha256 cellar: :any, monterey: "21b03b289194d24aff0f7bec0cbfea4b4ecf74889ce1eb2643717f2deb0c8b4b"
    sha256 cellar: :any, big_sur:  "f3e40a12ffdf6d182d29a843f2a0cc0d8667caaaecc5035d5ab85d809fd1abf7"
    sha256 cellar: :any, catalina: "ab30fb3cd1097ede185b2d3cf9c794fc094d3490d2212f6789948daa0493abab"
  end

  option "with-test", "Test during installation"

  depends_on "lhapdf"
  depends_on "fastjet" => :recommended
  depends_on "hoppet"  => :optional
  depends_on "qcdnum"  => :optional
  depends_on "root"    => :optional
  depends_on "yoda"    => :optional

  def am_opt(pkg)
    build.with? pkg ? "--with-#{pkg}=#{Formula[pkg].opt_prefix}" : "--without-#{pkg}"
  end

  def install
    args = %W[
      --disable-dependency-tracking
      --disable-silent-rules
      --prefix=#{prefix}
      --with-lhapdf=#{Formula["lhapdf"].opt_prefix}
    ]

    args << am_opt("fastjet")
    args << am_opt("qcdnum")
    args << am_opt("hoppet")
    args << am_opt("yoda")
    args << am_opt("root")

    system "./configure", *args
    system "make"
    if build.with? "test"
      download_pdfs(buildpath/"pdf-sets", "CT10nlo")
      system "make", "check"
    end
    system "make", "install"
  end

  test do
    system bin/"fnlo-tk-cppread", "-h"
  end
end
