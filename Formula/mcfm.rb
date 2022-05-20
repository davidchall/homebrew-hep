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

  depends_on "cmake" => :build
  depends_on "gcc"
  depends_on "lhapdf"

  # needs gcc >= 7
  fails_with :clang
  fails_with gcc: "5"
  fails_with gcc: "6"

  def install
    gfortran_lib = Formula["gcc"].opt_lib/"gcc"/Formula["gcc"].version_suffix
    inreplace "lib/qcdloop-2.0.5/CMakeLists.txt",
      "target_link_libraries(qcdloop_shared)",
      "target_link_libraries(qcdloop_shared -L#{gfortran_lib} -lquadmath)"
    inreplace "lib/qcdloop-2.0.5/CMakeLists.txt",
      "target_link_libraries(qcdloop_static)",
      "target_link_libraries(qcdloop_static -L#{gfortran_lib} -lquadmath)"

    mkdir "../build" do
      system "cmake", buildpath, *std_cmake_args, "-Duse_internal_lhapdf=OFF"
      system "make"
      system "make", "install"

      bin.install "Bin/mcfm_omp"
      pkgshare.install Dir["Bin/*"]
      doc.install Dir["Doc/*.pdf"]
    end
  end

  test do
    download_pdfs(buildpath/"pdf-sets", "CT14nnlo")
    system bin/"mcfm_omp", pkgshare/"input.ini"
    system "ls"
    assert_predicate testpath/"W_only_nlo_CT14.NN_80___80___13TeV.top", :exist?
  end
end
