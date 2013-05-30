require 'formula'

class YamlCpp030 < Formula
  homepage 'http://code.google.com/p/yaml-cpp/'
  url 'http://yaml-cpp.googlecode.com/files/yaml-cpp-0.3.0.tar.gz'
  sha1 '28766efa95f1b0f697c4b4a1580a9972be7c9c41'

  depends_on 'cmake' => :build

  keg_only "Conflicts with yaml-cpp in main repository."

  def install
    system "cmake", ".", "-DBUILD_SHARED_LIBS=ON", *std_cmake_args
    system "make install"
  end
end
