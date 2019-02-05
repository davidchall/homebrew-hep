class Hoppet < Formula
  desc "QCD DGLAP evolution"
  homepage "https://hoppet.hepforge.org"
  url "https://hoppet.hepforge.org/downloads/hoppet-1.1.5.tgz"
  sha256 "41872b2c7ea10344ebbe4260165c24236e17c3d4b14310724eb36577b9c19402"

  option "with-test", "Test during installation"

  depends_on "gcc" # for gfortran

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "check" if build.with? "test"
    system "make", "install"
  end

  test do
    system "#{bin}/hoppet-config", "--libs"
  end
end
