class Rivet < Formula
  desc "Monte Carlo analysis system"
  homepage "https://rivet.hepforge.org"
  url "https://www.hepforge.org/archive/rivet/Rivet-2.5.4.tar.gz"
  sha256 "2676937cecfda295c1e8597a10f0c2122b8fbb9a1473ef2906cb19a3ddefd8a1"

  head do
    url "http://rivet.hepforge.org/hg/rivet", using: :hg, branch: "tip"

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

  def caveats
    <<~EOS
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
