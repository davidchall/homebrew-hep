class Apfelxx < Formula
  desc "Object oriented rewriting of the APFEL evolution code"
  homepage "https://github.com/vbertone/apfelxx"
  url "https://github.com/vbertone/apfelxx/archive/4.6.0.tar.gz"
  sha256 "37ad4121dfa5726ebe09cd2b7cf148976feb063ec6aeae7332ad9adc29c41543"
  revision 1

  bottle do
    root_url "https://ghcr.io/v2/davidchall/hep"
    sha256 cellar: :any, monterey: "24473d21312cbc2d01037192071f87b7daba220e2741b58ecd16879b086c8983"
    sha256 cellar: :any, big_sur:  "e5dabd91b019dcccf51f0a6030c484abd08fca297f52165deadd1be737ef7530"
    sha256 cellar: :any, catalina: "eada3297fddd84f04a6a9c60dbb7876b4aeb1c002cbd8b449cdefec1ce1ed12a"
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
