class Binder < Formula
  desc "Tool for automatic generation of Python bindings for C++"
  homepage "https://github.com/RosettaCommons/binder"
  url "https://github.com/RosettaCommons/binder/archive/refs/tags/v1.2.0.tar.gz"
  sha256 "2e33f4d1c5855699127461c3794108b35bcdd7b48291d95d8259f2f6bba0c76b"

  depends_on "cmake" => :build
  depends_on "gsed" => :build
  depends_on "llvm" => :build

  def install
    mkdir "../build" do
      system "gsed", "-i", "s/Darwin/Nothing/g", "../binder-1.2.0/source/CMakeLists.txt"
      args = %W[
        -DCMAKE_INSTALL_PREFIX=#{prefix}
        -DBINDER_ENABLE_TEST=OFF
        -DLLVM_DIR=/usr/local/Cellar/llvm/13.0.1_1
      ]
      system "cmake", buildpath, *args
      system "make"
      system "make", "test" if build.with? "test"
      system "make", "install"
    end
  end

  test do
    system "make", "test"
  end
end
