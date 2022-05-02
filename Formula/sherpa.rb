class Sherpa < Formula
  desc "Monte Carlo event generator"
  homepage "https://sherpa-team.gitlab.io"
  url "https://sherpa.hepforge.org/downloads/?f=SHERPA-MC-2.2.11.tar.gz"
  sha256 "0eb03f87f7ff3231b294ac40b5532ae8e2ef11d6fac81ee946df14257366c22d"

  depends_on "autoconf" => :build
  depends_on "fastjet"
  depends_on "gcc" # for gfortran
  depends_on "hepmc3"
  depends_on "lhapdf"
  depends_on "sqlite" # configure script does not work with system sqlite

  def install
    ENV.cxx11

    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --enable-analysis
      --enable-gzip
      --enable-fastjet=#{Formula["fastjet"].opt_prefix}
      --enable-hepmc3=#{Formula["hepmc3"].opt_prefix}
      --enable-lhapdf=#{Formula["lhapdf"].opt_prefix}
      --with-sqlite3=#{Formula["sqlite"].opt_prefix}
    ]

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
