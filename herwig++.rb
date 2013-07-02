require 'formula'

class Herwigxx < Formula
  homepage 'http://herwig.hepforge.org/'
  url 'http://www.hepforge.org/archive/herwig/Herwig++-2.6.3.tar.gz'
  sha1 'eb49c7ae3106c1aaa3c7f33bcb0fcb99e59ef7b8'

  depends_on 'thepeg'
  depends_on 'hepmc'
  depends_on 'boost'
  depends_on 'gsl'
  depends_on :python

  def install
    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --prefix=#{prefix}
      --with-thepeg=#{Formula.factory('thepeg').prefix}
      --with-gsl=#{Formula.factory('gsl').prefix}
    ]

    ENV.fortran
    ENV.append 'LDFLAGS', "-L/usr/lib -lstdc++"

    inreplace 'configure', "if test -x \"$THEPEGPATH/lib/ThePEG/HepMCAnalysis.so\" ; then", "if test -r \"$THEPEGPATH/lib/ThePEG/HepMCAnalysis.so\" ; then"

    system "./configure", *args
    system "make", "install"
  end

  test do
    system "Herwig++ read #{share}/Herwig++/LHC.in"
    system "Herwig++ run LHC.run -N50"
  end
end
