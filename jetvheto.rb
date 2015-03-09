class Jetvheto < Formula
  homepage 'http://jetvheto.hepforge.org'
  url 'http://jetvheto.hepforge.org/downloads/JetVHeto-1.0.0.tgz'
  sha1 'cb28ffacaab59722b25b75d9f2ec094339eeaf0d'

  depends_on 'hoppet'
  depends_on 'lhapdf'

  def install
    system "make"
    bin.install "jetvheto"
    share.install "benchmarks"
    share.install "fixed-order"
  end

  test do
    # Require a PDF set
    curl "-O", "http://www.hepforge.org/archive/lhapdf/pdfsets/6.0/MSTW2008nnlo68cl.tar.gz"
    system "tar xzf MSTW2008nnlo68cl.tar.gz"
    ENV["LHAPDF_DATA_PATH"] = Dir.pwd

    cp "#{share}/fixed-order/H125-LHC8-R04-xmur050-xmuf050-log.fxd", "input.fxd"
    inreplace "input.fxd", "MSTW2008nnlo90cl.LHgrid", "MSTW2008nnlo68cl"

    system "jetvheto -in input.fxd -out output.res -xQ 0.05"
    ohai "Successfully resummed logs for H production at the LHC"
  end
end
