class Hepmc3 < Formula
  desc "C++ event record for Monte Carlo generators"
  homepage "https://hepmc.web.cern.ch/"
  url "https://hepmc.web.cern.ch/hepmc/releases/HepMC3-3.2.5.tar.gz"
  sha256 "cd0f75c80f75549c59cc2a829ece7601c77de97cb2a5ab75790cac8e1d585032"
  license "GPL-3.0-or-later"

  option "with-test", "Test during installation"
  option "with-root", "Enable root IO"

  depends_on "cmake" => [:build, :test]
  depends_on "python@3.9"
  depends_on "root" => :optional

  def install
    # use system readlink
    inreplace "HepMC3-config.in", "greadlink", "readlink"

    mkdir "../build" do
      args = %W[
        -DCMAKE_INSTALL_PREFIX=#{prefix}
        -DHEPMC3_INSTALL_INTERFACES=ON
        -DHEPMC3_BUILD_STATIC_LIBS=OFF
        -DHEPMC3_PYTHON_VERSIONS=3.9
        -DHEPMC3_Python_SITEARCH39=#{prefix/Language::Python.site_packages("python3.9")}
      ]

      args << "-DHEPMC3_ENABLE_TEST=ON" if build.with? "test"
      args << "-DHEPMC3_ENABLE_ROOTIO=OFF" if build.without? "root"

      system "cmake", buildpath, *args
      system "make"
      system "make", "test" if build.with? "test"
      system "make", "install"
    end
  end

  test do
    assert_equal prefix.to_s, shell_output(bin/"HepMC3-config --prefix").strip

    python = Formula["python@3.9"].opt_bin/"python3"
    system python, "-c", "import pyHepMC3"

    cp_r share/"doc/HepMC3/examples/.", testpath
    system "cmake", "-DUSE_INSTALLED_HEPMC3=ON", "CMakeLists.txt"
    system "make", "basic_tree.exe"
    system "outputs/bin/basic_tree.exe"
  end
end
