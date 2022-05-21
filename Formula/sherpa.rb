class Sherpa < Formula
  desc "Monte Carlo event generator"
  homepage "https://sherpa-team.gitlab.io"
  url "https://sherpa.hepforge.org/downloads/?f=SHERPA-MC-2.2.12.tar.gz"
  sha256 "529464775ca828b9dc965110526f340de743b6003c1e6f8abe2fc14550aed001"
  license "GPL-2.0-only"

  livecheck do
    url "https://sherpa.hepforge.org/downloads"
    regex(/href=.*?SHERPA-MC[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://ghcr.io/v2/davidchall/hep"
    sha256 monterey: "c51468fa8f5579c92eb40a0e83091ae70f335dda7c2d38e1e61b1a703a61159b"
    sha256 big_sur:  "88502aec643f4dd47e57eedc43533d3eac5468caa8032154178142af6e8063cf"
    sha256 catalina: "ea34fbb85c736eaefd9a31103f35c2d71e675c94354e19b4b72ef3c39db3752d"
  end

  depends_on "autoconf" => :build
  depends_on "gcc" # for gfortran
  depends_on "sqlite"
  depends_on "fastjet" => :recommended
  depends_on "hepmc3"  => :recommended
  depends_on "lhapdf"  => :recommended
  depends_on "rivet"   => :recommended
  depends_on "root"    => :optional

  def install
    ENV.cxx11

    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --enable-analysis
      --enable-gzip
      --with-sqlite3=#{Formula["sqlite"].opt_prefix}
    ]

    args << "--enable-fastjet=#{Formula["fastjet"].opt_prefix}" if build.with? "fastjet"
    args << "--enable-hepmc3=#{Formula["hepmc3"].opt_prefix}"   if build.with? "hepmc3"
    args << "--enable-lhapdf=#{Formula["lhapdf"].opt_prefix}"   if build.with? "lhapdf"
    args << "--enable-rivet=#{Formula["rivet"].opt_prefix}"     if build.with? "rivet"
    args << "--enable-root=#{Formula["root"].opt_prefix}"       if build.with? "root"

    system "./configure", *args
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"Run.dat").write <<~EOS
      (beam){
        BEAM_1 = 2212; BEAM_ENERGY_1 = 7000
        BEAM_2 = 2212; BEAM_ENERGY_2 = 7000
      }(beam)

      (processes){
        Process 93 93 -> 11 -11
        Order (*,2)
        Integration_Error 0.05
        End process
      }(processes)

      (selector){
        Mass 11 -11 66 166
      }(selector)

      (mi){
        MI_HANDLER = None   # None or Amisic
      }(mi)
    EOS

    system bin/"Sherpa", "-p", testpath, "-L", testpath, "-e", "100"
  end
end
