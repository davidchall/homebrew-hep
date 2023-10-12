class Lhapdf < Formula
  include Language::Python::Shebang

  desc "PDF interpolation and evaluation"
  homepage "https://lhapdf.hepforge.org/"
  url "https://lhapdf.hepforge.org/downloads/?f=LHAPDF-6.5.3.tar.gz"
  sha256 "57435cd695e297065d53e69bd29090765c934936b6a975ff8c559766f2230359"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://lhapdf.hepforge.org/downloads"
    regex(/href=.*?LHAPDF[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://ghcr.io/v2/davidchall/hep"
    rebuild 1
    sha256 ventura:  "9bb49ac1a0770fad48aa408344b4d218d302e99401cad6f33549c28264240cdd"
    sha256 monterey: "072b262cf7b118116ee1602ba36f493d4c88296e87dbd7ae0b82b21996c3882a"
  end

  head do
    url "http://lhapdf.hepforge.org/hg/lhapdf", using: :hg

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "cython" => :build
    depends_on "libtool" => :build
  end

  depends_on "python@3.10"

  patch :DATA

  def python
    "python3.10"
  end

  def install
    ENV.prepend_path "PATH", Formula["python@3.10"].opt_libexec/"bin"
    ENV.prepend_create_path "PYTHONPATH", prefix/Language::Python.site_packages(python)

    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
    ]

    system "autoreconf", "-i" if build.head?
    system "./configure", *args
    system "make"
    system "make", "install"

    rewrite_shebang detected_python_shebang, bin/"lhapdf"
  end

  def caveats
    <<~EOS
      PDFs may be downloaded and installed with

        lhapdf install CT10nlo

      At runtime, LHAPDF searches #{share}/LHAPDF
      and paths in LHAPDF_DATA_PATH for PDF sets.

    EOS
  end

  test do
    system bin/"lhapdf", "--help"
    system Formula["python@3.10"].opt_bin/python, "-c", "import lhapdf"
  end
end

__END__
diff --git a/wrappers/python/build.py.in b/wrappers/python/build.py.in
index c9d6710..8c2e633 100644
--- a/wrappers/python/build.py.in
+++ b/wrappers/python/build.py.in
@@ -34,23 +34,12 @@ libargs = " ".join("-l{}".format(l) for l in libraries)

 ## Python compile/link args
 pyargs = "-I" + sysconfig.get_config_var("INCLUDEPY")
-libpys = [os.path.join(sysconfig.get_config_var(ld), sysconfig.get_config_var("LDLIBRARY")) for ld in ["LIBPL", "LIBDIR"]]
-libpy = None
-for lp in libpys:
-    if os.path.exists(lp):
-        libpy = lp
-        break
-if libpy is None:
-    print("No libpython found in expected location {}, exiting".format(libpy))
-    sys.exit(1)
-pyargs += " " + libpy
 pyargs += " " + sysconfig.get_config_var("LIBS")
 pyargs += " " + sysconfig.get_config_var("LIBM")
-pyargs += " " + sysconfig.get_config_var("LINKFORSHARED")


 ## Assemble the compile & link command
-compile_cmd = "  ".join([os.environ.get("CXX", "g++"), "-shared -fPIC",
+compile_cmd = "  ".join([sysconfig.get_config_var("LDCXXSHARED"), "-std=c++11",
                          "-o", srcname.replace(".cpp", ".so"),
                          srcpath, incargs, cmpargs, linkargs, libargs, pyargs])
 print("Build command =", compile_cmd)
