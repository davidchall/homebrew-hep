class Cernlib < Formula
  desc "CERN library"
  homepage "https://cernlib.web.cern.ch"
  url "https://cernlib.web.cern.ch/cernlib/download/2022_source/tar/cernlib-2022.11.08.0-free.tar.gz"
  sha256 "733d148415ef78012ff81f21922d3bf641be7514b0242348dd0200cf1b003e46"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://cernlib.web.cern.ch/cernlib/download/2022_source/tar"
    regex(/href=.*?cernlib[._-](\d{4}\.\d{2}\.\d{2}\.\d+)-free\.t/i)
  end

  bottle do
    root_url "https://ghcr.io/v2/davidchall/hep"
    sha256 monterey: "9ec59dd47f46471acabf48a5f95e911909f3d36ddd0210eabc838429286a14a7"
    sha256 big_sur:  "ee13be398fad0d22a2d7dff96f3c2a529b6f5002e57ce84f104f7dfd96184b50"
  end

  option "with-test", "Test during installation"

  depends_on "cmake" => :build
  depends_on "gnu-sed" => :build
  depends_on "coreutils"
  depends_on "gcc"
  depends_on "libxaw"
  depends_on "openmotif"

  patch :p2 do
    url "https://gist.githubusercontent.com/andriish/0f0142dcb5e9717d6cfc9235f2745ec3/raw/c7ba93ebb2ea2471a3f315bf17defc5175d8e83d/patch-cernlib20221108-1.txt"
    sha256 "722794bf0e6e45d0509a82f00cacfdcb2f3e8629a9224a3bc60402034b37805c"
  end

  def install
    args = std_cmake_args + %W[
      -DCMAKE_Fortran_COMPILER=gfortran-#{Formula["gcc"].version_suffix}
      -DCMAKE_C_COMPILER=gcc-#{Formula["gcc"].version_suffix}
      -DMOTIF_INCLUDE_DIR=#{Formula["openmotif"].opt_include}
      -DMOTIF_LIBRARIES=#{Formula["openmotif"].opt_lib}/#{shared_library("libXm")}
      -DCMAKE_INSTALL_LIBDIR=lib/cernlib/2022/lib
      -DCMAKE_INSTALL_INCLUDEDIR=include/cernlib/2022
    ]

    mkdir "build" do
      system "cmake", "..", *args
      system "cmake", "--build", "."
      system "ctest" if build.with? "test"
      system "make", "install"
    end

    license_files = %w[
      GPL2.txt
      MCNETGUIDELINES.txt
      cernlib.copyright
    ]
    license_files.each { |file| cp "contrib/#{file}", prefix }
  end

  test do
    system "#{bin}/cernlib"
  end
end
