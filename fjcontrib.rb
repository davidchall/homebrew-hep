class Fjcontrib < Formula
  homepage 'http://fastjet.hepforge.org/contrib/'
  url 'http://fastjet.hepforge.org/contrib/downloads/fjcontrib-1.023.tar.gz'
  sha256 'ca8f5520ab8c934ea4458016f66d4d7b08e25e491f8fdb5393572cd411ddde03'

  depends_on 'fastjet'
  option 'with-check', 'Test during installation'

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "check" if build.with? 'check'
    system "make", "install"
  end
end
