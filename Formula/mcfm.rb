class Mcfm < Formula
  desc "Monte Carlo for FeMtobarn processes"
  homepage "https://mcfm.fnal.gov"
  url "https://mcfm.fnal.gov/MCFM-8.1.tar.gz"
  sha256 "45b8f05813b6da2dd57811650654ee7dfac3e5197347291cc7bedb31d3ce3d87"

  option "with-openmp", "Enable OpenMP multithreading"
  needs :openmp if build.with? "openmp"

  depends_on "lhapdf" => :optional
  depends_on "gcc" # for gfortran

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
    bin.install "Bin/mcfm"
    pkgshare.install Dir["Bin/*"]
    doc.install "Doc/mcfm.pdf"
  end

  def post_install
    pkgshare.install_symlink "#{Formula["lhapdf"].opt_share}/lhapdf/PDFsets" if build.with? "lhapdf"
  end

  def caveats; <<~EOS
    Running MCFM requires files found in #{pkgshare}

    If using LHAPDF for PDF sets, the PDF data directory
    must be symlinked to bin/PDFsets for MCFM to run.
    The default LHAPDF data path is symlinked by default.

    EOS
  end

  test do
    Dir[pkgshare/"*"].each do |fname|
      ln_s fname, "."
    end
    cp pkgshare/"input.DAT", "test.DAT"
    inreplace "test.DAT", "-1", "0"
    system bin/"mcfm", "test.DAT"
    assert_predicate testpath/"W_only_nlo_CT14.NN_80___80___13TeV.top", :exist?
    ohai "Successfully calculated W production at LO"
    ohai "Use 'brew test -v mcfm' to view ouput"
  end
end
