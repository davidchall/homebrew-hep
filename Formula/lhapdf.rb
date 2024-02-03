class Lhapdf < Formula
  include Language::Python::Shebang

  desc "PDF interpolation and evaluation"
  homepage "https://lhapdf.hepforge.org/"
  url "https://lhapdf.hepforge.org/downloads/?f=LHAPDF-6.5.4.tar.gz"
  sha256 "2443a4b32cc3b0597c8248bd6e25703ace9c91a7a253c5f60b1b5428ef9c869e"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://lhapdf.hepforge.org/downloads"
    regex(/href=.*?LHAPDF[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://ghcr.io/v2/davidchall/hep"
    sha256 monterey: "8ac041f9166e92beaf547c36d654cd76ecdccb82985cf1a9207d9926181c1ef5"
    sha256 big_sur:  "53bc6ec90e5134be7e5b9f9d92e41502f4b6193586e1af34402054e0efdb9221"
    sha256 catalina: "0c69beafb2ca891b920ed07937368b5623c88d07d982f208040c2a8866573260"
  end

  head do
    url "http://lhapdf.hepforge.org/hg/lhapdf", using: :hg

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "cython" => :build
    depends_on "libtool" => :build
  end

  depends_on "python@3.10"

  # fix brew audit:
  # * python modules have explicit framework links
  #   These python extension modules were linked directly to a Python
  #   framework binary. They should be linked with -undefined dynamic_lookup
  #   instead of -lpython or -framework Python.
  patch :DATA

  def python
    "python3.10"
  end

  def install
    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
    ]

    system "autoreconf", "-i" if build.head?
    system "./configure", *args
    system "make"
    system "make", "install", "PYTHON_PATH=#{prefix/Language::Python.site_packages(python)}"

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
index d9d1624..40ad0e7 100755
--- a/wrappers/python/build.py.in
+++ b/wrappers/python/build.py.in
@@ -48,8 +48,7 @@ if libpy is None:
     print("No libpython found in expected location exiting")
     print("Considered locations were:", libpys)
     sys.exit(1)
-pyargs += " " + libpy
-pyargs += " " + sysconfig.get_config_var("LIBS")
+pyargs += " -undefined dynamic_lookup"
 pyargs += " " + sysconfig.get_config_var("LIBM")
 #pyargs += " " + sysconfig.get_config_var("LINKFORSHARED")
 
