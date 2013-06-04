require 'formula'

class YamlCpp025 < Formula
  homepage 'http://code.google.com/p/yaml-cpp/'
  url 'http://yaml-cpp.googlecode.com/files/yaml-cpp-0.2.5.tar.gz'
  sha1 '2a57d2a8e8dd2a5a368465201299af3bc22d08ae'

  depends_on 'cmake' => :build

  keg_only "Conflicts with yaml-cpp in main repository."

  def install
    system "cmake", ".", "-DBUILD_SHARED_LIBS=ON", *std_cmake_args
    system "make", "install"
  end
end
