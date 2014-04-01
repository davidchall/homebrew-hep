require "formula"

class Mcgrid < Formula
  homepage "http://mcgrid.hepforge.org"
  url "http://www.hepforge.org/archive/mcgrid/mcgrid-1.0.1.tar.gz"
  sha1 "acf81099444b2ec3c632de343a22e41ce9373ea6"

  depends_on "rivet"
  depends_on "applgrid"
  depends_on "boost"

  def install

    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"

    prefix.install("examples")
    prefix.install("manual")
    bin.install Dir['scripts/*']

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

    Scripts for subprocess extraction are installed in:
      $(brew --prefix mcgrid)/bin
    and should be in the path. They are called
      identify[Generator]Subprocs.py,
    where `Generator` is "Amegic" or "Comix".
    EOS
  end
end
