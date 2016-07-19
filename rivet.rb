class Rivet < Formula
  desc "Monte Carlo analysis system"
  homepage "http://rivet.hepforge.org"
  url "http://www.hepforge.org/archive/rivet/Rivet-2.5.0.tar.gz"
  sha256 "a3fc76796208c213b0583bcf41755df00b0695cebd4a217f3e61e8b26ccdc82f"

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

    inreplace "include/Rivet/Tools/Utils.hh", "(int(*)(int)) tolower", "[](const unsigned char i){ return std::tolower(i); }"
    inreplace "include/Rivet/Tools/Utils.hh", "(int(*)(int)) toupper", "[](const unsigned char i){ return std::toupper(i); }"

    system "autoreconf", "-i" if build.head?
    system "./configure", *args
    system "make"
    system "make", "check" if build.with? "test"
    system "make", "install"

    prefix.install "test"
    bash_completion.install share/"Rivet/rivet-completion"
  end

  def caveats; <<-EOS.undent
    Be sure to recompile old analyses!!!
    New versions of Rivet don't always like the old ones!
    Having old analyses in the RIVET_ANALYSIS_PATH can sometimes cause issues.
    EOS
  end
  
  test do
    system "cat #{prefix}/test/testApi.hepmc | rivet -a D0_2008_S7554427"
    ohai "Successfully ran dummy HepMC file through Drell-Yan analysis"
  end
end
