require 'formula'

class Lhapdf < Formula
  homepage 'http://lhapdf.hepforge.org/'
  url 'http://www.hepforge.org/archive/lhapdf/LHAPDF-6.1.5.tar.gz'
  sha1 '57bb1e1a97c89459320aa6e5cc3cfcf852b4c862'

  head do
    url 'http://lhapdf.hepforge.org/hg/lhapdf', :using => :hg

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
    depends_on 'cython' => :python
  end

  depends_on 'boost'
  depends_on :python

  def install
    ENV.cxx11

    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --prefix=#{prefix}
      --with-boost=#{Formula["boost"].prefix}
    ]

    system "autoreconf", "-i" if build.head?
    system "./configure", *args
    system "make"
    system "make", "install"
  end

  test do
    system "lhapdf help"
  end

  def caveats; <<-EOS.undent
    PDFs may be downloaded and installed with

      lhapdf install CT10nlo

    At runtime, LHAPDF searches #{share}/LHAPDF
    and paths in LHAPDF_DATA_PATH for PDF sets.

    EOS
  end
end
