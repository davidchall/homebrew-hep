require "formula"

class Mcgrid < Formula
  homepage "http://mcgrid.hepforge.org"
  url "http://www.hepforge.org/archive/mcgrid/mcgrid-1.0.tar.gz"
  sha1 "3a6b314bbe44aef0197c710ecb124f25f7732ebf"

  depends_on "rivet"
  depends_on "applgrid"
  depends_on "boost"

  def patches
    DATA
  end

  def install

    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"

    prefix.install("examples")
    prefix.install("manual")

  end

  test do

    # Try to compile the example analyses and the convolution test program

    examples = prefix+'examples'

    makefile = examples+'Makefile'
    testcode = examples+'testcode'
    analyses = examples+'analyses'

    cp makefile, testpath
    cp_r testcode, testpath
    cp_r analyses, testpath

    system "make"

    ohai "Compilation of the example rivet analyses and the applgrid convolution test program works fine"
  end

  def caveats; <<-EOS.undent
    A manual is installed in:
      $(brew --prefix mcgrid)/manual

    Examples are installed in:
      $(brew --prefix mcgrid)/examples
    EOS
  end
end

__END__
diff --git a/examples/testcode/applgrid-test.cpp b/examples/testcode/applgrid-test.cpp
index d6aa716..52df9a3 100644
--- a/examples/testcode/applgrid-test.cpp
+++ b/examples/testcode/applgrid-test.cpp
@@ -81,7 +81,7 @@ int main(int argc, char* argv[]) {
    cout <<"Applgrid information:"<<endl;
   cout <<"Transform: "<<g.getTransform()<<endl;
   cout <<"GenPDF: "<<g.getGenpdf()<<endl;
-  cout <<"SubProc: "<<g.subProcesses()<<endl;
+  cout <<"SubProc: "<<g.subProcesses(nloops)<<endl;
   cout <<"Nbins: "<<g.Nobs()<<endl;
   cout <<endl<<"Convolution:"<<endl;
