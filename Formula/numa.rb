class Numa < Formula
  desc "Numerical analysis C++ routines for PARTONS"
  homepage "http://partons.cea.fr/partons/doc/html/index.html"
  url "https://drf-gitlab.cea.fr/partons/core/numa/repository/v2.0/archive.tar.gz"
  sha256 "960983d26c42199271601ac201c2f44660e8a6420c872792a1701b63f6e5c8a7"

  depends_on "cmake" => :build
  depends_on "eigen"
  depends_on "elementary-utils"
  depends_on "gcc"
  depends_on "sfml"

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    system "false"
  end
end
