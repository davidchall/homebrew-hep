class Yoda < Formula
  include Language::Python::Shebang

  desc "Yet more Objects for Data Analysis"
  homepage "https://yoda.hepforge.org"
  url "https://yoda.hepforge.org/downloads/?f=YODA-1.9.9.tar.gz"
  sha256 "b95398fac39f46ff73fb507c4739b4248f9689462d5b1c057caf7f3faffc1eb2"
  license "GPL-3.0-only"

  livecheck do
    url "https://yoda.hepforge.org/downloads/"
    regex(/href=.*?YODA[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://ghcr.io/v2/davidchall/hep"
    sha256 monterey: "984f157a7463c600e52309b9589b1cc0649f699a6da72a6670688d67174ee931"
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
  depends_on "root" => :optional

  if build.with? "test"
    depends_on "numpy"
  else
    depends_on "numpy" => :optional
  end

  patch :DATA

  def python
    "python3.10"
  end

  def install
    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --prefix=#{prefix}
    ]

    if build.with? "root"
      args << "--enable-root"
      ENV.append "PYTHONPATH", Formula["root"].opt_prefix/"lib/root" if build.with? "test"
    end

    # yoda attempts to install to HOMEBREW_PREFIX/lib/pythonX.Y/site-packages
    prefix_site_packages = prefix/Language::Python.site_packages(python)
    inreplace "configure", /(?<!#)YODA_PYTHONPATH=.+/, "YODA_PYTHONPATH=#{prefix_site_packages}"

    system "autoreconf", "-i" if build.head?
    system "./configure", *args
    system "make"
    system "make", "install"
    system "make", "check" if build.with? "test"

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
