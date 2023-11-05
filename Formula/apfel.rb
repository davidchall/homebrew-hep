class Apfel < Formula
  desc "PDF Evolution Library"
  homepage "https://github.com/scarrazza/apfel"
  url "https://github.com/scarrazza/apfel/archive/refs/tags/3.0.6.tar.gz"
  sha256 "7063c9eee457e030b97926ac166cdaedd84625b31397e1dfd01ae47371fb9f61"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "gcc" # for gfortran
  depends_on "lhapdf"

  patch :DATA

  def install
    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --prefix=#{prefix}
      --disable-pywrap
      --enable-lhapdf
    ]
    system "autoreconf", "-i"
    system "./configure", *args
    system "make"
    system "make", "install"

    prefix.install "examples"
  end

  test do
    flags = shell_output(bin/"apfel-config --cxxflags --ldflags").split
    system ENV.cxx, "-std=c++11", prefix/"examples/LuminosityCxx.cc", "-o", "LuminosityCxx", *flags
    system "./LuminosityCxx"
  end
end

__END__
diff --git a/Makefile.am b/Makefile.am
index 6e792d8..06c0f43 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -1,6 +1,9 @@
 ACLOCAL_AMFLAGS = -I m4
 
-SUBDIRS = include ccwrap src lib examples pywrap doc bin
+SUBDIRS = include ccwrap src lib examples  doc bin
+if ENABLE_PYWRAP
+SUBDIRS += pywrap
+endif
 dist_doc_DATA = README
 dist_pkgdata_DATA = src/HELL/data/*
 
diff --git a/configure.ac b/configure.ac
index 4b1845d..22d6dcf 100644
--- a/configure.ac
+++ b/configure.ac
@@ -85,7 +85,6 @@ AM_CONDITIONAL(ENABLE_LHAPDF, [test x$enable_lhapdf == xyes])
 AC_ARG_ENABLE(pywrap, [AS_HELP_STRING([--disable-pywrap],[don't build Python module (default=build)])],
   [], [enable_pywrap=yes])   
 
-enable_pywrap=yes
 AZ_PYTHON_DEFAULT
 ## Basic Python checks
 if test x$enable_pywrap == xyes; then
