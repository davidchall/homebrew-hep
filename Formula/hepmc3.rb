class Hepmc3 < Formula
  desc "HepMC3 C++ event record for Monte Carlo generators"
  homepage "http://hepmc.web.cern.ch/hepmc/"
  url "http://hepmc.web.cern.ch/hepmc/releases/HepMC3-3.1.0.tar.gz"
  sha256 "cd37eed619d58369041018b8627274ad790020a4714b54ac05ad1ebc1a6e7f8a"


  option "with-test", "Test during installation"
  option "with-root", "Enable root IO"

  depends_on "cmake" => :build

  def install
    mkdir "../build" do
      system "cmake", buildpath, "-DHEPMC3_ENABLE_TEST=ON" if build.with? "test", "-DHEPMC3_ENABLE_ROOTIO=ON" if build.with? "root", *std_cmake_args
      system "make"
      system "make", "test" if build.with? "test"
      system "make", "install"
    end
  end

  test do
    system "make", "test"
  end
end
