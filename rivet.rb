class Rivet < Formula
  desc "Monte Carlo analysis system"
  homepage "http://rivet.hepforge.org"
  url "http://www.hepforge.org/archive/rivet/Rivet-2.5.3.tar.gz"
  sha256 "c5641c79f2c508040c37538c70f4ad17b8c8c51f1dc974e37b1e3f37180236be"

  head do
    url "http://rivet.hepforge.org/hg/rivet", :using => :hg, :branch => "tip"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
    depends_on "cython" => :python
  end

  option "with-test", "Test during installation"
  option "without-analyses", "Do not build Rivet analyses"
  option "with-unvalidated", "Build and install unvalidated analyses"

  depends_on "hepmc"
  depends_on "fastjet"
  depends_on "gsl"
  depends_on "yoda"
  depends_on :python

  def install
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

  def caveats; <<-EOS.undent
    It may now be necessary to rebuild your Rivet analyses.
    In case of problems, check your RIVET_ANALYSIS_PATH for old analyses.

    EOS
  end

  test do
    system "cat #{prefix}/test/testApi.hepmc | rivet -a D0_2008_S7554427"
    ohai "Successfully ran dummy HepMC file through Drell-Yan analysis"
  end
end
