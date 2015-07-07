require 'formula'

class Herwigxx < Formula
  homepage 'http://herwig.hepforge.org/'
  url 'http://www.hepforge.org/archive/herwig/Herwig++-2.7.1.tar.gz'
  sha1 '60c18beeb34f05ff4e4ae3fbf51f9935d58a0a0e'

  head do
    url 'http://herwig.hepforge.org/hg/herwig', :using => :hg

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
    depends_on 'gengetopt'
  end

  depends_on 'thepeg'
  depends_on 'hepmc'
  depends_on 'boost'
  depends_on 'gsl'
  depends_on :python
  depends_on :fortran
  cxxstdlib_check :skip

  option 'with-check', 'Test during installation'

  def install
    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --prefix=#{prefix}
      --with-thepeg=#{Formula['thepeg'].opt_prefix}
      --enable-stdcxx11
    ]

    system "autoreconf", "-i" if build.head?
    system "./configure", *args
    system "make"
    system "make", "check" if build.with? 'check'
    system "make", "install"
  end

  test do
    system "Herwig++ read #{share}/Herwig++/LHC.in"
    system "Herwig++ run LHC.run -N50"
    ohai 'Successfully generated 50 LHC Drell-Yan events.'
  end
end
