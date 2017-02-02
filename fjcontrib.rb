class Fjcontrib < Formula
  desc "Package of contributed add-ons to FastJet"
  homepage "http://fastjet.hepforge.org/contrib/"
  url "http://fastjet.hepforge.org/contrib/downloads/fjcontrib-1.026.tar.gz"
  sha256 "6bfe538f17fb3fbbf2c0010640ed6eeedfe4317e6b56365e727d44639f76e3d7"

  option "with-test", "Test during installation"

  depends_on "fastjet"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "check" if build.with? "test"
    system "make", "install"
  end
end
