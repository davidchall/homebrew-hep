class Hoppet < Formula
  homepage 'http://hoppet.hepforge.org'
  url 'http://hoppet.hepforge.org/downloads/hoppet-1.1.5.tgz'
  sha256 '41872b2c7ea10344ebbe4260165c24236e17c3d4b14310724eb36577b9c19402'

  depends_on :fortran
  option 'with-check', 'Test during installation'

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "check" if build.with? 'check'
    system "make", "install"
  end

  test do
    system "hoppet-config", "--libs"
  end
end
