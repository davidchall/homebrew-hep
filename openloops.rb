class Openloops < Formula
  desc "Fully automated implementation of the Open Loops algorithm"
  homepage "http://openloops.hepforge.org/index.html"
  url "http://www.hepforge.org/archive/openloops/OpenLoops-1.2.4.tar.gz"
  sha256 "6c13451a2cf4612ec37d9083c38585f8f37918a5a09b015a801cf15157671455"

  depends_on :fortran
  depends_on :python
  env :std
  patch :DATA

  def install
    system "./scons"
    cp_r ".", prefix
    bin.install_symlink "#{prefix}/openloops"
  end

  test do
    system "openloops", "help"
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
