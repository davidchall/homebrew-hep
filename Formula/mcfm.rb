class Mcfm < Formula
  desc "Monte Carlo for FeMtobarn processes"
  homepage "https://mcfm.fnal.gov"
  url "https://mcfm.fnal.gov/downloads/MCFM-10.2.2.tar.gz"
  sha256 "15ebd4cb51cafb4af674a2e0a3ec8c02ac88a49565b3265c80719c59c0cc3c9d"
  license "GPL-3.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?MCFM[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://ghcr.io/v2/davidchall/hep"
    sha256 cellar: :any, monterey: "af86d32b133eed55d90b9a6c09f2839d37c38534609badb08e2c457f4a77fe58"
    sha256 cellar: :any, big_sur:  "f6da20fbf7a9ebf81ad2a43e4d7dbe4cc9e4495b4e0f92572608e1d2e8e261c7"
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
