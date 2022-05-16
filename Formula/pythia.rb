class Pythia < Formula
  desc "Monte Carlo event generator"
  homepage "https://pythia.org"
  url "https://pythia.org/download/pythia83/pythia8307.tgz"
  version "8.307"
  sha256 "e5b14d44aa5943332e32dd5dda9a18fdd1a0085c7198e28d840e04167fa6013d"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://pythia.org/releases"
    regex(/href=.*?pythia(\d)(\d{3})\.t/i)
    strategy :page_match do |page, regex|
      page.scan(regex).map { |match| match.join(".") }
    end
  end

  bottle do
    root_url "https://ghcr.io/v2/davidchall/hep"
    sha256 monterey: "1324fce29466c5f53bb3139598c90cd17939e5b26a499d7cdd8d9e3e9923d7ae"
    sha256 big_sur:  "4b620e01e9684de0f59348176aa57d9389f634918c13f171c9c1f4053964986d"
    sha256 catalina: "1e053044666bf492bb748e187ea581e7b12523424862a884d3d207e32a0337c5"
  end

  depends_on "boost"
  depends_on "hepmc3"
  depends_on "lhapdf"

  def install
    args = %W[
      --prefix=#{prefix}
      --with-hepmc3=#{Formula["hepmc3"].opt_prefix}
      --with-lhapdf6=#{Formula["lhapdf"].opt_prefix}
      --with-boost=#{Formula["boost"].opt_prefix}
    ]

    system "./configure", *args
    system "make"
    system "make", "install"
  end

  test do
    cp_r share/"Pythia8/examples/.", testpath
    system "make", "main01"
    system "./main01"
    system "make", "main41"
    system "./main41"
  end
end
