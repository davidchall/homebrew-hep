class Apfelxx < Formula
  desc "Object oriented rewriting of the APFEL evolution code"
  homepage "https://github.com/vbertone/apfelxx"
  url "https://github.com/vbertone/apfelxx/archive/refs/tags/4.7.0.tar.gz"
  sha256 "01eff0c14e16a83ad25e34159985d7ee33264822585495003e090db57c66a1ac"

  bottle do
    root_url "https://ghcr.io/v2/davidchall/hep"
    rebuild 1
    sha256 cellar: :any, ventura:  "5718780aac3bd41edeacc06a44612cf598136361545c5e26c880c2b1a273a5c6"
    sha256 cellar: :any, monterey: "222f72d1ea5b9bfc51507ee142e850a403baaf8d1966b030ab0855c140f045f2"
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
