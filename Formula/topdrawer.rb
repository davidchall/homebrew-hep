class Topdrawer < Formula
  desc "SLAC interface for generating physics graphs"
  homepage "https://ribf.riken.jp/comp/doc/topdrawer"
  url "http://ftp.riken.jp/pub/iris/topdrawer/topdrawer.tar.gz"
  version "1.4e"
  sha256 "2a44dffd19e243aa261b4e3cd2b0fe6247ced97ee10e3271f8c7eeae8cb62401"
  revision 2

  livecheck do
    skip "No version information available"
  end

  bottle do
    root_url "https://ghcr.io/v2/davidchall/hep"
    sha256 cellar: :any, arm64_sonoma: "c7d0ad76de92efbbfa7086fd50edb95f13848492ac533ebcdedf6e1174c577ef"
    sha256 cellar: :any, ventura:      "fcbf302cc5837b81bf9cd1f0c2855483c33a5c50d6410f93ac99a5399568b761"
  end

  depends_on "f2c" => :build
  depends_on "imake" => :build
  depends_on "ugs" => :build
  depends_on "gcc"
  depends_on "libice"
  depends_on "libsm"
  depends_on "libx11"
  depends_on "libxext"
  depends_on "libxt"

  patch :DATA

  def install
    ENV.deparallelize

    inreplace "Imakefile.def", /^UGS = .+/, "UGS = #{Formula["ugs"].opt_lib/"ugs.a"}"
    (buildpath/"misc/Imakefile").append_lines "CFLAGS += -I$(INCDIR)"
    (buildpath/ "src/Imakefile").append_lines "CFLAGS += -I$(INCDIR)"

    system "xmkmf", "-a"
    system "make", "clean"
    system "make", "all"

    bin.install "td"
    share.install "examples"
    share.install "doc"
  end

  test do
    system bin/"td", share/"examples/muon.top", "-d", "postscr"

    # ouput filename is garbled due to some bug
    output_file = testpath.children.max_by { |f| File.mtime(f) }
    ps_file = testpath/"test.ps"
    mv output_file, ps_file

    file_type = shell_output("file -b #{ps_file}")
    assert_equal "PostScript", file_type.split.first
  end
end

__END__
diff --git a/Imakefile.def b/Imakefile.def
index 3d7360f..27a5d4e 100644
--- a/Imakefile.def
+++ b/Imakefile.def
@@ -69,9 +69,9 @@ LDOPT   = -brename:.malloc_,.malloc -brename:.free_,.free
 
 #if defined(DarwinArchitecture)
 ARCH    = __Darwin
-FC      = g95
-FFLAGS  = -O2 -fstatic -fzero -freal-loops -fsloppy-char
-CFLAGS  = -O2 -DIUCLC=0001000
+FC      = gfortran
+FFLAGS  = -O2 -std=legacy -fallow-invalid-boz
+CFLAGS  = -O2 -DIUCLC=0001000 -Wno-error -Wno-implicit-function-declaration
 AR      = ar
 ARFLAGS = rsv
 RANCMD  =
