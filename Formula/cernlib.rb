class Cernlib < Formula
  desc "CERN library"
  homepage "https://cernlib.web.cern.ch"
  url "https://cernlib.web.cern.ch/download/2025_source/tar/cernlib-cernlib-2025.02.25.0-free.tar.gz"
  sha256 "87251ca68195eed7a25f4e911f643336740d30f07bfb89f382f693b9a1e1155e"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://cernlib.web.cern.ch/cernlib/download/2025_source/tar"
    regex(/href=.*?cernlib[._-](\d{4}\.\d{2}\.\d{2}\.\d+)-free\.t/i)
  end

  bottle do
    root_url "https://ghcr.io/v2/davidchall/hep"
    sha256 ventura:  "8bc51dc39755d709d94ffcf150aced5ee94a67e011402caa6922e13fc6d249f4"
    sha256 monterey: "107b2eee1bd045330f6be7c424791a3517313c0e20a18b4bc0d60c511c1d1550"
  end

  option "with-test", "Test during installation"

  depends_on "cmake" => :build
  depends_on "gnu-sed" => :build
  depends_on "coreutils"
  depends_on "gcc"
  depends_on "libxaw"
  depends_on "openmotif"

  def install
    gcc_major_ver = Formula["gcc"].any_installed_version.major

    args = std_cmake_args + %W[
      -DCMAKE_Fortran_COMPILER=gfortran-#{gcc_major_ver}
      -DCMAKE_C_COMPILER=gcc-#{gcc_major_ver}
      -DMOTIF_INCLUDE_DIR=#{Formula["openmotif"].opt_include}
      -DMOTIF_LIBRARIES=#{Formula["openmotif"].opt_lib}/#{shared_library("libXm")}
      -DCMAKE_INSTALL_LIBDIR=lib/cernlib/2025/lib
      -DCMAKE_INSTALL_INCLUDEDIR=include/cernlib/2025
    ]

    mkdir "build" do
      system "xattr", "-rc", "../"
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
