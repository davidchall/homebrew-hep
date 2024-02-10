class Openloops < Formula
  desc "Fully automated implementation of the Open Loops algorithm"
  homepage "https://openloops.hepforge.org"
  url "https://gitlab.com/openloops/OpenLoops/-/archive/OpenLoops-2.1.3/OpenLoops-OpenLoops-2.1.3.tar.gz"
  sha256 "b26ee805d63b781244a5bab4db09f4a7a5a5c9ed371ead0d5260f00a0a94b233"
  license "GPL-3.0-or-later"

  livecheck do
    url :stable
    regex(/^-?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://ghcr.io/v2/davidchall/hep"
    sha256 cellar: :any, arm64_sonoma: "952880b1cc3f74b36a99e5c5bfac538b0fd16a96fb215e16a426b2a7acd32a31"
    sha256 cellar: :any, ventura:      "8434ccce0782cdba46e9026e4601e7f14ee288f7090668573deb4385be8471af"
  end

  depends_on "scons" => :build
  depends_on "gcc" # for gfortran

  patch :DATA

  def install
    system "scons"
    cp_r ".", prefix
    bin.install_symlink prefix/"openloops"

    cp prefix/"openloops.cfg.tmpl", prefix/"openloops.cfg"
    (prefix/"openloops.cfg").write <<~EOS, mode: "a+"
      generic_lib_dir = #{prefix}/lib/
      process_src_dir = #{prefix}/process_src/
      process_obj_dir = #{prefix}/process_obj/
      process_lib_dir = #{prefix}/proclib/
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
