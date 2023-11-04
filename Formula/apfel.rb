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

    prefix.install "examples/LuminosityCxx.cc"
  end

  test do
    flags = shell_output(bin/"apfel-config --cxxflags --ldflags").split
    system ENV.cxx, "-std=c++11", prefix/"LuminosityCxx.cc", "-o", "LuminosityCxx", *flags
    system "./LuminosityCxx"
  end
end

__END__
diff --git a/configure.ac b/configure.ac
@@ -85,7 +85,6 @@
 AC_ARG_ENABLE(pywrap, [AS_HELP_STRING([--disable-pywrap],[don't build Python module (default=build)])],
   [], [enable_pywrap=yes])   
 
-enable_pywrap=yes
 AZ_PYTHON_DEFAULT
 ## Basic Python checks
 if test x$enable_pywrap == xyes; then
