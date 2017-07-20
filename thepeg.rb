class Thepeg < Formula
  desc "Toolkit for high energy physics event generation"
  homepage "http://herwig.hepforge.org"
  url "http://www.hepforge.org/archive/thepeg/ThePEG-2.1.1.tar.bz2"
  sha256 "e1b0bdc116fbc9a6e598b601f2aa670530cf2e1cd46b4572814a9b0130b10281"

  head do
    url "http://thepeg.hepforge.org/hg/ThePEG", :using => :hg

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  option "with-test", "Test during installation"

  depends_on "gsl"
  depends_on "boost"
  depends_on "hepmc"   => :recommended
  depends_on "rivet"   => :recommended
  depends_on "lhapdf"  => :recommended
  depends_on "fastjet" => :recommended

  def install
    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --enable-stdcxx11
      --without-javagui
    ]

    system "autoreconf", "-i" if build.head?
    system "./configure", *args
    system "make"
    system "make", "check" if build.with? "test"
    system "make", "install"
  end

  test do
    system "setupThePEG", "#{share}/ThePEG/MultiLEP.in"
    system "runThePEG", "MultiLEP.run"
  end
end
