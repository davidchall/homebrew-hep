class Hepmc2 < Formula
  desc "C++ event record for Monte Carlo generators"
  homepage "https://hepmc.web.cern.ch/"
  url "https://gitlab.cern.ch/hepmc/HepMC/-/archive/2.06.11/HepMC-2.06.11.tar.gz"
  sha256 "ceaced62d39e4e2a1469fa2f20662d4d370279b3209930250766db02f44ae8de"
  license "LGPL-2.1-or-later"

  bottle do
    root_url "https://ghcr.io/v2/davidchall/hep"
    rebuild 1
    sha256 cellar: :any, monterey: "8356e9c1015f3fa94b10353c6b9576dbe10eedae93d582f2d12ddc69593afba6"
    sha256 cellar: :any, big_sur:  "7286697a692029d4cfa8d8d9f95afa8c662f96894b241f14f923c596d88ed971"
    sha256 cellar: :any, catalina: "a15dbef41ec9a792fa5308f6d6c26a943f5944978f269b49969294a7cf813603"
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
