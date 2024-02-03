require_relative "../lib/download_pdfs"

class Herwig < Formula
  desc "Monte Carlo event generator"
  homepage "https://herwig.hepforge.org"
  url "https://herwig.hepforge.org/downloads/Herwig-7.3.0.tar.bz2"
  sha256 "2624819d2dff105ba952ea1b5cf12eb6f4926d4951774a41907699e2f567686c"
  license "GPL-3.0-only"

  livecheck do
    url "https://herwig.hepforge.org/downloads"
    regex(/href=.*?Herwig[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://ghcr.io/v2/davidchall/hep"
    sha256 ventura:  "9cbb35da540ff13697bc7abb14e44838618a74724e94bef69b706e7a96022137"
    sha256 monterey: "caa9a4f1671723da6a2c49045036dce82eca6ff1335c9d76a93fc260eb975fb9"
  end

  head do
    url "http://herwig.hepforge.org/hg/herwig", using: :hg

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
    depends_on "gengetopt"
  end

  option "with-test", "Test during installation"

  depends_on "boost"
  depends_on "fastjet"
  depends_on "gcc" # for gfortran
  depends_on "gsl"
  depends_on "hepmc3"
  depends_on "thepeg"

  def install
    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --disable-silent-rules
      --prefix=#{prefix}
      --with-boost=#{Formula["boost"].opt_prefix}
      --with-fastjet=#{Formula["fastjet"].opt_prefix}
      --with-gsl=#{Formula["gsl"].opt_prefix}
      --with-thepeg=#{Formula["thepeg"].opt_prefix}
    ]

    # Herwig needs PDFs during the make install and make check phases
    download_pdfs(buildpath/"pdf-sets", %w[CT14lo CT14nlo])

    ENV["FCFLAGS"] = "-fallow-argument-mismatch -fno-range-check"

    system "autoreconf", "-i" if build.head?
    system "./configure", *args
    system "make"
    system "make", "check" if build.with? "test"
    system "make", "install"
  end

  test do
    download_pdfs(testpath/"pdf-sets", %w[CT14lo CT14nlo])

    system bin/"Herwig", "read", share/"Herwig/LHC.in"
    system bin/"Herwig", "run", "LHC.run", "-N", "50"
  end
end
