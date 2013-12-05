require 'formula'

class Qcdnum < Formula
  homepage 'http://mbotje.web.cern.ch/mbotje/qcdnum'
  url 'http://www.nikhef.nl/~h24/qcdnum/qcdnum170006.tar.gz'
  sha1 'e1917d8f3e211b9b516f254509e09a78985f0587'
  version '17.00.06'

  depends_on :fortran

  LIBRARIES = %W[
    mbutil
    qcdnum
    zmstf
    hqstf
  ]

  def install
    lib.mkpath
    prefix.install 'testjobs'

    LIBRARIES.each do |libname|
      cd libname do
        system "#{ENV.fc} -c -Wall -O2 -Iinc */*.f"
        system "ar -r #{lib}/lib#{libname}.a *.o"
      end
    end
  end

  test do
    ENV.fortran
    system "#{ENV.fc} -Wall -O -fbounds-check #{prefix}/testjobs/example.f -o example.exe #{lib}/libhqstf.a #{lib}/libzmstf.a #{lib}/libqcdnum.a #{lib}/libmbutil.a"
    system "./example.exe"

    ohai "Test program worked fine. Use 'brew test -v qcdnum' to watch it work"
  end
end
