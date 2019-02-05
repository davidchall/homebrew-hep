class Mcfm < Formula
  desc "Monte Carlo for FeMtobarn processes"
  homepage "https://mcfm.fnal.gov"
  url "https://mcfm.fnal.gov/MCFM-8.2.tar.gz"
  sha256 "075e3782d3cbe92539dc2835a7b94b657b0261717166b8911d4e13afdba83bfd"

  depends_on "gcc@7" # for gfortran
  depends_on "lhapdf" => :optional

  fails_with :gcc => "8" do
    cause <<~EOS
      gfortran v.8 fails with "Error: Actual argument contains too few
      elements for dummy argument 'ff'"

    EOS
  end

  fails_with :clang do
    build 1000
    cause "Needs OpenMP headers that are not available with clang"
  end

  def install
    system "FC=gfortran-7 ./Install"

    if build.with? "lhapdf"
      inreplace "makefile" do |s|
        s.change_make_var! "LHAPDFLIB", Formula["lhapdf"].opt_prefix
        s.change_make_var! "PDFROUTINES", "LHAPDF"
      end
    end

    system "FC=gfortran-7 make"
    bin.install "Bin/mcfm_omp"
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
    system bin/"mcfm_omp", "test.DAT"
    assert_predicate testpath/"W_only_nlo_CT14.NN_80___80___13TeV.top", :exist?
    ohai "Successfully calculated W production at LO"
    ohai "Use 'brew test -v mcfm' to view ouput"
  end
end
