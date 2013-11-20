require 'formula'

class Jetvheto < Formula
  homepage 'http://jetvheto.hepforge.org'
  url 'http://jetvheto.hepforge.org/downloads/JetVHeto-1.0.0.tgz'
  sha1 'cb28ffacaab59722b25b75d9f2ec094339eeaf0d'

  depends_on 'hoppet'
  depends_on 'lhapdf'
  depends_on :fortran

  def install
    system "make"
    bin.install "jetvheto"
    share.install "benchmarks"
    share.install "fixed-order"
  end

  test do
    system "#{bin}/jetvheto", "-in", "#{share}/fixed-order/H125-LHC8-R04-xmur050-xmuf050-log.fxd", 
                              "-xQ", "0.50",
                              "-out", "H125.res"
  end
end
