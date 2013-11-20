require 'formula'

class Applgrid < Formula
  homepage 'http://applgrid.hepforge.org'
  url 'http://www.hepforge.org/archive/applgrid/applgrid-1.4.28.tgz'
  sha1 'a793e0103e338588b790444c6fa7a399c4cf92f2'

  depends_on :fortran
  depends_on 'root'
  depends_on 'hoppet' => :recommended
  depends_on 'lhapdf' => :optional

  def install
    ENV.j1

    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "applgrid-config", "--version"
  end
end
