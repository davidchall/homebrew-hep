class Mcfm < Formula
  desc "Monte Carlo for FeMtobarn processes"
  homepage "https://mcfm.fnal.gov"
  url "https://mcfm.fnal.gov/downloads/MCFM-10.2.1.tar.gz"
  sha256 "5b97dd90159efcef227420b49e8eb53b7f1ee0af8d5a6bf8595a29c320afe2dc"
  license "GPL-3.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?MCFM[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  option "with-nnlo-vv", "Include NNLO diboson processes (slow compilation)"

  depends_on "cmake" => :build
  depends_on "gcc@12"
  depends_on "lhapdf" => :optional

  # needs gcc >= 7
  fails_with :clang
  fails_with gcc: "5"
  fails_with gcc: "6"

  def install
    pkgshare.install Dir["Bin/*"]
    doc.install Dir["Doc/*.pdf"]

    gfortran_lib = Formula["gcc@12"].opt_lib/"gcc"/Formula["gcc@12"].version_suffix
    inreplace "lib/qcdloop-2.0.5/CMakeLists.txt",
      "target_link_libraries(qcdloop_shared)",
      "target_link_libraries(qcdloop_shared -L#{gfortran_lib} -lquadmath)"
    inreplace "lib/qcdloop-2.0.5/CMakeLists.txt",
      "target_link_libraries(qcdloop_static)",
      "target_link_libraries(qcdloop_static -L#{gfortran_lib} -lquadmath)"

    cd "Bin" do
      args = %w[
        -DCMAKE_Fortran_COMPILER=gfortran-12
        -DCMAKE_C_COMPILER=gcc-12
        -DCMAKE_CXX_COMPILER=g++-12
      ]
      args << "-Dwith_vvamp=OFF" if build.without? "nnlo-vv"
      if build.with? "lhapdf"
        args << "-Duse_internal_lhapdf=OFF"
        args << "-Dlhapdf_include_path=#{Formula["lhapdf"].opt_include}"
      end

      ENV.append "FCFLAGS", "-I."
      ENV.append "CXXFLAGS", "-I."
      system "cmake", "..", *args
      system "make"
    end

    bin.install "Bin/mcfm"
  end

  test do
    ln_s pkgshare/"PDFs", testpath
    ln_s pkgshare/"process.DAT", testpath
    cp pkgshare/"input.ini", testpath

    inreplace "input.ini", "part = nlo", "part = lo" # avoid test timeout
    system bin/"mcfm", "input.ini"
    assert_predicate testpath/"W_only_lo_CT14nnlo_1.00_1.00_14TeV_total_cross.txt", :exist?
  end
end
