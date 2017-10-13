class Lhapdf < Formula
  desc "PDF interpolation and evaluation"
  homepage "http://lhapdf.hepforge.org"
  url "http://www.hepforge.org/archive/lhapdf/LHAPDF-6.2.1.tar.gz"
  sha256 "6d57ced88592bfd0feca4b0b50839110780c3a1cd158091c075a155c5917202e"

  head do
    url "http://lhapdf.hepforge.org/hg/lhapdf", :using => :hg

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
    depends_on "cython" => :python
  end

  depends_on :python

  def install
    ENV.cxx11

    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --prefix=#{prefix}
    ]

    system "autoreconf", "-i" if build.head?
    system "./configure", *args
    system "make"
    system "make", "install"
  end

  def caveats; <<-EOS.undent
    PDFs may be downloaded and installed with

      lhapdf install CT10nlo

    At runtime, LHAPDF searches #{share}/LHAPDF
    and paths in LHAPDF_DATA_PATH for PDF sets.

    EOS
  end

  test do
    system "lhapdf", "help"
  end
end
