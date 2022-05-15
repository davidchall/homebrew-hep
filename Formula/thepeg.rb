class Thepeg < Formula
  desc "Toolkit for high energy physics event generation"
  homepage "https://herwig.hepforge.org"
  url "https://thepeg.hepforge.org/downloads/ThePEG-2.2.3.tar.bz2"
  sha256 "f21473197a761fc32917b08a8d24d2bfaf93ff57f3441fd605da99ac9de5d50b"
  license "GPL-3.0-only"

  livecheck do
    url "https://thepeg.hepforge.org/downloads"
    regex(/href=.*?ThePEG[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://ghcr.io/v2/davidchall/hep"
    sha256 monterey: "4aea760158f86dd841f1b42beed8bef5c131bb1059a3a5ad3f21e8f08f8d3603"
    sha256 big_sur:  "99a54ff9080a78a665a38310481030b5cc68ea3c19aa511e448c7e047bc57106"
    sha256 catalina: "c9a02975c359e7f61582004b2e7c9f2f4b17b719dd44272b166e36e3df1f5a6b"
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
