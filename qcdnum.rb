require 'formula'

class Qcdnum < Formula
  homepage 'http://mbotje.web.cern.ch/mbotje/qcdnum'
  url 'http://www.nikhef.nl/~h24/qcdnum/qcdnum170006.tar.gz'
  sha1 'e1917d8f3e211b9b516f254509e09a78985f0587'

  depends_on :fortran

  def install

    # Make the libraries

    system "gfortran -c -Wall -O2 -Imbutil/inc mbutil/src/*.f"
    system "ar -r lib/libmbutil.a *.o"
    system "rm *.o"

    system "gfortran -g -c -Wall -O2 -Iqcdnum/inc qcdnum/pij/*.f qcdnum/src/*.f qcdnum/usr/*.f"
    system "ar -r lib/libqcdnum.a *.o"
    system "rm *.o"

    system "gfortran -g -c -Wall -O2 -Izmstf/inc zmstf/src/*.f zmstf/cij/*.f"
    system "ar -r lib/libzmstf.a *.o"
    system "rm *.o"

    system "gfortran -g -c -Wall -O2 -Ihqstf/inc hqstf/src/*.f hqstf/cij/*.f"
    system "ar -r lib/libhqstf.a *.o"
    system "rm *.o"

    # Install libraries
    lib.install Dir['lib/*']

    # Install testjobs
    prefix.install 'testjobs'

  end

  test do

    # Build the test
    system "gfortran -Wall -O -fbounds-check #{prefix}/testjobs/example.f -o example.exe #{lib}/libhqstf.a #{lib}/libzmstf.a #{lib}/libqcdnum.a  #{lib}/libmbutil.a"
    system "./example.exe"
    system "rm example.exe"

    ohai "Example program worked fine. Use 'brew test -v qcdnum' to watch it work"

  end
end
