class Hepmc3 < Formula
  desc "C++ event record for Monte Carlo generators"
  homepage "https://hepmc.web.cern.ch/"
  url "https://hepmc.web.cern.ch/hepmc/releases/HepMC3-3.2.6.tar.gz"
  sha256 "248f3b5b36dd773844cbe73d51f60891458334b986b259754c59dbf4bbf1d525"
  license "LGPL-3.0-or-later"

  livecheck do
    url "https://hepmc.web.cern.ch/hepmc/"
    regex(/href=.*?HepMC3[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://ghcr.io/v2/davidchall/hep"
    rebuild 1
    sha256 cellar: :any, monterey: "c23ed0a007c130b6b5e3866cd299b63ab9457a5cba0c1d04383865b3c576a28e"
    sha256 cellar: :any, big_sur:  "2248251cac9e1d4783a964dbffbfe047e4ba572ba8de86bb7267b9235f707a6f"
  end

  option "with-test", "Test during installation"

  depends_on "cmake" => [:build, :test]
  depends_on "coreutils" # HepMC3-config uses greadlink
  depends_on "python@3.10"
  depends_on "protobuf" => :optional
  depends_on "root" => :optional

  def python
    "python3.10"
  end

  def install
    mkdir "../build" do
      args = %W[
        -DCMAKE_INSTALL_PREFIX=#{prefix}
        -DHEPMC3_INSTALL_INTERFACES=ON
        -DHEPMC3_BUILD_STATIC_LIBS=OFF
        -DHEPMC3_PYTHON_VERSIONS=3.10
        -DHEPMC3_Python_SITEARCH310=#{prefix/Language::Python.site_packages(python)}
      ]

      args << "-DHEPMC3_ENABLE_TEST=ON" if build.with? "test"
      args << "-DHEPMC3_ENABLE_ROOTIO=OFF" if build.without? "root"
      args << "-DHEPMC3_ENABLE_PROTOBUFIO=ON" if build.with? "protobuf"

      system "cmake", buildpath, *args
      system "make"
      system "make", "test" if build.with? "test"
      system "make", "install"
    end
  end

  test do
    assert_equal prefix.to_s, shell_output(bin/"HepMC3-config --prefix").strip

    system Formula["python@3.10"].opt_bin/python, "-c", "import pyHepMC3"

    cp_r share/"doc/HepMC3/examples/.", testpath
    system "cmake", "-DUSE_INSTALLED_HEPMC3=ON", "CMakeLists.txt"
    system "make", "basic_tree.exe"
    system "outputs/bin/basic_tree.exe"
  end
end
