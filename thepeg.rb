class Thepeg < Formula
  desc "Toolkit for high energy physics event generation"
  homepage "http://herwig.hepforge.org"
  url "http://www.hepforge.org/archive/thepeg/ThePEG-2.0.4.tar.bz2"
  sha256 "f3b625b411667e2708995f1d1379b5b8691406853c8c2cca2f4e4e6e062da0e4"

  head do
    url "http://thepeg.hepforge.org/hg/ThePEG", :using => :hg

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  option "with-test", "Test during installation"

  depends_on "gsl"
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
