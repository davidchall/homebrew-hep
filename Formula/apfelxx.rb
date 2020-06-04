class Apfelxx < Formula
  desc "Object oriented rewriting of the APFEL evolution code"
  homepage "https://github.com/vbertone/apfelxx"
  url "https://github.com/vbertone/apfelxx/archive/4.2.0.tar.gz"
  sha256 "5ad23e786bf185ce4be0672f7931f6a0a817309f8fdea8e8dab6139ed8dd9a9f"

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
