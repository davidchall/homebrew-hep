class Rivet < Formula
  include Language::Python::Shebang

  desc "Monte Carlo analysis system"
  homepage "https://rivet.hepforge.org"
  url "https://rivet.hepforge.org/downloads/?f=Rivet-3.1.8.tar.gz"
  sha256 "4795a8f522f4780e97bcc97511c4b0ace9dca9dd51a6004a713287a0dce45953"
  license "GPL-3.0-only"

  livecheck do
    url "https://rivet.hepforge.org/downloads/"
    regex(/href=.*?Rivet[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://ghcr.io/v2/davidchall/hep"
    sha256 ventura:  "3821b47fd974e7053e90b09c398ba76d51a8c232f5e370c739001666fc0bc5b7"
    sha256 monterey: "8cb2ca786a407078d30507127f4e4fe63aeb43bf2b01e4e2852468b19f533419"
  end

  head do
    url "http://rivet.hepforge.org/hg/rivet", using: :hg, branch: "tip"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "cython" => :build
    depends_on "libtool" => :build
  end

  option "with-test", "Test during installation"
  option "without-analyses", "Do not build Rivet analyses"
  option "with-unvalidated", "Build and install unvalidated analyses"

  depends_on "fastjet"
  depends_on "gsl"
  depends_on "hepmc3"
  depends_on "python@3.10"
  depends_on "yoda"

  # rivet needs a special installation of fjcontrib
  resource "fjcontrib" do
    url "https://fastjet.hepforge.org/contrib/downloads/fjcontrib-1.049.tar.gz"
    sha256 "ae2ed6206bc6278b65e99a4f78df0eeb2911f301a28fb57b50c573c0d5869987"
  end

  patch :DATA

  def python
    "python3.10"
  end

  def install
    resource("fjcontrib").stage do
      inreplace "Makefile.in",
        "libfastjetcontribfragile.@DYNLIBEXT@ $(PREFIX)/lib",
        "libfastjetcontribfragile.@DYNLIBEXT@ $(PREFIX)/lib/libfastjetcontribfragile.@DYNLIBEXT@"

      system "./configure", "--prefix=#{prefix}"
      system "make", "fragile-shared-install"
      system "make", "install"
    end

    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --prefix=#{prefix}
      --with-fastjet=#{Formula["fastjet"].opt_prefix}
      --with-fjcontrib=#{prefix}
      --with-hepmc3=#{Formula["hepmc3"].opt_prefix}
      --with-yoda=#{Formula["yoda"].opt_prefix}
    ]

    args << "--disable-analyses" if build.without? "analyses"
    args << "--enable-unvalidated" if build.with? "unvalidated"

    system "autoreconf", "-i" if build.head?

    # rivet attempts to install to HOMEBREW_PREFIX/lib/pythonX.Y/site-packages
    prefix_site_packages = prefix/Language::Python.site_packages(python)
    inreplace "configure", /(?<!#)RIVET_PYTHONPATH=.+/, "RIVET_PYTHONPATH=#{prefix_site_packages}"

    system "./configure", *args
    system "make"
    system "make", "install"
    system "make", "check" if build.with? "test"

    prefix.install "test/testApi.hepmc"
    rewrite_shebang detected_python_shebang, *bin.children
  end

  test do
    system Formula["python@3.10"].opt_bin/python, "-c", "import rivet"
    pipe_output bin/"rivet -q", File.read(prefix/"testApi.hepmc"), 0
  end
end

__END__
diff --git a/pyext/build.py.in b/pyext/build.py.in
index b23621b..8d011f5 100755
--- a/pyext/build.py.in
+++ b/pyext/build.py.in
@@ -62,26 +62,13 @@ libargs = " ".join("-l{}".format(l) for l in libraries)

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


 ## Assemble the compile & link command
-compile_cmd = "  ".join([os.environ.get("CXX", "g++"), "-shared -fPIC", "-o core.so",
+compile_cmd = "  ".join([sysconfig.get_config_var("LDCXXSHARED"), "-std=c++14", "-o core.so",
                          srcpath, incargs, cmpargs, linkargs, libargs, pyargs])
 print("Build command =", compile_cmd)
