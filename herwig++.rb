require 'formula'

class Herwigxx < Formula
  homepage 'http://herwig.hepforge.org/'
  url 'http://www.hepforge.org/archive/herwig/Herwig++-2.7.0.tar.gz'
  sha1 'fff87fc7ee69fedf02d2cb28d9e30b2b5e8d6862'

  head do
    url 'http://herwig.hepforge.org/hg/herwig', :using => :hg

    depends_on :autoconf
    depends_on :automake
    depends_on :libtool
    depends_on 'gengetopt'
  end

  depends_on 'thepeg'
  depends_on 'hepmc'
  depends_on 'boost'
  depends_on 'gsl'
  depends_on :python
  depends_on :fortran
  option 'with-check', 'Test during installation'

  def install
    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --prefix=#{prefix}
      --with-thepeg=#{Formula.factory('thepeg').opt_prefix}
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
