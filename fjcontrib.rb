class Fjcontrib < Formula
  desc "Package of contributed add-ons to FastJet"
  homepage "http://fastjet.hepforge.org/contrib/"
  url "http://fastjet.hepforge.org/contrib/downloads/fjcontrib-1.024.tar.gz"
  sha256 "be13d4b6dfc3c6a157c521247576d01abaa90413af07a5f13b1d0e3622225116"

  option "with-test", "Test during installation"

  depends_on "fastjet"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "check" if build.with? "test"
    system "make", "install"
  end
end
