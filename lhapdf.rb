require 'formula'

class Lhapdf < Formula
  homepage 'http://lhapdf.hepforge.org/'
  url 'http://www.hepforge.org/archive/lhapdf/LHAPDF-6.0.4.tar.gz'
  sha1 'fba70c86d41be0be78703711ae74d22c9e4c098f'

  head do
    url 'http://lhapdf.hepforge.org/hg/lhapdf', :using => :hg

    depends_on :autoconf
    depends_on :automake
    depends_on :libtool
    depends_on 'cython' => :python
  end

  depends_on 'boost'
  depends_on 'yaml-cpp'
  depends_on :python

  def install
    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --prefix=#{prefix}
    ]

    system "autoreconf", "-i" if build.head?
    system "./configure", *args
    system "make", "install"
  end

  test do
    system "lhapdf-config --version"
  end

  def caveats; <<-EOS.undent
    PDFs are packaged as downloadable tarballs. These can be installed with, e.g.
      wget http://www.hepforge.org/archive/lhapdf/pdfsets/6.0.0/CT10nlo.tar.gz -O- | tar xz -C #{share}/LHAPDF

    LHAPDF also searches paths in the LHAPDF_DATA_PATH variable for
    PDF sets installed externally.

    EOS
  end
end
