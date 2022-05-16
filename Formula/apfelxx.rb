class Apfelxx < Formula
  desc "Object oriented rewriting of the APFEL evolution code"
  homepage "https://github.com/vbertone/apfelxx"
  url "https://github.com/vbertone/apfelxx/archive/4.6.0.tar.gz"
  sha256 "37ad4121dfa5726ebe09cd2b7cf148976feb063ec6aeae7332ad9adc29c41543"

  bottle do
    root_url "https://ghcr.io/v2/davidchall/hep"
    rebuild 1
    sha256 cellar: :any, monterey: "86353a8db456cd0c9ea518a49c5635c7e4f6e991427511c3e97ae37121aacf27"
    sha256 cellar: :any, big_sur:  "4ca1f71dc1051367b88399cc6904814e716d3f34346e8000a20f590ec0f13acd"
    sha256 cellar: :any, catalina: "3e9573793d1ba460086caa3cfc76ef4740ba65d038d2a06e93baccddbeea7eb9"
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
