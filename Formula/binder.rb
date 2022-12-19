class Binder < Formula
  desc "Tool for automatic generation of Python bindings for C++"
  homepage "https://github.com/RosettaCommons/binder"
  url "https://github.com/RosettaCommons/binder/archive/refs/tags/v1.3.0.tar.gz"
  sha256 "22aaf4ade92a8acf15198e847a9f64ffd239f43252af24ceaa7cc8bdc45310b2"

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
