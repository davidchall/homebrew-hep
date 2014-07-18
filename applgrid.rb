require 'formula'

class Applgrid < Formula
  homepage 'http://applgrid.hepforge.org'
  url 'http://www.hepforge.org/archive/applgrid/applgrid-1.4.56.tgz'
  sha1 '38ca625f4a5aeaa94db1b62bd93cd654fe31cb32'

  depends_on :fortran
  cxxstdlib_check :skip
  
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
