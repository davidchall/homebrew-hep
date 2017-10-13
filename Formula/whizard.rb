class Whizard < Formula
  desc "Monte Carlo event generator"
  homepage "http://whizard.hepforge.org"
  url "http://www.hepforge.org/archive/whizard/whizard-2.5.0.tar.gz"
  sha256 "4c8d50bec47a8d81636832a5d2acfd04fa26253ddb005138888d982484d4d470"

  depends_on :fortran
  depends_on "ocaml"
  depends_on "fastjet" => :optional
  depends_on "hoppet" => :optional
  depends_on "hepmc" => :optional
  depends_on "lhapdf" => :optional

  def install
    args = %W[
      --disable-dependency-tracking
      --enable-fc-openmp
      --enable-fc-quadruple
      --prefix=#{prefix}
    ]

    args << "--enable-hoppet" if build.with? "hoppet"
    args << "--enable-fastjet" if build.with? "fastjet"

    system "./configure", *args
    system "make", "install"
  end

  test do
    (testpath/"ee.sin").write <<-EOS.undent
    process ee = e1, E1 => e2, E2
    sqrts = 360 GeV
    n_events = 10
    sample_format = lhef
    simulate (ee)
    EOS

    system "whizard", "-r", testpath, "ee.sin"
    ohai "You just successfully generated 10 events!"
  end
end
