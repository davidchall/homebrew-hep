class Thepeg < Formula
  desc "Toolkit for high energy physics event generation"
  homepage "https://herwig.hepforge.org"
  url "https://thepeg.hepforge.org/downloads/ThePEG-2.2.3.tar.bz2"
  sha256 "f21473197a761fc32917b08a8d24d2bfaf93ff57f3441fd605da99ac9de5d50b"
  license "GPL-3.0-only"
  revision 1

  livecheck do
    url "https://thepeg.hepforge.org/downloads"
    regex(/href=.*?ThePEG[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://ghcr.io/v2/davidchall/hep"
    sha256 monterey: "4424afa6403ce5a6b0fd375aaddf41125dbfb900450517625fb9a8493e7b860d"
    sha256 big_sur:  "3f53920a7d66478c3c5e324848730722b0c93d1439fac79df0343ba565c3daf3"
    sha256 catalina: "f3c778fd9e7502ddc3d622959b2d9c9008a281ac829123ac86ce11710db4e54c"
  end

  head do
    url "http://thepeg.hepforge.org/hg/ThePEG", using: :hg

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  option "with-test", "Test during installation"

  depends_on "boost"
  depends_on "fastjet"
  depends_on "gsl"
  depends_on "hepmc3"
  depends_on "lhapdf"
  depends_on "rivet" => :recommended

  def install
    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --without-javagui
      --with-boost=#{Formula["boost"].opt_prefix}
      --with-gsl=#{Formula["gsl"].opt_prefix}
      --with-fastjet=#{Formula["fastjet"].opt_prefix}
      --with-hepmc=#{Formula["hepmc3"].opt_prefix}
      --with-hepmcversion=3
      --with-lhapdf=#{Formula["lhapdf"].opt_prefix}
    ]

    args << "--with-rivet=#{Formula["rivet"].opt_prefix}" if build.with? "rivet"

    system "autoreconf", "-i" if build.head?
    system "./configure", *args
    system "make"
    system "make", "check" if build.with? "test"
    system "make", "install"
  end

  test do
    system bin/"setupThePEG", share/"ThePEG/MultiLEP.in"
    system bin/"runThePEG", "MultiLEP.run"
  end
end
