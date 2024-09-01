class Hepmc3 < Formula
  desc "C++ event record for Monte Carlo generators"
  homepage "https://hepmc.web.cern.ch/"
  url "https://hepmc.web.cern.ch/releases/HepMC3-3.2.7.tar.gz"
  sha256 "587faa6556cc54ccd89ad35421461b4761d7809bc17a2e72f5034daea142232b"
  license "LGPL-3.0-or-later"
  revision 1

  livecheck do
    url "https://hepmc.web.cern.ch/hepmc/"
    regex(/href=.*?HepMC3[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://ghcr.io/v2/davidchall/hep"
    sha256 cellar: :any, arm64_sonoma: "60d6530c8f4f4e09607ffc5dd71431d54b42b9c5c0c3e20512a904bbc272de28"
    sha256 cellar: :any, ventura:      "9dac88f84a2092962176084f71fafcedf8fb513c083260dc56befcee1e802da0"
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
