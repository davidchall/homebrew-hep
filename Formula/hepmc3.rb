class Hepmc3 < Formula
  desc "Library is to handle  event record for Monte Carlo generators"
  homepage "https://hepmc.web.cern.ch/hepmc/"
  url "https://hepmc.web.cern.ch/hepmc/releases/HepMC3-3.2.0.tar.gz"
  sha256 "f132387763d170f25a7cc9f0bd586b83373c09acf0c3daa5504063ba460f89fc"

  option "with-test", "Test during installation"
  option "with-root", "Enable root IO"
  option "with-python", "Enable building of python bindings"

  depends_on "cmake" => :build
  depends_on "root" => :optional
  depends_on "python" => :optional

  def install
    mkdir "../build" do
      args = %W[
        -DCMAKE_INSTALL_PREFIX=#{prefix}
      ]
      args<<"-DHEPMC3_ENABLE_TEST=ON" if build.with? "test"
      args<<"-DHEPMC3_ENABLE_ROOTIO=OFF" if build.without? "root"
      args<<"-DHEPMC3_ENABLE_PYTHON=OFF" if build.with? "python"
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
