class Fjcontrib < Formula
  desc "Package of contributed add-ons to FastJet"
  homepage "http://fastjet.hepforge.org/contrib/"
  url "http://fastjet.hepforge.org/contrib/downloads/fjcontrib-1.025.tar.gz"
  sha256 "504ff45770e8160f1d3b842ea5962c84faeb9acd2821195b08c7e21a84402dcc

  option "with-test", "Test during installation"

  depends_on "fastjet"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "check" if build.with? "test"
    system "make", "install"
  end
end
