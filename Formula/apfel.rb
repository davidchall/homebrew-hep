class Apfel < Formula
  desc "PDF Evolution Library"
  homepage "https://github.com/scarrazza/apfel"
  url "https://github.com/scarrazza/apfel/archive/refs/tags/3.1.1.tar.gz"
  sha256 "9006b2a9544e504e8f6b5047f665054151870c3c3a4a05db3d4fb46f21908d4b"
  license "GPL-3.0-only"

  bottle do
    root_url "https://ghcr.io/v2/davidchall/hep"
    sha256 cellar: :any, ventura:  "2dd5e0406d8b27a8706bcc07243e6308dbec116efd4969f1e2eea40914099bb0"
    sha256 cellar: :any, monterey: "ba2244e00b0f628887918aaa9769a27bf1b8d0e6d749e068a11a8d9b9ed4adb9"
  end

  option "with-test", "Test during installation"

  depends_on "cmake" => [:build, :test]
  depends_on "swig" => :build
  depends_on "gcc" # for gfortran
  depends_on "lhapdf"
  depends_on "python@3.10"

  def python
    "python3.10"
  end

  def install
    mkdir "../build" do
      args = %W[
        -DCMAKE_INSTALL_PREFIX=#{prefix}
        -DAPFEL_Python_SITEARCH=#{prefix/Language::Python.site_packages(python)}
      ]

      system "cmake", buildpath, *args
      system "make"
      system "make", "test" if build.with? "test"
      system "make", "install"
    end
  end

  test do
    assert_equal prefix.to_s, shell_output(bin/"apfel-config --prefix").strip
    system Formula["python@3.10"].opt_bin/python, "-c", "import apfel"
  end
end
