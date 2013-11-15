require 'formula'

class Hoppet < Formula
  homepage 'http://hoppet.hepforge.org'
  url 'http://hoppet.hepforge.org/downloads/hoppet-1.1.5.tgz'
  sha1 'd328f12eb027a53f5333c0d402ba5e6cd8c015d8'

  depends_on :fortran

  def install

    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"

    system "make", "install"
  end

  test do
    system "hoppet-config"
  end
end
