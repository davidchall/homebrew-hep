require 'formula'

class Rivet < Formula
  homepage 'http://rivet.hepforge.org/'
  url 'http://www.hepforge.org/archive/rivet/Rivet-2.0.0.tar.gz'
  sha1 '92ead69e98463254a4d035c0db38a5e488b63798'

  depends_on 'hepmc'
  depends_on 'fastjet'
  depends_on 'gsl'
  depends_on 'boost'
  depends_on 'yoda'
  depends_on 'yaml-cpp'
  depends_on :python

  # Superenv removes -g flag, which breaks binreloc
  env :std

  def patches
    # Need to check on this
    DATA
  end

  def install
    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --prefix=#{prefix}
      --with-hepmc=#{Formula.factory('hepmc').prefix}
      --with-fastjet=#{Formula.factory('fastjet').prefix}
      --with-gsl=#{Formula.factory('gsl').prefix}
    ]

    system "./configure", *args
    system "make", "install"

    prefix.install 'test'
  end

  test do
    system "cat #{prefix}/test/testApi.hepmc | #{bin}/rivet -a D0_2008_S7554427"
  end
end

__END__
diff --git a/include/Rivet/ProjectionHandler.hh b/include/Rivet/ProjectionHandler.hh
index 2483a9a..7d42d60 100644
--- a/include/Rivet/ProjectionHandler.hh
+++ b/include/Rivet/ProjectionHandler.hh
@@ -49,7 +49,7 @@ namespace Rivet {
 
     /// @brief Typedef for the structure used to contain named projections for a
     /// particular containing Analysis or Projection.
-    typedef map<const string, ProjHandle> NamedProjs;
+    typedef map<string, ProjHandle> NamedProjs;
 
     /// Enum to specify depth of projection search.
     enum ProjDepth { SHALLOW, DEEP };
