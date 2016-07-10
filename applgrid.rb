class Applgrid < Formula
  desc "Quickly reproduce NLO calculations with any input PDFs"
  homepage "http://applgrid.hepforge.org"
  url "http://www.hepforge.org/archive/applgrid/applgrid-1.4.70.tgz"
  sha256 "37e191e0e8598b7ee486007733b99d39da081dd3411339da2468cb3d66e689fb"

  depends_on :fortran
  cxxstdlib_check :skip

  depends_on "homebrew/science/root"
  depends_on "hoppet" => :recommended
  depends_on "lhapdf" => :optional

  def install
    ENV.j1

    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "applgrid-config", "--version"
  end
end
