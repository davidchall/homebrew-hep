class Fjcontrib < Formula
  desc "Package of contributed add-ons to FastJet"
  homepage "https://fastjet.hepforge.org/contrib/"
  url "https://fastjet.hepforge.org/contrib/downloads/fjcontrib-1.041.tar.gz"
  sha256 "31e244728de7787a582479cbed606a1c2fe5fcf3ad3ba1b0134742de5107510c"

  option "with-test", "Test during installation"

  depends_on "fastjet"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "check" if build.with? "test"
    system "make", "install"
  end
end
