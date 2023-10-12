class Hepmc2 < Formula
  desc "C++ event record for Monte Carlo generators"
  homepage "https://hepmc.web.cern.ch/"
  url "https://gitlab.cern.ch/hepmc/HepMC/-/archive/2.06.11/HepMC-2.06.11.tar.gz"
  sha256 "ceaced62d39e4e2a1469fa2f20662d4d370279b3209930250766db02f44ae8de"
  license "LGPL-2.1-or-later"

  bottle do
    root_url "https://ghcr.io/v2/davidchall/hep"
    rebuild 2
    sha256 cellar: :any, ventura:  "00128849bb3b2551a6dea74fc49e2c694e1101223f6c9908d474ed9b70e0f4e8"
    sha256 cellar: :any, monterey: "0e2cc514c84f7b637cd4fb1e0153638ff4210f88b05dbebab25a6ff1f6a7ee81"
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
