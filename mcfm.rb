class Mcfm < Formula
  desc "Monte Carlo for FeMtobarn processes"
  homepage "http://mcfm.fnal.gov"
  url "http://mcfm.fnal.gov/MCFM-7.0.1.tar.gz"
  sha256 "316ada8fe5032d5bab5e5e556598a754f5f6d23c2c0e32cdf7e844f65235f0eb"

  keg_only "MCFM must be run from its install directory"

  depends_on "lhapdf" => :optional
  depends_on :fortran

  def install
    system "./Install"

    if build.with? "lhapdf"
      inreplace "makefile" do |s|
        s.change_make_var! "LHAPDFLIB", Formula["lhapdf"].opt_prefix
        s.change_make_var! "PDFROUTINES", "LHAPDF"
      end
    end

    # TODO: make an option to brew with openmp
    inreplace "makefile" do |s|
      s.change_make_var! "USEOMP", "NO"
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
      cp_r bin/fname, "."
    end
    cp bin/"input.DAT", "test.DAT"
    inreplace "test.DAT", "-1", "0"
    system bin/"mcfm", "test.DAT"
    assert File.exist?("W_only_lord_CT10.00_80__80__test.top")
    ohai "Successfully calculated W production at LO"
    ohai "Use 'brew test -v mcfm' to view ouput"
  end
end
