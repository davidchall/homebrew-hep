class Thepeg < Formula
  desc "Toolkit for high energy physics event generation"
  homepage "https://herwig.hepforge.org"
  url "https://thepeg.hepforge.org/downloads/ThePEG-2.3.0.tar.bz2"
  sha256 "deec8f22e89bb1a3f31b3b84e8feddf59a69845c9d33fba718f5599ce4a6ae9d"
  license "GPL-3.0-only"

  livecheck do
    url "https://thepeg.hepforge.org/downloads"
    regex(/href=.*?ThePEG[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://ghcr.io/v2/davidchall/hep"
    sha256 ventura:  "d1b95d2a0911425ff1372c3d54074b329420c00ba1bc7e75a03cf3cf97756e20"
    sha256 monterey: "3966dc8e3377fa1e2f87ae967e3522b5e6c0623d4f6e40ebe0bf4f49ff74e880"
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
