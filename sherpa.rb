require 'formula'

class Sherpa < Formula
  homepage 'https://sherpa.hepforge.org/'
  url 'http://www.hepforge.org/archive/sherpa/SHERPA-MC-1.4.3.tar.gz'
  sha1 'ba9d3fdf67057358a2194584bd8f9f4fa2c4940e'

  devel do
    url 'http://www.hepforge.org/archive/sherpa/SHERPA-MC-2.0.beta2.tar.gz'
    sha1 '6e0908316a00194032e19e7705c837252f7a6e83'
    version '2.0.b2'
  end

  def patches
    # Conform to C++ standards (to compile with clang)
    # OS X 10.8 is now POSIX compatible with scandir signature
    if build.devel?
      { :p0 => [
        "https://sherpa.hepforge.org/trac/raw-attachment/ticket/259/clang.patch",
        "https://sherpa.hepforge.org/trac/raw-attachment/ticket/260/dirent.patch"
        ]}
    else
      { :p0 => [
        "https://sherpa.hepforge.org/trac/raw-attachment/ticket/259/143_clang.patch",
        "https://sherpa.hepforge.org/trac/raw-attachment/ticket/260/dirent.patch"
        ]}
    end
  end

  depends_on 'hepmc'   => :recommended
  depends_on 'rivet'   => :recommended
  depends_on 'lhapdf'  => :recommended
  depends_on 'fastjet' => :optional

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

    ENV.fortran
    ENV.append 'LDFLAGS', "-L/usr/lib -lstdc++"

    system "./configure", *args
    system "make", "install"
  end

  test do
    system "Sherpa", "--version"

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
