class Thepeg < Formula
  desc "Toolkit for high energy physics event generation"
  homepage "https://herwig.hepforge.org"
  url "https://www.hepforge.org/archive/thepeg/ThePEG-2.1.1.tar.bz2"
  sha256 "e1b0bdc116fbc9a6e598b601f2aa670530cf2e1cd46b4572814a9b0130b10281"

  bottle do
    root_url "https://dl.bintray.com/davidchall/bottles-hep"
    sha256 "a8382b62cc68ff5a5e4a6fe683a95c3060db2fd4a15d2513eb7bc08aded54434" => :high_sierra
    sha256 "9313f687c0d99b20bafde60cf4c76bd788b60fc133ecbf1dfa2c372a307653db" => :sierra
    sha256 "1b5ef62898959d5d6178b92a31802fb8dd783c699321e63bbb161792bc8e3fcc" => :el_capitan
  end

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
    system "#{bin}/setupThePEG", "#{share}/ThePEG/MultiLEP.in"
    system "#{bin}/runThePEG", "MultiLEP.run"
  end
end
