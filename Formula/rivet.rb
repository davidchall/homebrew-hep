class Rivet < Formula
  include Language::Python::Shebang

  desc "Monte Carlo analysis system"
  homepage "https://rivet.hepforge.org"
  url "https://rivet.hepforge.org/downloads/?f=Rivet-3.1.7.tar.gz"
  sha256 "d18993298b79cc9c0f086780ad5251df4647c565ba4a99b692458dcbd597378a"
  license "GPL-3.0-only"
  revision 1

  livecheck do
    url "https://rivet.hepforge.org/downloads/"
    regex(/href=.*?Rivet[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://ghcr.io/v2/davidchall/hep"
    sha256 monterey: "54124f92f663ac143dc672abce492fa7a4b95e771a26550f0c0abacac3fcf4d3"
    sha256 big_sur:  "e852c85f6c9ed3bd47dd56371366e2cb1baf3ba4676a15c8ae87d00dc3bea160"
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
    url "https://fastjet.hepforge.org/contrib/downloads/fjcontrib-1.048.tar.gz"
    sha256 "f9989d3b6aeb22848bcf91095c30607f027d3ef277a4f0f704a8f0fc2e766981"
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

    ENV["PYTHON"] = Formula["python@3.10"].opt_bin/python

    system "autoreconf", "-i" if build.head?
    system "./configure", *args
    system "make"
    system "make", "check" if build.with? "test"
    system "make", "install"

    prefix.install "test"
    rewrite_shebang detected_python_shebang, *bin.children
  end

  test do
    system Formula["python@3.10"].opt_bin/python, "-c", "import rivet"
    pipe_output bin/"rivet -q", File.read(prefix/"test/testApi.hepmc"), 0
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
