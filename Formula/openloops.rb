class Openloops < Formula
  desc "Fully automated implementation of the Open Loops algorithm"
  homepage "https://openloops.hepforge.org"
  url "https://www.hepforge.org/archive/openloops/OpenLoops-1.3.1.tar.gz"
  sha256 "b7610ca62edfab55d0990e94e38048b62b4af0c6b01830b44f40795cd86cb665"

  depends_on "scons" => :build
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
