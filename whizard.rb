class Whizard < Formula
  homepage "http://whizard.hepforge.org/"
  url "http://www.hepforge.org/archive/whizard/whizard-2.2.6.tar.gz"
  sha256 "5f9bcedcdcf091be8c65bb2a0d6fc47bb8e32d97b8a23aed2d33c0fd1015d275"

  depends_on :fortran
  depends_on "ocaml" => :recommended
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

    args << "--disable-ocaml" if build.without? "ocaml"
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
