class Apfelxx < Formula
  desc "Object oriented rewriting of the APFEL evolution code"
  homepage "https://github.com/vbertone/apfelxx"
  url "https://github.com/vbertone/apfelxx/archive/4.7.0.tar.gz"
  sha256 "01eff0c14e16a83ad25e34159985d7ee33264822585495003e090db57c66a1ac"

  bottle do
    root_url "https://ghcr.io/v2/davidchall/hep"
    sha256 cellar: :any, monterey: "cfb805b7a0b8538f312b53951b41ebbbbb1679806a9fb8155ef430267a0e6ece"
    sha256 cellar: :any, big_sur:  "3ad6a6559b04a6982914febf07b5815e5555ce82055c1cd255a5367450e4e394"
  end

  depends_on "cmake" => :build
  depends_on "gcc" # for gfortran

  def install
    system "cmake", ".", *std_cmake_args
    system "make"
    system "make", "install"

    prefix.install "tests/dglap_test.cc"
  end

  test do
    flags = shell_output(bin/"apfelxx-config --cppflags --ldflags").split
    system ENV.cxx, "-std=c++11", prefix/"dglap_test.cc", "-o", "test", *flags
    system "./test"
  end
end
