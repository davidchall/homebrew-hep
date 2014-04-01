require 'formula'

class Sherpa < Formula
  homepage 'https://sherpa.hepforge.org/'
  url 'http://www.hepforge.org/archive/sherpa/SHERPA-MC-2.1.0.tar.gz'
  sha1 'f775d3ddd2435a7795f1398335d44d2c49454ea8'

  depends_on 'hepmc'   => :recommended
  depends_on 'rivet'   => :recommended
  depends_on 'lhapdf'  => :recommended
  depends_on 'fastjet' => :optional
  depends_on :fortran

  def install
    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --enable-multithread
    ]

    args << "--enable-hepmc2=#{Formula.factory('hepmc').prefix}"    if build.with? "hepmc"
    args << "--enable-rivet=#{Formula.factory('rivet').prefix}"     if build.with? "rivet"
    args << "--enable-lhapdf=#{Formula.factory('lhapdf').prefix}"   if build.with? "lhapdf"
    args << "--enable-fastjet=#{Formula.factory('fastjet').prefix}" if build.with? "fastjet"

    system "./configure", *args
    system "make", "install"

    bash_completion.install share/'SHERPA-MC/sherpa-completion'
  end

  def caveats
    <<-EOS.undent
      There seems to be a Mavericks-related problem with fragmentation,
      which causes a runtime error during the generation of the first few
      events. See the ticket `https://sherpa.hepforge.org/trac/ticket/279`
      for more information.

      You can turn off fragmentation explicitly by adding `FRAGMENTATION=Off`
      to the `(fragmentation)` group of your run card, see
      `https://sherpa.hepforge.org/doc/SHERPA-MC-2.1.0.html#Fragmentation`.
      It is also implicitly turned off when you set `SHOWER_GENERATOR=None`
      or `NLO_QCD_MODE Fixed_Order`.
    EOS
  end

  test do
    (testpath/"Run.dat").write <<-EOS.undent
      (beam){
        BEAM_1 =  2212; BEAM_ENERGY_1 = 7000;
        BEAM_2 =  2212; BEAM_ENERGY_2 = 7000;
      }(beam)

      (processes){
        Process 93 93 -> 11 -11;
        Order_EW 2;
        Integration_Error 0.05;
        End process;
      }(processes)

      (fragmentation){
        FRAGMENTATION = Off
      }

      (selector){
        Mass 11 -11 66 166
      }(selector)

      (mi){
        MI_HANDLER = None   # None or Amisic
      }(mi)
    EOS

    system "Sherpa", "-p", testpath, "-L", testpath, "-e", "1000"
    puts "You just successfully generated 1000 Drell-Yan events!"
    puts "Please now delete the \"Sherpa_References.tex\" file"
  end
end
