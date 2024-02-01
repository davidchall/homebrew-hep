class Hepmc2 < Formula
  desc "C++ event record for Monte Carlo generators"
  homepage "https://hepmc.web.cern.ch/"
  url "https://gitlab.cern.ch/hepmc/HepMC/-/archive/2.06.11/HepMC-2.06.11.tar.gz"
  sha256 "ceaced62d39e4e2a1469fa2f20662d4d370279b3209930250766db02f44ae8de"
  license "LGPL-2.1-or-later"

  bottle do
    root_url "https://ghcr.io/v2/davidchall/hep"
    rebuild 3
    sha256 cellar: :any, arm64_sonoma: "a100ed1d92ff3f3f703103c1d704f55858c423cd1c91d5eef02c5765289c2c84"
    sha256 cellar: :any, ventura:      "116cb869287b55c50c7e7fce6e6a6ec0a92a5ad21fd6ae98f8f1fc6325ad5519"
  end

  option "with-test", "Test during installation"

  depends_on "cmake" => :build

  def install
    mkdir "../build" do
      system "cmake", buildpath, "-Dmomentum:STRING=GEV", "-Dlength:STRING=MM", *std_cmake_args
      system "make"
      system "make", "test" if build.with? "test"
      system "make", "install"
    end
  end

  test do
    cp_r share/"HepMC/examples/.", testpath
    system "make", "example_BuildEventFromScratch.exe"
    system "./example_BuildEventFromScratch.exe"
  end
end
