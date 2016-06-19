class Openloops < Formula
  desc "Fully automated implementation of the Open Loops algorithm"
  homepage "http://openloops.hepforge.org"
  url "http://www.hepforge.org/archive/openloops/OpenLoops-1.3.1.tar.gz"
  sha256 "b7610ca62edfab55d0990e94e38048b62b4af0c6b01830b44f40795cd86cb665"

  depends_on :fortran
  depends_on :python
  env :std
  patch :DATA

  def install
    system "./scons"
    cp_r ".", prefix
    bin.install_symlink prefix/"openloops"
  end

  test do
    system "openloops", "help"
  end

  def caveats; <<-EOS.undent
    OpenLoops downloads and installs process libraries in its
    own installation path: #{prefix}

    These process libraries are lost if OpenLoops is uninstalled.

    EOS
  end
end
