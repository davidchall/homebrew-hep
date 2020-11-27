class ElementaryUtils < Formula
  desc "Utility softwares for PARTONS"
  homepage "http://partons.cea.fr/partons/doc/html/index.html"
  url "https://drf-gitlab.cea.fr/partons/core/elementary-utils/repository/v2.0/archive.tar.gz"
  sha256 "caa44f4b74239ee575dc69cdc856981b0178f8bec056fc959b1370d2c031eb93"

  depends_on "cmake" => :build
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
