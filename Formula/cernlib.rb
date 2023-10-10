class Cernlib < Formula
  desc "CERN library"
  homepage "https://cernlib.web.cern.ch"
  url "https://cernlib.web.cern.ch/download/2023_source/tar/cernlib-2023.08.14.0-free.tar.gz"
  sha256 "7006475d9c38254cb94ce75e556a319fea3b3155087780ea522003103771474e"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://cernlib.web.cern.ch/cernlib/download/2023_source/tar"
    regex(/href=.*?cernlib[._-](\d{4}\.\d{2}\.\d{2}\.\d+)-free\.t/i)
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
      -DCMAKE_INSTALL_LIBDIR=lib/cernlib/2023/lib
      -DCMAKE_INSTALL_INCLUDEDIR=include/cernlib/2023
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
