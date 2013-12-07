require 'formula'

class Mcfm < Formula
  homepage 'http://mcfm.fnal.gov/'
  url 'http://mcfm.fnal.gov/MCFM-6.6.tar.gz'
  sha1 'fb07546aa84c4e02ebd317242b1ee756097d493c'

  keg_only "MCFM must be run from its install directory"

  depends_on 'lhapdf' => :optional
  depends_on :fortran

  def install
    system "./Install"

    if build.with? 'lhapdf'
      inreplace 'makefile' do |s|
        s.change_make_var! "LHAPDFLIB", Formula.factory('lhapdf').prefix
        s.change_make_var! "PDFROUTINES", "LHAPDF"
      end
    end

    system "make"
    cp_r "Bin", bin

    ln_s "#{Formula.factory('lhapdf').share}/lhapdf/PDFsets", bin if build.with? 'lhapdf'
  end

  test do
    cd bin do
      cp "input.DAT", "test.DAT"
      system "chmod u+w test.DAT"
      inreplace "test.DAT", "-1", "0"
      system "./mcfm", "test.DAT"
      rm "test.DAT"
    end
    ohai "Successfully calculated W production at LO"
    ohai "Use 'brew test -v mcfm' to view ouput"
  end

  def caveats; <<-EOS.undent
    If using LHAPDF for PDF sets, the PDF data directory
    must be symlinked to bin/PDFsets for MCFM to run.
    The default LHAPDF data path is symlinked by default.

    EOS
  end
end
