class Fjcontrib < Formula
  desc "Package of contributed add-ons to FastJet"
  homepage "https://fastjet.hepforge.org/contrib/"
  url "https://fastjet.hepforge.org/contrib/downloads/fjcontrib-1.032.tar.gz"
  sha256 "125bae5ab04384596c4bcde1c84a3189034f1e94fd99b6c1025cfac1c1795831"

  option "with-test", "Test during installation"

  depends_on "fastjet" 

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "check" if build.with? "test"
    system "make", "install"
  end
end
