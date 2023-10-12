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
    rebuild 1
    sha256 ventura:  "056a0f6551906d014981178c9e8cc6df7c5ff829422f332b5f25adaf560d53d5"
    sha256 monterey: "ca4ac8290e6e214273ccc21f92d65cbf6b8ee59786348771c8403fe3a8d87e4c"
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
