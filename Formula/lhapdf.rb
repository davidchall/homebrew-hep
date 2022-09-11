class Lhapdf < Formula
  include Language::Python::Shebang

  desc "PDF interpolation and evaluation"
  homepage "https://lhapdf.hepforge.org/"
  url "https://lhapdf.hepforge.org/downloads/?f=LHAPDF-6.5.1.tar.gz"
  sha256 "1256419e2227d1a4f93387fe1da805e648351417d3755e8af5a30a35a6a66751"
  license "GPL-3.0-or-later"
  revision 2

  livecheck do
    url "https://lhapdf.hepforge.org/downloads"
    regex(/href=.*?LHAPDF[._-]v?(\d+(?:\.\d+)+)\.t/i)
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
    system "./configure", "--disable-python", *args
    system "make"
    system "make", "install"

    system "./configure", "--enable-python", *args
    cd "wrappers/python" do
      system python, *Language::Python.setup_install_args(prefix, python)
    end

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
diff --git a/wrappers/python/setup.py.in b/wrappers/python/setup.py.in
index 21a3d27..5b52590 100644
--- a/wrappers/python/setup.py.in
+++ b/wrappers/python/setup.py.in
@@ -22,7 +22,7 @@ libdir = os.path.abspath("@top_builddir@/src/.libs")
 ext = Extension("lhapdf",
                 ["lhapdf.cpp"],
                 include_dirs=[incdir_src, incdir_build],
-                extra_compile_args=["-I@prefix@/include"],
+                extra_compile_args=["-std=c++11", "-I@prefix@/include"],
                 library_dirs=[libdir],
                 language="C++",
                 libraries=["stdc++", "LHAPDF"])
