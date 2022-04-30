class Hepmc3 < Formula
  desc "C++ event record for Monte Carlo generators"
  homepage "https://hepmc.web.cern.ch/"
  url "https://hepmc.web.cern.ch/hepmc/releases/HepMC3-3.2.5.tar.gz"
  sha256 "cd0f75c80f75549c59cc2a829ece7601c77de97cb2a5ab75790cac8e1d585032"

  bottle do
    root_url "https://ghcr.io/v2/davidchall/hep"
    rebuild 1
    sha256 cellar: :any, big_sur: "933a6df2bf7ff89635d370aae083eda97c5e877305e0eac2bf9d44743c31d81c"
  end

  option "with-test", "Test during installation"
  option "with-python", "Enable building of python bindings"
  option "with-root", "Enable root IO"

  depends_on "cmake" => [:build, :test]
  depends_on "python" => :optional
  depends_on "root" => :optional

  def install
    mkdir "../build" do
      args = %W[
        -DCMAKE_INSTALL_PREFIX=#{prefix}
        -DHEPMC3_INSTALL_INTERFACES=ON
      ]

      args << "-DHEPMC3_ENABLE_TEST=ON" if build.with? "test"
      args << "-DHEPMC3_ENABLE_PYTHON=OFF" if build.without? "python"
      args << "-DHEPMC3_ENABLE_ROOTIO=OFF" if build.without? "root"

      system "cmake", buildpath, *args
      system "make"
      system "make", "test" if build.with? "test"
      system "make", "install"
    end
  end

  test do
    cp_r share/"doc/HepMC3/examples/.", testpath
    system "cmake", "-DUSE_INSTALLED_HEPMC3=ON", "CMakeLists.txt"
    system "make", "basic_tree.exe"
    system "outputs/bin/basic_tree.exe"
  end
end
