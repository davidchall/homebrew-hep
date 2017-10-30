class Openloops < Formula
  desc "Fully automated implementation of the Open Loops algorithm"
  homepage "https://openloops.hepforge.org"
  url "https://www.hepforge.org/archive/openloops/OpenLoops-1.3.1.tar.gz"
  sha256 "b7610ca62edfab55d0990e94e38048b62b4af0c6b01830b44f40795cd86cb665"

  bottle do
    root_url "https://dl.bintray.com/davidchall/bottles-hep"
    cellar :any
    sha256 "f8bc5cf0dca69fc919509ccbbf0968f66bf55a666367b8ff8834a0feed13acaa" => :high_sierra
    sha256 "3ad94bed490c03bde85f0cea77e26a3bcd89be195d77476c41a0132887aba841" => :sierra
    sha256 "2ff311f8bd08e6f6377e73f7848bc4baffe45cce3b56907bf3aa20efbcbe6431" => :el_capitan
  end

  depends_on :fortran
  depends_on "scons" => :build

  patch :DATA

  def install
    scons
    cp_r ".", prefix
    bin.install_symlink prefix/"openloops"
  end

  def caveats; <<-EOS.undent
    OpenLoops downloads and installs process libraries in its
    own installation path: #{prefix}

    These process libraries are lost if OpenLoops is uninstalled.

    EOS
  end

  test do
    system bin/"openloops", "help"
  end
end

__END__
diff --git a/openloops b/openloops
index 5f068c9..e3e09f7 100755
--- a/openloops
+++ b/openloops
@@ -63,6 +63,9 @@ else
     return 0
        fi

+  # Make sure we execute everything from $BASEDIR
+  cd $BASEDIR
+
 fi

 #####################
