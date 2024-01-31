class Apfelxx < Formula
  desc "Object oriented rewriting of the APFEL evolution code"
  homepage "https://github.com/vbertone/apfelxx"
  url "https://github.com/vbertone/apfelxx/archive/refs/tags/4.8.0.tar.gz"
  sha256 "d577cf0f8cbcfae18699670941827c6c72dfec4aeb14321365c36937ace6a34a"

  bottle do
    root_url "https://ghcr.io/v2/davidchall/hep"
    sha256 cellar: :any, arm64_sonoma: "cf08bb49e6b44cef92e845f926c8cfa2dcae09a4e8b319c5962bebaa2c83777f"
    sha256 cellar: :any, ventura:      "3d57f38506c52114a18432d43c127ae565dd4c9d3ba188cca23857e63509a3a7"
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
