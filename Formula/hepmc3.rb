class Hepmc < Formula
  desc "C++ event record for Monte Carlo generators"
  homepage "https://hepmc.web.cern.ch/"
  url "http://lcgapp.cern.ch/project/simu/HepMC/download/HepMC-2.06.09.tar.gz"
  sha256 "c60724ca9740230825e06c0c36fb2ffe17ff1b1465e8656268a61dffe1611a08"

  bottle do
    root_url "https://dl.bintray.com/davidchall/bottles-hep"
    cellar :any
    sha256 "0f7776e2d85b80f46af012ac127499b67ed4bdbe19483704a11b373f1a6f63f6" => :high_sierra
    sha256 "0684a190b89cd278481ad71c7c32cc48f6de15de12abd0b7736d27fd79fd21e2" => :sierra
    sha256 "95a6f176ff49cdf95ad8a5d94f2656bf7f6557ab9672b56b04159cf03a19196c" => :el_capitan
    sha256 "602214a37352f51cd5cdc2a57bfe4f1c79baee569d711b526a4c21d8658722f3" => :yosemite
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
