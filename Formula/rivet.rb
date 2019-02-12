class Rivet < Formula
  desc "Monte Carlo analysis system"
  homepage "https://rivet.hepforge.org"
  url "https://www.hepforge.org/archive/rivet/Rivet-2.5.4.tar.gz"
  sha256 "2676937cecfda295c1e8597a10f0c2122b8fbb9a1473ef2906cb19a3ddefd8a1"

  bottle do
    root_url "https://dl.bintray.com/davidchall/bottles-hep"
    sha256 "16defdcd40483c3b1d67845c25d5367c63bf31174e42670f9ac94d386d2491d7" => :high_sierra
    sha256 "0ba3763a5036247b0814f4c8214a05f3513cac2984f9237d78f7b1a534850fe2" => :sierra
    sha256 "d677ba0842bee2bf3268602190dea3359988a95e7255a4b2b8ad11afb9a15e8f" => :el_capitan
    sha256 "61eeec9c28bf0c1430a1e5bbabf511c657b97d94df9c44e12064a0ad34336fa5" => :yosemite
  end

  head do
    url "http://rivet.hepforge.org/hg/rivet", :using => :hg, :branch => "tip"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "cython" => :build
    depends_on "libtool" => :build
  end

  option "with-test", "Test during installation"
  option "without-analyses", "Do not build Rivet analyses"
  option "with-unvalidated", "Build and install unvalidated analyses"

  depends_on "fastjet"
  depends_on "gsl"
  depends_on "hepmc"
  depends_on "yoda"

  def install
    ENV.cxx11

    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --prefix=#{prefix}
      --with-fastjet=#{Formula["fastjet"].opt_prefix}
      --with-hepmc=#{Formula["hepmc"].opt_prefix}
      --with-yoda=#{Formula["yoda"].opt_prefix}
    ]

    args << "--disable-analyses" if build.without? "analyses"
    args << "--enable-unvalidated" if build.with? "unvalidated"

    system "autoreconf", "-i" if build.head?
    system "./configure", *args
    system "make"
    system "make", "check" if build.with? "test"
    system "make", "install"

    prefix.install "test"
    bash_completion.install share/"Rivet/rivet-completion"
  end

  def caveats; <<~EOS
    It may now be necessary to rebuild your Rivet analyses.
    In case of problems, check your RIVET_ANALYSIS_PATH for old analyses.

  EOS
  end

  test do
    system "python", "-c", "import rivet; rivet.version()"
    system "cat #{prefix}/test/testApi.hepmc | rivet -a D0_2008_S7554427"
    ohai "Successfully ran dummy HepMC file through Drell-Yan analysis"
  end
end
