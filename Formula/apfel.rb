class Apfel < Formula
  desc "PDF Evolution Library"
  homepage "https://github.com/scarrazza/apfel"
  url "https://github.com/scarrazza/apfel/archive/refs/tags/3.1.1.tar.gz"
  sha256 "9006b2a9544e504e8f6b5047f665054151870c3c3a4a05db3d4fb46f21908d4b"
  license "GPL-3.0-only"

  bottle do
    root_url "https://ghcr.io/v2/davidchall/hep"
    sha256 cellar: :any, monterey: "19d8048e68d28ce69aec0d60aad241ac57c94094e789dcb2015be765fc8c795f"
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
