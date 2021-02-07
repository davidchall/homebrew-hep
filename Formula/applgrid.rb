class Applgrid < Formula
  desc "Quickly reproduce NLO calculations with any input PDFs"
  homepage "https://applgrid.hepforge.org"
  url "https://www.hepforge.org/archive/applgrid/applgrid-1.5.46.tgz"
  sha256 "166171623d859c42a75aa9659d780a7a22091b9fd936fb3035b1230b73dedaac"

  depends_on "gcc" # for gfortran
  depends_on "root"
  depends_on "hoppet" => :recommended
  depends_on "lhapdf" => :optional

  cxxstdlib_check :skip

  def install
    ENV.deparallelize

    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/applgrid-config", "--version"
  end
end
