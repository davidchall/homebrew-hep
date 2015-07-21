require 'formula'

class Sherpa < Formula
  homepage 'https://sherpa.hepforge.org/'
  url 'http://www.hepforge.org/archive/sherpa/SHERPA-MC-2.2.0.tar.gz'
  sha256 'eb5dfde38f4f7a166f313d3c24d1af22c99f9934b7c50c981ff3f5aec9c467d7'

  depends_on 'hepmc'   => :recommended
  depends_on 'rivet'   => :recommended
  depends_on 'lhapdf'  => :recommended
  depends_on 'fastjet' => :optional
  depends_on 'homebrew/science/root' => :optional
  depends_on :mpi      => [:cc, :cxx, :f90, :optional]
  depends_on :fortran
  cxxstdlib_check :skip

  # Requires changes to MCFM code, so cannot use MCFM formula
  option 'with-mcfm', 'Enable use of MCFM loops'
  if build.with? "mcfm"
    depends_on 'wget' => :build
    depends_on 'gnu-sed' => :build
  end

  def install
    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --enable-multithread
    ]

    if build.with? "mpi"
      args << "--enable-mpi"
      ENV['CC'] = ENV['MPICC']
      ENV['CXX'] = ENV['MPICXX']
      ENV['FC'] = ENV['MPIFC']
    end

    args << "--enable-hepmc2=#{Formula['hepmc'].prefix}"    if build.with? "hepmc"
    args << "--enable-rivet=#{Formula['rivet'].prefix}"     if build.with? "rivet"
    args << "--enable-lhapdf=#{Formula['lhapdf'].prefix}"   if build.with? "lhapdf"
    args << "--enable-fastjet=#{Formula['fastjet'].prefix}" if build.with? "fastjet"
    args << "--enable-root=#{Formula['root'].prefix}"       if build.with? "root"

    if build.with? "mcfm"
      mcfm_path = buildpath/'mcfm'
      mcfm_path.mkdir
      cd mcfm_path do
        # MCFM build sometimes fails due to race condition
        ENV.deparallelize
        # install script uses GNU extensions to sed
        inreplace "#{buildpath}/AddOns/MCFM/install_mcfm.sh", "sed", "gsed"
        system "#{buildpath}/AddOns/MCFM/install_mcfm.sh"
        # there is no ENV.parallelize
        ENV['MAKEFLAGS'] = "-j#{ENV.make_jobs}"
        args << "--enable-mcfm=#{mcfm_path}"
      end
    end

    system "./configure", *args
    system "make", "install"

    bash_completion.install share/'SHERPA-MC/sherpa-completion'
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

    system "Sherpa", "-p", testpath, "-L", testpath, "-e", "1000"
    ohai "You just successfully generated 1000 Drell-Yan events!"
  end
end
