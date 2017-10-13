class Mcfm < Formula
  desc "Monte Carlo for FeMtobarn processes"
  homepage "http://mcfm.fnal.gov"
  url "http://mcfm.fnal.gov/MCFM-8.0.tar.gz"
  sha256 "6533a51a93bf97c967bf3bd8d530934c8eb94c84978be1e1f9a9d71319c80cc3"

  keg_only "MCFM must be run from its install directory"

  option "with-openmp", "Enable OpenMP multithreading"
  needs :openmp if build.with? "openmp"

  depends_on "lhapdf" => :optional
  depends_on :fortran

  def install
    if build.with? "openmp"
      system "./Install"
    else
      system "./Install_noomp"
      inreplace "makefile" do |s|
        s.change_make_var! "USEOMP", "NO"
      end
    end

    if build.with? "lhapdf"
      inreplace "makefile" do |s|
        s.change_make_var! "LHAPDFLIB", Formula["lhapdf"].opt_prefix
        s.change_make_var! "PDFROUTINES", "LHAPDF"
      end
    end

    system "make"
    cp_r "Bin", bin

    ln_s "#{Formula["lhapdf"].opt_share}/lhapdf/PDFsets", bin if build.with? "lhapdf"
  end

  def caveats; <<-EOS.undent
    If using LHAPDF for PDF sets, the PDF data directory
    must be symlinked to bin/PDFsets for MCFM to run.
    The default LHAPDF data path is symlinked by default.

    EOS
  end

  test do
    ["br.sm1", "br.sm2", "dm_parameters.DAT", "Pdfdata", "process.DAT"].each do |fname|
      ln_s bin/fname, "."
    end
    cp bin/"input.DAT", "test.DAT"
    inreplace "test.DAT", "-1", "0"
    system bin/"mcfm", "test.DAT"
    assert File.exist?("W_only_nlo_CT14.NN_80___80___13TeV.top")
    ohai "Successfully calculated W production at LO"
    ohai "Use 'brew test -v mcfm' to view ouput"
  end
end
