require_relative "../lib/download_pdfs"

class Fastnlo < Formula
  desc "Fast pQCD calculations for PDF fits"
  homepage "https://fastnlo.hepforge.org"
  url "https://fastnlo.hepforge.org/code/v25/fastnlo_toolkit-2.5.0-2826.tar.gz"
  version "2.5.0"
  sha256 "eda20c6023a41c2ff5ec21d88847ebc6fb522714c38afad2ec1437d9c1a2132d"
  license "GPL-3.0-only"
  revision 2

  livecheck do
    url :homepage
    regex(%r{href=.*?code/v\d+/fastnlo_toolkit[._-]v?(\d+(?:\.\d+)+)-\d+\.t}i)
  end

  bottle do
    root_url "https://ghcr.io/v2/davidchall/hep"
    sha256 cellar: :any, arm64_sonoma: "fe75690381d3901102ced08a6c5c0246165e509d41fea6c2466e07c1afc6c250"
    sha256 cellar: :any, ventura:      "967010a423295554dea21b9f6d145812d04e6da2900fea34f51a3da3855ff7e9"
  end

  option "with-test", "Test during installation"

  depends_on "lhapdf"
  depends_on "fastjet" => :recommended
  depends_on "hoppet"  => :optional
  depends_on "qcdnum"  => :optional
  depends_on "root"    => :optional
  depends_on "yoda"    => :optional

  def install
    args = %W[
      --disable-dependency-tracking
      --disable-silent-rules
      --prefix=#{prefix}
      --with-lhapdf=#{Formula["lhapdf"].opt_prefix}
    ]

    args << "--with-fastjet=#{Formula["fastjet"].opt_prefix}" if build.with? "fastjet"
    args << "--with-hoppet=#{Formula["hoppet"].opt_prefix}"   if build.with? "hoppet"
    args << "--with-qcdnum=#{Formula["qcdnum"].opt_prefix}"   if build.with? "qcdnum"
    args << "--with-root=#{Formula["root"].opt_prefix}"       if build.with? "root"
    args << "--with-yoda=#{Formula["yoda"].opt_prefix}"       if build.with? "yoda"

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
