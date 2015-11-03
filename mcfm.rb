class Mcfm < Formula
  homepage 'http://mcfm.fnal.gov/'
  url 'http://mcfm.fnal.gov/MCFM-6.6.tar.gz'
  sha256 '01ed9998eaac9a4e013e65dc844de4e5e0a491408a152d6ead004e536552b66a'

  keg_only "MCFM must be run from its install directory"

  depends_on 'lhapdf' => :optional
  depends_on :fortran

  def install
    system "./Install"

    if build.with? 'lhapdf'
      inreplace 'makefile' do |s|
        s.change_make_var! "LHAPDFLIB", Formula['lhapdf'].prefix
        s.change_make_var! "PDFROUTINES", "LHAPDF"
      end
    end

    system "make"
    cp_r "Bin", bin

    ln_s "#{Formula['lhapdf'].share}/lhapdf/PDFsets", bin if build.with? 'lhapdf'
  end

  test do
    ["br.sm1", "br.sm2", "dm_parameters.DAT", "Pdfdata", "process.DAT"].each do |fname|
      ln_s(bin/fname, ".")
    end
    cp bin/"input.DAT", "test.DAT"
    inreplace "test.DAT", "-1", "0"
    system bin/"mcfm", "test.DAT"
    assert File.exist?("W_only_lord_cteq6_m_80__80__test.top")
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
