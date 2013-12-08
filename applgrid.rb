require 'formula'

class Applgrid < Formula
  homepage 'http://applgrid.hepforge.org'
  url 'http://www.hepforge.org/archive/applgrid/applgrid-1.4.42.tgz'
  sha1 '9dd3bf4696203403c947c2c5f67ffd611e495f05'

  depends_on :fortran
  depends_on 'homebrew/science/root'
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
