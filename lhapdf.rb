require 'formula'

class Lhapdf < Formula
  homepage 'http://lhapdf.hepforge.org/'
  url 'http://www.hepforge.org/archive/lhapdf/LHAPDF-6.0.5.tar.gz'
  sha1 'e4c48dc91bc1eaa394d94ce381eb5b83be3e3eaa'

  head do
    url 'http://lhapdf.hepforge.org/hg/lhapdf', :using => :hg

    depends_on :autoconf
    depends_on :automake
    depends_on :libtool
    depends_on 'cython' => :python
  end

  depends_on 'boost'
  depends_on 'cmake' => :build
  depends_on :python

  def patches
    DATA
  end

  def install
    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --prefix=#{prefix}
    ]

    system "autoreconf", "-i" if build.head?
    system "./configure", *args
    system "make"
    system "make", "install"
  end

  test do
    system "lhapdf help"
  end

  def caveats; <<-EOS.undent
    LHAPDF searches #{share}/LHAPDF 
    and paths in LHAPDF_DATA_PATH for PDF sets.
    These can be installed with the 'lhapdf' script.

    EOS
  end
end

__END__
diff --git a/include/LHAPDF/GridPDF.h b/include/LHAPDF/GridPDF.h
index c1452da..40a2dae 100644
--- a/include/LHAPDF/GridPDF.h
+++ b/include/LHAPDF/GridPDF.h
@@ -250,10 +250,10 @@ namespace LHAPDF {
     mutable std::vector<double> _q2knots;
 
     /// Typedef of smart pointer for ipol memory handling
-    typedef unique_ptr<Interpolator> InterpolatorPtr;
+    typedef std::unique_ptr<Interpolator> InterpolatorPtr;
 
     /// Typedef of smart pointer for xpol memory handling
-    typedef unique_ptr<Extrapolator> ExtrapolatorPtr;
+    typedef std::unique_ptr<Extrapolator> ExtrapolatorPtr;
 
     /// Associated interpolator (mutable to allow laziness)
     mutable InterpolatorPtr _interpolator;
