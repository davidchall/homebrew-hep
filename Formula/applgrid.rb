class Applgrid < Formula
  desc "Quickly reproduce NLO calculations with any input PDFs"
  homepage "https://applgrid.hepforge.org"
  url "https://www.hepforge.org/archive/applgrid/applgrid-1.5.15.tgz"
  sha256 "87747fc66318777483e200015b45768d0c8d81f7df6ddc0c70928996ff58d3af"

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
