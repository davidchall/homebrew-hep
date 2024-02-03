class Sherpa < Formula
  desc "Monte Carlo event generator"
  homepage "https://sherpa-team.gitlab.io"
  url "https://sherpa.hepforge.org/downloads/?f=SHERPA-MC-2.2.15.tar.gz"
  sha256 "df3bcb6b593f6e6eee396294b13c90337f5c3c15c92651753a03e0ce7975864b"
  license "GPL-2.0-only"
  revision 1

  livecheck do
    url "https://sherpa.hepforge.org/downloads"
    regex(/href=.*?SHERPA-MC[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://ghcr.io/v2/davidchall/hep"
    rebuild 2
    sha256 arm64_sonoma: "01b30487fbc94c7b3f4f96b7484235558b5339138cb1a024618bead499967571"
    sha256 ventura:      "6bfabe371ab2643aa98827afa29bebb8900f607f7ed9993fec4bc37ab4697491"
  end

  depends_on "autoconf" => :build
  depends_on "gcc" # for gfortran
  depends_on "sqlite"
  depends_on "fastjet" => :recommended
  depends_on "hepmc3"  => :recommended
  depends_on "lhapdf"  => :recommended
  depends_on "rivet"   => :recommended
  depends_on "hepmc2"  => :optional
  depends_on "root"    => :optional

  def install
    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --enable-analysis
      --enable-gzip
      --with-sqlite3=#{Formula["sqlite"].opt_prefix}
    ]

    args << "--enable-fastjet=#{Formula["fastjet"].opt_prefix}" if build.with? "fastjet"
    args << "--enable-hepmc2=#{Formula["hepmc2"].opt_prefix}"   if build.with? "hepmc2"
    args << "--enable-hepmc3=#{Formula["hepmc3"].opt_prefix}"   if build.with? "hepmc3"
    args << "--enable-lhapdf=#{Formula["lhapdf"].opt_prefix}"   if build.with? "lhapdf"
    args << "--enable-rivet=#{Formula["rivet"].opt_prefix}"     if build.with? "rivet"
    args << "--enable-root=#{Formula["root"].opt_prefix}"       if build.with? "root"

    # rivet requires C++14
    ENV.append "CXXFLAGS", "-std=c++14"

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

    system bin/"Sherpa", "-e", "100"
    if build.with? "hepmc2"
      system bin/"Sherpa", "-e", "100", "EVENT_OUTPUT=HepMC_GenEvent[events]"
      assert_predicate testpath/"events.hepmc2g", :exist?
    end
    if build.with? "hepmc3"
      system bin/"Sherpa", "-e", "100", "EVENT_OUTPUT=HepMC3_GenEvent[events]"
      assert_predicate testpath/"events", :exist?
    end
  end
end
