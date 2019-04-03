class Thepeg < Formula
  desc "Toolkit for high energy physics event generation"
  homepage "https://herwig.hepforge.org"
  url "https://www.hepforge.org/archive/thepeg/ThePEG-2.1.2.tar.bz2"
  sha256 "6a0f675a27e10863d495de069f25b892e532beb32e9cbfe5a58317d015387f49"

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

  depends_on "boost"
  depends_on "gsl"
  depends_on "fastjet" => :recommended
  depends_on "hepmc"   => :recommended
  depends_on "lhapdf"  => :recommended
  depends_on "rivet"   => :recommended

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
