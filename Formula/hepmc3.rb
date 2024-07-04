class Hepmc3 < Formula
  desc "C++ event record for Monte Carlo generators"
  homepage "https://hepmc.web.cern.ch/"
  url "https://hepmc.web.cern.ch/releases/HepMC3-3.3.0.tar.gz"
  sha256 "6f876091edcf7ee6d0c0db04e080056e89efc1a61abe62355d97ce8e735769d6"
  license "LGPL-3.0-or-later"

  livecheck do
    url "https://hepmc.web.cern.ch/hepmc/"
    regex(/href=.*?HepMC3[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://ghcr.io/v2/davidchall/hep"
    rebuild 1
    sha256 cellar: :any, arm64_sonoma: "c8f0f32185db72b5229805ae8356ba464c9d184acce779d56305b525cfe18dbb"
    sha256 cellar: :any, ventura:      "228982c1d84cea4c73631617626afd45f72159af358365afed2a0c9f50194f0a"
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
    system "make", "pythia6_example.exe"
    system "outputs/bin/pythia6_example.exe"
  end
end
