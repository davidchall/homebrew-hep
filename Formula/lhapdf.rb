class Lhapdf < Formula
  desc "PDF interpolation and evaluation"
  homepage "https://lhapdf.hepforge.org/"
  url "https://www.hepforge.org/archive/lhapdf/LHAPDF-6.4.0.tar.gz"
  sha256 "7d2f0267e2d65b0ddee048553b342d7c893a6dbabe1e326cad62de0010dd810c"

  head do
    url "http://lhapdf.hepforge.org/hg/lhapdf", using: :hg

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "cython" => :build
    depends_on "libtool" => :build
  end

  patch :DATA

  def install
    ENV.cxx11
    inreplace "wrappers/python/setup.py.in", "stdc++", "c++" if ENV.compiler == :clang

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

  def caveats
    <<~EOS
      PDFs may be downloaded and installed with

        lhapdf install CT10nlo

      At runtime, LHAPDF searches #{share}/LHAPDF
      and paths in LHAPDF_DATA_PATH for PDF sets.

    EOS
  end

  test do
    system "#{bin}/lhapdf", "help"
    system "python", "-c", "import lhapdf; lhapdf.version()"
  end
end
__END__
diff --git a/bin/lhapdf b/bin/lhapdf
index 4f99959..d4d056e 100644
--- a/bin/lhapdf
+++ b/bin/lhapdf
@@ -104,62 +104,21 @@ def download_url(source, dest_dir, dryrun=False):
 
     else:  # URL
         url = source
-        try:
-            import urllib.request as urllib
-        except ImportError:
-            import urllib2 as urllib
-        try:
-            u = urllib.urlopen(url)
-            content_length = u.info().get("Content-Length", 0)
-            if isinstance(content_length, list):
-                file_size = int(content_length[0]) if content_length else 0
-            else:
-                file_size = int(content_length)
-        except urllib.URLError:
-            e = sys.exc_info()[1]
-            logging.debug("Unable to download %s" % url)
-            return False
-
+        import urllib
         logging.debug("Downloading from %s" % url)
         logging.debug("Downloading to %s" % dest_filepath)
         if dryrun:
-            if file_size:
-                logging.info("%s [%s]" % (os.path.basename(url), convertBytes(file_size)))
-            else:
-                logging.info("%s" % os.path.basename(url))
             return False
 
         try:
-            dest_file = open(dest_filepath, "wb")
-        except IOError:
-            logging.error("Could not write to %s" % dest_filepath)
+            urllib.urlretrieve(url, dest_filepath)
+        except urllib.URLError:
+            e = sys.exc_info()[1]
+            logging.error('Error during download: ', e.reason)
+            return False
+        except KeyboardInterrupt:
+            logging.error('Download halted by user')
             return False
-        try:
-            try:
-                file_size_dl = 0
-                buffer_size = 8192
-                while True:
-                    buffer = u.read(buffer_size)
-                    if not buffer: break
-
-                    file_size_dl += len(buffer)
-                    dest_file.write(buffer)
-
-                    status = chr(13) + "%s: " % os.path.basename(url)
-                    status += r"%s" % convertBytes(file_size_dl).rjust(10)
-                    if file_size:
-                        status += r"[%3.1f%%]" % (file_size_dl * 100. / file_size)
-                    sys.stdout.write(status + " ")
-            except urllib.URLError:
-                e = sys.exc_info()[1]
-                logging.error("Error during download: ", e.reason)
-                return False
-            except KeyboardInterrupt:
-                logging.error("Download halted by user")
-                return False
-        finally:
-            dest_file.close()
-            print("")
 
     return True
 
