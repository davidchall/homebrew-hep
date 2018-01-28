class Applgrid < Formula
  desc "Quickly reproduce NLO calculations with any input PDFs"
  homepage "http://applgrid.hepforge.org"
  url "http://www.hepforge.org/archive/applgrid/applgrid-1.4.70.tgz"
  sha256 "37e191e0e8598b7ee486007733b99d39da081dd3411339da2468cb3d66e689fb"
  patch :DATA

  depends_on "gcc" # for gfortran
  cxxstdlib_check :skip

  depends_on "homebrew/science/root"
  depends_on "hoppet" => :recommended
  depends_on "lhapdf" => :optional

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
diff --git a/appl_grid/appl_grid.h b/appl_grid/appl_grid.h
index 5059622..bcf5b67 100644
--- a/appl_grid/appl_grid.h
+++ b/appl_grid/appl_grid.h
@@ -56,7 +56,7 @@ public:
   class exception : public std::exception { 
   public:
     exception(const std::string& s) { std::cerr << what() << " " << s << std::endl; }; 
-    exception(std::ostream& s)      { std::cerr << what() << " " << s << std::endl; }; 
+    exception(std::ostream& s)      { std::cerr << std::endl; }; 
     virtual const char* what() const throw() { return "appl::grid::exception"; }
   };
 
diff --git a/appl_grid/appl_pdf.h b/appl_grid/appl_pdf.h
index c71fd84..5ac5abd 100644
--- a/appl_grid/appl_pdf.h
+++ b/appl_grid/appl_pdf.h
@@ -51,7 +51,7 @@ public:
   class exception : public std::exception { 
   public: 
     exception(const std::string& s="") { std::cerr << what() << " " << s << std::endl; }; 
-    exception(std::ostream& s)         { std::cerr << what() << " " << s << std::endl; }; 
+    exception(std::ostream& s)         { std::cerr << std::endl; }; 
     const char* what() const throw() { return "appl::appl_pdf::exception "; }
   };
   
diff --git a/src/appl_igrid.h b/src/appl_igrid.h
index d25288e..a39fd46 100644
--- a/src/appl_igrid.h
+++ b/src/appl_igrid.h
@@ -52,7 +52,7 @@ private:
   class exception { 
   public:
     exception(const std::string& s) { std::cerr << s << std::endl; }; 
-    exception(std::ostream& s)      { std::cerr << s << std::endl; }; 
+    exception(std::ostream& s)      {}; 
   };
 
   typedef double (igrid::*transform_t)(double) const;
