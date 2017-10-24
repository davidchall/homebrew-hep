class Lhapdf < Formula
  desc "PDF interpolation and evaluation"
  homepage "https://lhapdf.hepforge.org/"
  url "https://www.hepforge.org/archive/lhapdf/LHAPDF-6.2.1.tar.gz"
  sha256 "6d57ced88592bfd0feca4b0b50839110780c3a1cd158091c075a155c5917202e"

  bottle do
    root_url "https://dl.bintray.com/davidchall/bottles-hep"
    sha256 "9baab43625bb96efeceffa0e909a66f3385d44cbe0eec0cbf019cf7f15f6bbeb" => :high_sierra
    sha256 "550b93a493c3b30fcdb5f2b2326d53758fb8f5d0d76a645eecda6fb239170c05" => :sierra
    sha256 "c61871005b6f6207946de9ae3f5f710a9ec5e695f324b03ac26dc554a547d432" => :el_capitan
    sha256 "7e3c9003ece3bf868496ac3514d5058b0352b16835c4ee124880cfc0e378a00d" => :yosemite
  end

  head do
    url "http://lhapdf.hepforge.org/hg/lhapdf", :using => :hg

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
    depends_on "cython" => :build
  end

  needs :cxx11

  def install
    ENV.cxx11
    inreplace "wrappers/python/setup.py.in", "stdc++", "c++" if ENV.compiler == :clang

    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --prefix=#{prefix}
    ]

    # cython causes ambiguous functions: https://stackoverflow.com/a/37201520/2669425
    args << "--disable-python" if MacOS.version <= :yosemite

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
    system "#{bin}/lhapdf", "help"
    system "python", "-c", "import lhapdf; lhapdf.version()" if MacOS.version > :yosemite
  end
end
