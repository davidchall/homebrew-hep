class Mcfm < Formula
  desc "Monte Carlo for FeMtobarn processes"
  homepage "https://mcfm.fnal.gov"
  url "https://mcfm.fnal.gov/downloads/MCFM-10.3.tar.gz"
  sha256 "97677cbccb06b2821a5fa1569d1f561b253bd0651a97ab05d13247c708864840"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://mcfm.fnal.gov/OverviewofMCFM.html"
    regex(/href=.*?MCFM[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://ghcr.io/v2/davidchall/hep"
    sha256 cellar: :any, arm64_sonoma: "672acf38e0d7405d0f4b0f2f30f48a56d29a633e5c45a6d256eb2928e047d97b"
    sha256 cellar: :any, ventura:      "cb281e262f624c81a9ec8989b23ebde56df1b800f79d34ad3bc3acdfa9c5a974"
  end

  option "with-nnlo-vv", "Build NNLO diboson processes (slow compilation)"

  depends_on "cmake" => :build
  depends_on "gcc"
  depends_on "lhapdf" => :optional # needs to be built with gcc

  fails_with :clang

  def install
    gcc = Formula["gcc"]
    gcc_major_ver = gcc.any_installed_version.major
    ENV["FC"] = gcc.opt_bin/"gfortran-#{gcc_major_ver}"
    gfortran_lib = gcc.opt_lib/"gcc/#{gcc_major_ver}"

    inreplace "lib/qcdloop-2.0.9/CMakeLists.txt",
      "target_link_libraries(qcdloop_shared)",
      "target_link_libraries(qcdloop_shared -L#{gfortran_lib} -lquadmath)"
    inreplace "lib/qcdloop-2.0.9/CMakeLists.txt",
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
    assert_predicate testpath/"W_only_lo_LUXqed17_plus_PDF4LHC15_nnlo_30_100__100__test1_total_cross.txt", :exist?
  end
end
