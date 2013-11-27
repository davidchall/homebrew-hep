require 'formula'

class Applgrid < Formula
  homepage 'http://applgrid.hepforge.org'
  url 'http://www.hepforge.org/archive/applgrid/applgrid-1.4.40.tgz'
  sha1 '046b3e2b21ab53d497c4b562930b26cab85f16f4'

  depends_on :fortran
  depends_on 'root'
  depends_on 'hoppet' => :recommended
  depends_on 'lhapdf' => :optional

  def patches
    DATA
  end

  def install
    ENV.j1

    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "applgrid-config", "--version"
  end
end

__END__
diff --git a/src/Cache.h b/src/Cache.h
index 9f3729c..28455d7 100644
--- a/src/Cache.h
+++ b/src/Cache.h
@@ -84,7 +84,7 @@ public:
       _pdf( x, Q2, &_xf[0] ); 
 
       /// add to cache if enough room
-      if ( this->size()<_max ) insert( typename _map::value_type( t, _xf ) );
+      if ( this->size()<_max ) this->insert( typename _map::value_type( t, _xf ) );
 
       /// copy to output 
       (*(partons*)xf) = ( *((partons*)&_xf[0]) ); 
