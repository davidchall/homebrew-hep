require 'formula'

class Lhapdf < Formula
  homepage 'http://lhapdf.hepforge.org/'
  url 'http://www.hepforge.org/archive/lhapdf/LHAPDF-6.0.5.tar.gz'
  sha1 '5d71a408c2760dd972c8f82a6413dc6a9a87d9f4'

  head do
    url 'http://lhapdf.hepforge.org/hg/lhapdf', :using => :hg

    depends_on :autoconf
    depends_on :automake
    depends_on :libtool
    depends_on 'cython' => :python
  end

  depends_on 'boost'
  depends_on 'cmake' => :build
  depends_on :python

  def install
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

  test do
    system "lhapdf help"
  end

  def caveats; <<-EOS.undent
    LHAPDF searches #{share}/LHAPDF 
    and paths in LHAPDF_DATA_PATH for PDF sets.
    These can be installed with the 'lhapdf' script.

    EOS
  end
end
