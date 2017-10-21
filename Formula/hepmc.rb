class Hepmc < Formula
  desc "C++ event record for Monte Carlo generators"
  homepage "https://hepmc.web.cern.ch/"
  url "http://lcgapp.cern.ch/project/simu/HepMC/download/HepMC-2.06.09.tar.gz"
  sha256 "c60724ca9740230825e06c0c36fb2ffe17ff1b1465e8656268a61dffe1611a08"

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
