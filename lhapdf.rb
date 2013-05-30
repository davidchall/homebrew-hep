require 'formula'

class Lhapdf < Formula
  homepage 'http://lhapdf.hepforge.org/'
  url 'http://www.hepforge.org/archive/lhapdf/lhapdf-5.8.9.tar.gz'
  sha1 '9f02c2c8042811897b0d047259b0cc75e9ec3d19'

  devel do
    url 'http://www.hepforge.org/archive/lhapdf/LHAPDF-6.0.0b1.tar.gz'
    sha1 'd6c9348774c25e4df48672cce9823f7d4b4bb45b'
  end

  if build.devel?
    depends_on 'yaml-cpp030'
    depends_on 'boost'
  else
    option 'disable-low-memory', "Warning: LHAPDF uses a lot of memory, which OS X complains about"
    option 'with-pdf4lhc', "Only build libraries for sets following PDF4LHC recommendations"
  end

  def install
    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --prefix=#{prefix}
    ]

    if build.devel?
      args << "--with-yaml-cpp=#{Formula.factory('yaml-cpp030').prefix}"
    else
      args << "--enable-low-memory" if build.without? "disable-low-memory"
      args << "--enable-pdfsets=cteq,mstw,nnpdf" if build.with? "pdf4lhc"
      ENV.fortran
    end

    system "./configure", *args
    system "make", "install"
  end

  test do
    system "lhapdf-config --version"
  end

  def caveats;
    if build.devel?
      s = <<-EOS.undent
      PDFs are packaged as downloadable tarballs. These can be installed with, e.g.
        wget http://www.hepforge.org/archive/lhapdf/pdfsets/6.0.0/CT10nlo.tar.gz -O- | tar xz -C #{share}/LHAPDF

      LHAPDF also searches paths in the LHA_DATA_PATH variable for
      PDF sets installed externally.

      EOS
    else
      s = <<-EOS.undent
      PDF sets are downloaded using the lhapdf-getdata script.
      Please consult the homepage for more information.

      LHAPDF also searches paths in the LHAPATH variable for
      PDF sets installed externally.

      EOS
    end

    return s
  end
end
