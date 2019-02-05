class Lhapdf < Formula
  desc "PDF interpolation and evaluation"
  homepage "https://lhapdf.hepforge.org/"
  url "https://www.hepforge.org/archive/lhapdf/LHAPDF-6.2.1.tar.gz"
  sha256 "6d57ced88592bfd0feca4b0b50839110780c3a1cd158091c075a155c5917202e"

  bottle do
    root_url "https://dl.bintray.com/davidchall/bottles-hep"
    sha256 "c42504e9609b05383b06249023a0d3d1a55e80d8b3a7ab716e993142d78382c7" => :high_sierra
    sha256 "550b93a493c3b30fcdb5f2b2326d53758fb8f5d0d76a645eecda6fb239170c05" => :sierra
    sha256 "c61871005b6f6207946de9ae3f5f710a9ec5e695f324b03ac26dc554a547d432" => :el_capitan
  end

  head do
    url "http://lhapdf.hepforge.org/hg/lhapdf", :using => :hg

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

  def caveats; <<~EOS
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
diff --git a/bin/lhapdf.in b/bin/lhapdf.in
index 8687cff..8582e15 100644
--- a/bin/lhapdf.in
+++ b/bin/lhapdf.in
@@ -271,53 +271,20 @@ def download_url(source, dest_dir, dryrun=False):

     else: # URL
         url = source
-        try:
-            import urllib.request as urllib
-        except ImportError:
-            import urllib2 as urllib
-        try:
-            u = urllib.urlopen(url)
-            file_size = int(u.info().get('Content-Length')[0])
-        except urllib.URLError:
-            e = sys.exc_info()[1]
-            logging.error('Unable to download %s' % url)
-            return False
-
+        import urllib
         logging.debug('Downloading from %s' % url)
         logging.debug('Downloading to %s' % dest_filepath)
         if dryrun:
-            logging.info('%s [%s]' % (os.path.basename(url), convertBytes(file_size)))
             return False
-
         try:
-            dest_file = open(dest_filepath, 'wb')
-        except IOError:
-            logging.error('Could not write to %s' % dest_filepath)
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
-                buffer_size  = 8192
-                while True:
-                    buffer = u.read(buffer_size)
-                    if not buffer: break
-
-                    file_size_dl += len(buffer)
-                    dest_file.write(buffer)
-
-                    status  = chr(13) + '%s: ' % os.path.basename(url)
-                    status += r'%s [%3.1f%%]' % (convertBytes(file_size_dl).rjust(10), file_size_dl * 100. / file_size)
-                    sys.stdout.write(status+' ')
-            except urllib.URLError:
-                e = sys.exc_info()[1]
-                logging.error('Error during download: ', e.reason)
-                return False
-            except KeyboardInterrupt:
-                logging.error('Download halted by user')
-                return False
-        finally:
-            dest_file.close()
-            print('')

     return True


