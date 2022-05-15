class Qcdnum < Formula
  desc "Fast PDF evolution"
  homepage "https://www.nikhef.nl/~h24/qcdnum"
  url "https://www.nikhef.nl/~h24/qcdnum-files/download/qcdnum180000.tar.gz"
  version "18.0.0"
  sha256 "e108f926b7840352e4080ba71914d3403ed8118364f87710e221fdec320ee200"

  depends_on "gcc" # for gfortran

  def install
    libraries = %w[
      mbutil
      qcdnum
      zmstf
      hqstf
    ]

    lib.mkpath
    prefix.install "testjobs"

    libraries.each do |libname|
      cd libname do
        system "gfortran -c -fPIC -Wall -O2 -Iinc */*.f"
        system "ar -r #{lib}/lib#{libname}.a *.o"
      end
    end
  end

  test do
    args = %W[
      -Wall
      -O
      -fbounds-check
      #{prefix}/testjobs/example.f
      -o
      example.exe
      #{lib}/libhqstf.a
      #{lib}/libzmstf.a
      #{lib}/libqcdnum.a
      #{lib}/libmbutil.a
    ]
    system "gfortran", *args
    system "./example.exe"
  end
end
