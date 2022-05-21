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

  bottle do
    root_url "https://ghcr.io/v2/davidchall/hep"
    sha256 cellar: :any, monterey: "ea453499fb8feb38613a556ffa80ca7b137f1fa86a4516e603ca921e07a5d6a2"
    sha256 cellar: :any, big_sur:  "de08ad6a1fba5b8c7e82fbe7024dc4b1de4697dd6f4e576fd720dee893881ec1"
    sha256 cellar: :any, catalina: "7ca2fd32f3a17b21ed4ea9e27a441c7f7ff53f0670349a0a0b21934745f2a52c"
  end

  option "with-nnlo-vv", "Build NNLO diboson processes (slow compilation)"

  depends_on "cmake" => :build
  depends_on "gcc@12"
  depends_on "lhapdf" => :optional # needs to be built with gcc

  fails_with :clang

  patch :DATA

  def install
    gcc = Formula["gcc@12"]
    ENV["FC"] = gcc.opt_bin/"gfortran-#{gcc.version_suffix}"
    gfortran_lib = gcc.opt_lib/"gcc/#{gcc.version_suffix}"

    inreplace "lib/qcdloop-2.0.5/CMakeLists.txt",
      "target_link_libraries(qcdloop_shared)",
      "target_link_libraries(qcdloop_shared -L#{gfortran_lib} -lquadmath)"
    inreplace "lib/qcdloop-2.0.5/CMakeLists.txt",
      "target_link_libraries(qcdloop_static)",
      "target_link_libraries(qcdloop_static -L#{gfortran_lib} -lquadmath)"

    pkgshare.install Dir["Bin/*"]

    cd "Bin" do
      args = []
      args << "-Dwith_vvamp=OFF" if build.without? "nnlo-vv"
      if build.with? "lhapdf"
        args << "-Duse_internal_lhapdf=OFF"
        args << "-Dlhapdf_include_path=#{Formula["lhapdf"].opt_include}"
      end

      system "cmake", "..", *args
      system "make"
    end

    bin.install "Bin/mcfm"
    doc.install Dir["Doc/*.pdf"]
  end

  def caveats
    <<~EOS
      Before running mcfm, copy this file to your working directory:
        #{pkgshare}/process.DAT

    EOS
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

__END__
diff --git a/CMakeLists.txt b/CMakeLists.txt
index 4fff350..1dc0b76 100644
--- a/CMakeLists.txt
+++ b/CMakeLists.txt
@@ -290,8 +290,8 @@ if(use_internal_lhapdf)
 elseif(use_external_lhapdf)
     find_library(lhapdf_lib NAMES LHAPDF REQUIRED)
     target_link_libraries(mcfm ${lhapdf_lib})
-    if (${lhapdf_include_path})
-        target_include_directories(objlib PRIVATE "${LHAPDF_INCLUDE_PATH}" "${CMAKE_BINARY_DIR}/local/include" "${CMAKE_BINARY_DIR}/local/include/qd")
+    if (NOT ${lhapdf_include_path} STREQUAL "OFF")
+        target_include_directories(objlib PRIVATE "${lhapdf_include_path}" "${CMAKE_BINARY_DIR}/local/include" "${CMAKE_BINARY_DIR}/local/include/qd")
     endif()
 endif()
