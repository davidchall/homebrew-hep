class Apfelxx < Formula
  desc "Object oriented rewriting of the APFEL evolution code"
  homepage "https://github.com/vbertone/apfelxx"
  url "https://github.com/vbertone/apfelxx/archive/4.6.0.tar.gz"
  sha256 "37ad4121dfa5726ebe09cd2b7cf148976feb063ec6aeae7332ad9adc29c41543"

  depends_on "cmake" => :build
  depends_on "gcc"

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    system "#{bin}/apfelxx-config", "--dlflags"
  end
end
