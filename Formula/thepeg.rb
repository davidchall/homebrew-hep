class Thepeg < Formula
  desc "Toolkit for high energy physics event generation"
  homepage "https://herwig.hepforge.org"
  url "https://thepeg.hepforge.org/downloads/ThePEG-2.2.3.tar.bz2"
  sha256 "f21473197a761fc32917b08a8d24d2bfaf93ff57f3441fd605da99ac9de5d50b"

  head do
    url "http://thepeg.hepforge.org/hg/ThePEG", using: :hg

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  option "with-test", "Test during installation"

  depends_on "boost"
  depends_on "gsl"
  depends_on "fastjet" => :recommended
  depends_on "hepmc3"  => :recommended
  depends_on "lhapdf"  => :recommended

  def install
    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --enable-stdcxx11
      --without-javagui
      --with-boost=#{Formula["boost"].opt_prefix}
      --with-gsl=#{Formula["gsl"].opt_prefix}
    ]

    args << "--with-fastjet=#{Formula["fastjet"].opt_prefix}" if build.with? "fastjet"
    args << "--with-hepmc=#{Formula["hepmc3"].opt_prefix}"    if build.with? "hepmc3"
    args << "--with-lhapdf=#{Formula["lhapdf"].opt_prefix}"   if build.with? "lhapdf"

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
