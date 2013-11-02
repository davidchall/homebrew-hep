require 'formula'

class Herwigxx < Formula
  homepage 'http://herwig.hepforge.org/'
  url 'http://www.hepforge.org/archive/herwig/Herwig++-2.7.0.tar.gz'
  sha1 'fff87fc7ee69fedf02d2cb28d9e30b2b5e8d6862'

  depends_on 'thepeg'
  depends_on 'hepmc'
  depends_on 'boost'
  depends_on 'gsl'
  depends_on :python
  depends_on :fortran

  def install
    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --prefix=#{prefix}
      --with-thepeg=#{Formula.factory('thepeg').prefix}
      --with-gsl=#{Formula.factory('gsl').prefix}
    ]

    system "./configure", *args
    system "make", "install"
  end

  test do
    system "Herwig++ read #{share}/Herwig++/LHC.in"
    system "Herwig++ run LHC.run -N50"
  end
end
