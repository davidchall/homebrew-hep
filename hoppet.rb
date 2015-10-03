class Hoppet < Formula
  homepage 'http://hoppet.hepforge.org'
  url 'http://hoppet.hepforge.org/downloads/hoppet-1.1.5.tgz'
  sha1 'd328f12eb027a53f5333c0d402ba5e6cd8c015d8'

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
