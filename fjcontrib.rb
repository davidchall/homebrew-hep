class Fjcontrib < Formula
  desc "Package of contributed add-ons to FastJet"
  homepage "http://fastjet.hepforge.org/contrib/"
  url "http://fastjet.hepforge.org/contrib/downloads/fjcontrib-1.024.tar.gz"
  sha256 "ca8f5520ab8c934ea4458016f66d4d7b08e25e491f8fdb5393572cd411ddde03"

  option "with-test", "Test during installation"

  depends_on "fastjet"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "check" if build.with? "test"
    system "make", "install"
  end
end
