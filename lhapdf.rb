require 'formula'

class Lhapdf < Formula
  homepage 'http://lhapdf.hepforge.org/'
  url 'http://www.hepforge.org/archive/lhapdf/lhapdf-5.8.9.tar.gz'
  sha1 '9f02c2c8042811897b0d047259b0cc75e9ec3d19'

  option 'without-low-memory', "Warning: LHAPDF uses a lot of memory, which OS X complains about"
  option 'with-pdf4lhc', "Only build libraries for sets following PDF4LHC recommendations"

  depends_on :python

  def install
    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --prefix=#{prefix}
    ]

    args << "--enable-low-memory" if build.without? "low-memory"
    args << "--enable-pdfsets=cteq,mstw,nnpdf" if build.with? "pdf4lhc"
    ENV.fortran

    system "./configure", *args
    system "make", "install"
  end

  test do
    system "lhapdf-config --version"
  end

  def caveats; <<-EOS.undent
    PDF sets are downloaded using the lhapdf-getdata script.
    Please consult the homepage for more information.

    LHAPDF also searches paths in the LHAPATH variable for
    PDF sets installed externally.

    EOS
  end
end
