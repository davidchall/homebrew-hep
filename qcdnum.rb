require 'formula'

class Qcdnum < Formula
  homepage 'http://mbotje.web.cern.ch/mbotje/qcdnum'
  url 'http://www.nikhef.nl/~h24/qcdnum/qcdnum170006.tar.gz'
  sha1 'e1917d8f3e211b9b516f254509e09a78985f0587'
  version '17.00.06'

  depends_on :fortran

  def build_lib(libname)
    cd libname do
      system "gfortran -c -Wall -O2 -Iinc */*.f"
      system "ar -r ../lib/lib#{libname}.a *.o"
    end
  end

  def install
    build_lib('mbutil')
    build_lib('qcdnum')
    build_lib('zmstf')
    build_lib('hqstf')

    lib.install Dir['lib/*']
    prefix.install 'testjobs'
  end

  test do
    system "gfortran -Wall -O -fbounds-check #{prefix}/testjobs/example.f -o example.exe #{lib}/libhqstf.a #{lib}/libzmstf.a #{lib}/libqcdnum.a #{lib}/libmbutil.a"
    system "./example.exe"

    ohai "Test program worked fine. Use 'brew test -v qcdnum' to watch it work"
  end
end
