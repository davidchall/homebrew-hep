class Qcdnum < Formula
  homepage 'http://mbotje.web.cern.ch/mbotje/qcdnum'
  url 'https://www.hepforge.org/archive/qcdnum/qcdnum-17.00.06.tar.gz'
  mirror 'http://www.nikhef.nl/user/h24/qcdnum-files/download/qcdnum170006.tar.gz'
  sha256 'c454e8717631ce95180f517e0ddddc1aeeb30aa82eba75e555c39cc1cd4b2824'
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
        system "#{ENV.fc} -c -fPIC -Wall -O2 -Iinc */*.f"
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
