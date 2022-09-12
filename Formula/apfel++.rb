class Apfelxx < Formula
  desc "Object oriented rewriting of the APFEL evolution code"
  homepage "https://github.com/vbertone/apfelxx"
  url "https://github.com/vbertone/apfelxx/archive/4.6.0.tar.gz"
  sha256 "37ad4121dfa5726ebe09cd2b7cf148976feb063ec6aeae7332ad9adc29c41543"
  revision 2

  bottle do
    root_url "https://ghcr.io/v2/davidchall/hep"
    sha256 cellar: :any, monterey: "e9a9c1c2fa8c473c632421d95957f3ec1d546c3abea2ec399997b0fe321597df"
    sha256 cellar: :any, big_sur:  "dc106cd4251721af9d69c39912ea73d7bc6d2869b0cf67b8a64018f5fb25e576"
    sha256 cellar: :any, catalina: "d27805c9774560f8605239de35671baa3e8be425fe8f581e1b839ffb1fa7db2c"
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
