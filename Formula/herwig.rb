require_relative "../lib/download_pdfs"

class Herwig < Formula
  desc "Monte Carlo event generator"
  homepage "https://herwig.hepforge.org"
  url "https://herwig.hepforge.org/downloads/Herwig-7.2.3.tar.bz2"
  sha256 "5599899379b01b09e331a2426d78d39b7f6ec126db2543e9d340aefe6aa50f84"
  license "GPL-3.0-only"
  revision 2

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

  patch :DATA

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

__END__
diff --git a/src/defaults/decayers.in.in b/src/defaults/decayers.in.in
index 8e7e3eb..3be587e 100644
--- a/src/defaults/decayers.in.in
+++ b/src/defaults/decayers.in.in
@@ -24505,4 +24505,4 @@ newdef RadiativeHyperon:Ntry 500
 newdef RadiativeHyperon:Points 10000
 newdef RadiativeHyperon:GenerateIntermediates 0 

-read EvtGenDecayer.in
+@LOAD_EVTGEN_DECAYER@
