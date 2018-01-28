class Sherpa < Formula
  desc "Monte Carlo event generator"
  homepage "https://sherpa.hepforge.org"
  url "https://www.hepforge.org/archive/sherpa/SHERPA-MC-2.2.4.tar.gz"
  sha256 "5dc8bccc9a242ead06ce1f8838988b7367641d8989466e0f9d6b7e74fa8e80e7"

  bottle do
    root_url "https://dl.bintray.com/davidchall/bottles-hep"
    sha256 "af4c18f1d17a3772a95bd3fa29e49c66c7e1b88d21367f66e5b67be2766882c1" => :high_sierra
    sha256 "82662b06a6714fb351ff0ab7345266b85058f325c6d9a13c6253be3a94615c2c" => :sierra
    sha256 "9d38a5e2718fb45a092fbb8914135a81e43299cac979ef9ad559f6cc73e6af63" => :el_capitan
  end

  patch :p2 do
    # resolve ambiguous abs calls
    url "https://gist.githubusercontent.com/davidchall/988f3a2859d7957539a84c79a07a0c2f/raw/3369f6052dcde40c63391fbb4c0e7dd7cc8b9d7d/ambiguous-abs.patch"
    sha256 "a66699c49e0bd17af0cdfb37ef271f06ba7c068a74e69c5820abc218ae7f3f72"
  end

  option "with-mpi", "Enable MPI support"

  # Requires changes to MCFM code, so cannot use MCFM formula
  option "with-mcfm", "Enable use of MCFM loops"
  depends_on "gnu-sed" => :build if build.with? "mcfm"

  depends_on "hepmc"     => :recommended
  depends_on "rivet"     => :recommended
  depends_on "lhapdf"    => :recommended
  depends_on "fastjet"   => :recommended
  depends_on "openloops" => :recommended
  depends_on "root"      => :optional
  depends_on "open-mpi" if build.with? "mpi"
  depends_on "gcc" # for gfortran

  needs :cxx11 if build.with?("rivet") || build.with?("lhapdf")

  def install
    ENV.cxx11 if build.with?("rivet") || build.with?("lhapdf")

    ENV.delete("SDKROOT") if DevelopmentTools.clang_build_version >= 900
    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --enable-analysis
      --enable-gzip
    ]

    if build.with? "mpi"
      args << "--enable-mpi"
      ENV["CC"] = ENV["MPICC"]
      ENV["CXX"] = ENV["MPICXX"]
      ENV["FC"] = ENV["MPIFC"]
    end

    args << "--enable-hepmc2=#{Formula["hepmc"].opt_prefix}"        if build.with? "hepmc"
    args << "--enable-lhapdf=#{Formula["lhapdf"].opt_prefix}"       if build.with? "lhapdf"
    args << "--enable-fastjet=#{Formula["fastjet"].opt_prefix}"     if build.with? "fastjet"
    args << "--enable-openloops=#{Formula["openloops"].opt_prefix}" if build.with? "openloops"
    args << "--enable-root=#{Formula["root"].opt_prefix}"           if build.with? "root"
    args << "--enable-rivet=#{Formula["rivet"].opt_prefix}"         if build.with? "rivet"

    if build.with? "mcfm"
      mcfm_path = buildpath/"mcfm"
      mcfm_path.mkdir
      cd mcfm_path do
        # MCFM build sometimes fails due to race condition
        ENV.deparallelize
        # install script uses wget, remove this dependency
        inreplace "#{buildpath}/AddOns/MCFM/install_mcfm.sh", "wget", "curl -O"
        # install script uses GNU extensions to sed
        inreplace "#{buildpath}/AddOns/MCFM/install_mcfm.sh", "sed", "gsed"
        system "#{buildpath}/AddOns/MCFM/install_mcfm.sh"
        # there is no ENV.parallelize
        ENV["MAKEFLAGS"] = "-j#{ENV.make_jobs}"
        args << "--enable-mcfm=#{mcfm_path}"
      end
    end

    system "./configure", *args
    system "make", "install"

    bash_completion.install share/"SHERPA-MC/sherpa-completion"
  end

  test do
    (testpath/"Run.dat").write <<-EOS.undent
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

    system "#{bin}/Sherpa", "-p", testpath, "-L", testpath, "-e", "1000"
    ohai "You just successfully generated 1000 Drell-Yan events!"
  end
end
