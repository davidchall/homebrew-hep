class Herwig < Formula
  homepage "http://herwig.hepforge.org/"
  url "http://www.hepforge.org/archive/herwig/Herwig-7.0.2.tar.bz2"
  sha256 "58139745e9fe1d3dada1eefffde2016d70cf593004a9bac5838c4ac7f5491a5e"

  head do
    url "http://herwig.hepforge.org/hg/herwig", :using => :hg

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
    depends_on "gengetopt"
  end

  option "with-check", "Test during installation"

  depends_on "thepeg"
  depends_on "hepmc"
  depends_on "boost"
  depends_on "gsl"
  depends_on "madgraph5_amcatnlo" => :optional
  depends_on "openloops" => :optional
  depends_on "vbfnlo" => :optional
  depends_on :python
  depends_on :fortran
  cxxstdlib_check :skip

  def install
    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --disable-silent-rules
      --prefix=#{prefix}
      --with-thepeg=#{Formula["thepeg"].opt_prefix}
      --enable-stdcxx11
    ]
    
    args << "--with-madgraph=#{Formula['madgraph5_amcatnlo'].prefix}" if build.with? "madgraph5_amcatnlo"
    args << "--with-openloops=#{Formula['openloops'].prefix}" if build.with? "openloops"
    args << "--with-vbfnlo=#{Formula['vbfnlo'].prefix}" if build.with? "vbfnlo"

    system "autoreconf", "-i" if build.head?
    system "./configure", *args
    system "make"
    # Herwig runs ThePEG during the make install and make check phases
    system "lhapdf", "install", "MMHT2014lo68cl"
    system "lhapdf", "install", "MMHT2014nlo68cl"
    system "make", "check" if build.with? "check"
    system "make", "install"
  end

  test do
    system "Herwig", "read", share/"Herwig/LHC.in"
    system "Herwig", "run", "LHC.run", "-N", "50"
    ohai "Successfully generated 50 LHC Drell-Yan events."
  end
end
