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
  depends_on arch: :x86_64 # https://github.com/davidchall/homebrew-hep/issues/203
  depends_on "gcc"
  depends_on "lhapdf"

  # needs gcc >= 7
  fails_with :clang
  fails_with gcc: "5"
  fails_with gcc: "6"

  def install
    mkdir "../build" do
      system "cmake", buildpath, *std_cmake_args, "-Duse_internal_lhapdf=OFF"
      system "make"
      system "make", "install"

      doc.install Dir["Doc/*.pdf"]
    end
  end

  test do
    system bin/"mcfm_omp", share/"input.DAT"
    system "ls"
    assert_predicate testpath/"W_only_nlo_CT14.NN_80___80___13TeV.top", :exist?
  end
end
