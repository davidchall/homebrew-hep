class Rivet < Formula
  include Language::Python::Shebang

  desc "Monte Carlo analysis system"
  homepage "https://rivet.hepforge.org"
  url "https://rivet.hepforge.org/downloads/?f=Rivet-3.1.10.tar.gz"
  sha256 "534389243e7fa3a407a08ac00a4cac9a133d03aedb0b334c19f4edc5889db343"
  license "GPL-3.0-only"

  livecheck do
    url "https://rivet.hepforge.org/downloads/"
    regex(/href=.*?Rivet[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://ghcr.io/v2/davidchall/hep"
    sha256 arm64_sonoma: "8c86aeda66a4952b1806612170ad5103ba3072a09edb242966427f1369af5879"
    sha256 ventura:      "2aa01d51b11bf444a61378b413a08788c5a7d3d0422e717e00278705af2f600d"
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
    url "https://fastjet.hepforge.org/contrib/downloads/fjcontrib-1.051.tar.gz"
    sha256 "76a2ec612c768db3eb6bbaf686d02b05ddb64dde477d185e20df563b52308473"
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
