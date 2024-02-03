class Thepeg < Formula
  desc "Toolkit for high energy physics event generation"
  homepage "https://herwig.hepforge.org"
  url "https://thepeg.hepforge.org/downloads/ThePEG-2.3.0.tar.bz2"
  sha256 "ac35979ae89c29608ca92c156a49ff68aace7a5a12a0c92f0a01a833d2d34572"
  license "GPL-3.0-only"
  revision 1

  livecheck do
    url "https://thepeg.hepforge.org/downloads"
    regex(/href=.*?ThePEG[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://ghcr.io/v2/davidchall/hep"
    sha256 arm64_sonoma: "86bc26944d1dae474739190dd587547404b877b8599787c6ae1dc68051d48513"
    sha256 ventura:      "55e8ff9b16d60acce0a8538f6034b5118db13a9d729982d54880ba630fdbe225"
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
