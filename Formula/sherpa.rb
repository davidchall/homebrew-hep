class Sherpa < Formula
  desc "Monte Carlo event generator"
  homepage "https://sherpa-team.gitlab.io"
  url "https://sherpa.hepforge.org/downloads/?f=SHERPA-MC-2.2.14.tar.gz"
  sha256 "db89ced9c15e1f1fd74cdb02fe1c6742ef9f456266e40e62751b45cfa6d3a364"
  license "GPL-2.0-only"

  livecheck do
    url "https://sherpa.hepforge.org/downloads"
    regex(/href=.*?SHERPA-MC[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://ghcr.io/v2/davidchall/hep"
    sha256 monterey: "eb75d7e28ed087e788dd7b57794deb0897cb3cd36f95e62385f070a84929b462"
    sha256 big_sur:  "749c7a337181b6379c990803ce451981ab89be8f4bcdcb60ac987f3083d4bc4d"
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

    system bin/"Sherpa", "-p", testpath, "-L", testpath, "-e", "100"
  end
end
