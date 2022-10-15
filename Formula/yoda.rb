class Yoda < Formula
  include Language::Python::Shebang

  desc "Yet more Objects for Data Analysis"
  homepage "https://yoda.hepforge.org"
  url "https://yoda.hepforge.org/downloads/?f=YODA-1.9.7.tar.gz"
  sha256 "abff3e56bc360e38b2dd32d49bd962d6e773e97da1d50140ac4703daa1d51c8b"
  license "GPL-3.0-only"

  livecheck do
    url "https://yoda.hepforge.org/downloads/"
    regex(/href=.*?YODA[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://ghcr.io/v2/davidchall/hep"
    sha256 cellar: :any, monterey: "71b2f8cc22a752ef312b6bdd47ab040bf01c89455b38b50cb90f5aa004e6b8b9"
    sha256 cellar: :any, big_sur:  "358ed4c58e9aafd95cbbbbdce724980e2b6cf8e5f8e8bfe8713ab8e96428dc5f"
    sha256 cellar: :any, catalina: "869c6a0eebb1b62fabfa9b6478723a7c022ecc2b516368ff342e06fa4a40b68f"
  end

  head do
    url "http://yoda.hepforge.org/hg/yoda", using: :hg

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "cython" => :build
    depends_on "libtool" => :build
  end

  option "with-test", "Test during installation"

  depends_on "python@3.10"
  depends_on "numpy" => :optional
  depends_on "root" => :optional

  patch :DATA

  def python
    "python3.10"
  end

  def install
    ENV.prepend_path "PATH", Formula["python@3.10"].opt_libexec/"bin"

    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --prefix=#{prefix}
    ]

    if build.with? "root"
      args << "--enable-root"
      ENV.append "PYTHONPATH", Formula["root"].opt_prefix/"lib/root" if build.with? "test"
    end

    system "autoreconf", "-i" if build.head?
    system "./configure", *args
    system "make"
    system "make", "check" if build.with? "test"
    system "make", "install"

    rewrite_shebang detected_python_shebang, *bin.children
  end

  test do
    system Formula["python@3.10"].opt_bin/python, "-c", "import yoda"
    system bin/"yoda-config", "--version"
    system bin/"yodastack", "--help"
  end
end

__END__
diff --git a/pyext/build.py.in b/pyext/build.py.in
index cdebf43..6694941 100755
--- a/pyext/build.py.in
+++ b/pyext/build.py.in
@@ -35,19 +35,6 @@ libargs = " ".join("-l{}".format(l) for l in libraries)

 ## Python compile/link args
 pyargs = "-I" + sysconfig.get_config_var("INCLUDEPY")
-libpys = [os.path.join(sysconfig.get_config_var(ld), sysconfig.get_config_var("LDLIBRARY")) for ld in ["LIBPL", "LIBDIR"]]
-libpys.extend( glob(os.path.join(sysconfig.get_config_var("LIBPL"), "libpython*.*")) )
-libpys.extend( glob(os.path.join(sysconfig.get_config_var("LIBDIR"), "libpython*.*")) )
-libpy = None
-for lp in libpys:
-    if os.path.exists(lp):
-        libpy = lp
-        break
-if libpy is None:
-    print("No libpython found in expected location exiting")
-    print("Considered locations were:", libpys)
-    sys.exit(1)
-pyargs += " " + libpy
 pyargs += " " + sysconfig.get_config_var("LIBS")
 pyargs += " " + sysconfig.get_config_var("LIBM")
 #pyargs += " " + sysconfig.get_config_var("LINKFORSHARED")
@@ -92,7 +79,8 @@ for srcname in srcnames:
         xlinkargs += " " + "@ROOT_LDFLAGS@ @ROOT_LIBS@"

     ## Assemble the compile & link command
-    compile_cmd = "  ".join([os.environ.get("CXX", "g++"), "-shared -fPIC", "-o {}.so".format(srcname),
+    compile_cmd = "  ".join([sysconfig.get_config_var("LDCXXSHARED"), "-std=c++11",
+                             "-o {}.so".format(srcname),
                              srcpath, incargs, xcmpargs, xlinkargs, libargs, pyargs])
     print("Build command =", compile_cmd)
