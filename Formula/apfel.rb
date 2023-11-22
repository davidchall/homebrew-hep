class Apfel < Formula
  desc "PDF Evolution Library"
  homepage "https://github.com/scarrazza/apfel"
  url "https://github.com/scarrazza/apfel/archive/refs/tags/3.1.0.tar.gz"
  sha256 "0a7e693536de6a9a84504c221a77cd8154fd939c3332d21dfce74432d468f4fd"
  license "GPL-3.0-only"

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
