class Openloops < Formula
  desc "Fully automated implementation of the Open Loops algorithm"
  homepage "https://openloops.hepforge.org"
  url "https://openloops.hepforge.org/downloads?f=OpenLoops-2.1.2.tar.gz"
  sha256 "f52575cae3d70b6b51a5d423e9cd0e076ed5961afcc015eec00987e64529a6ae"

  livecheck do
    url "https://openloops.hepforge.org/downloads"
    regex(/href=.*?OpenLoops[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  depends_on arch: :x86_64 # https://github.com/davidchall/homebrew-hep/issues/203
  depends_on "scons"
  depends_on "gcc" # for gfortran

  patch :DATA

  def install
    system "scons"
    cp_r ".", prefix
    bin.install_symlink prefix/"openloops"
  end

  def caveats
    <<~EOS
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
