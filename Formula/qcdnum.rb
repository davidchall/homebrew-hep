class Qcdnum < Formula
  desc "Fast PDF evolution"
  homepage "http://www.nikhef.nl/~h24/qcdnum"
  url "https://www.hepforge.org/archive/qcdnum/qcdnum-17.00.07.tar.gz"
  mirror "http://www.nikhef.nl/user/h24/qcdnum-files/download/qcdnum170007.tar.gz"
  sha256 "768a8cd4d2f140f8ee0d1ba886bc72f872b39a69b6ef16f890c1044295ce31af"

  depends_on "gcc" # for gfortran

  def install
    libraries = %W[
      mbutil
      qcdnum
      zmstf
      hqstf
    ]

    lib.mkpath
    prefix.install "testjobs"

    libraries.each do |libname|
      cd libname do
        system "gfortran", "-c", "-fPIC", "-Wall", "-O2", "-Iinc", "*/*.f"
        system "ar", "-r", "#{lib}/lib#{libname}.a", "*.o"
      end
    end
  end

  test do
    system "gfortran", "-Wall", "-O", "-fbounds-check", "#{prefix}/testjobs/example.f", "-o", "example.exe", "#{lib}/libhqstf.a", "#{lib}/libzmstf.a", "#{lib}/libqcdnum.a", "#{lib}/libmbutil.a"
    system "./example.exe"

    ohai "Test program worked fine. Use 'brew test -v qcdnum' to watch it work"
  end
end
