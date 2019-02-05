class Whizard < Formula
  desc "Monte Carlo event generator"
  homepage "https://whizard.hepforge.org"
  url "http://whizard.hepforge.org/whizard-2.7.0.tar.gz"
  sha256 "97a50705a8ba4174206cdc2c9cf0981a4046352e815e1903f124a92bd05eb4a9"

  depends_on "gcc" # for gfortran
  depends_on "ocaml"
  depends_on "fastjet" => :optional
  depends_on "hepmc" => :optional
  depends_on "hoppet" => :optional
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

    chmod 0755, Dir[bin/"*.*sh"]
  end

  test do
    (testpath/"ee.sin").write <<~EOS
      process ee = e1, E1 => e2, E2
      sqrts = 360 GeV
      n_events = 10
      sample_format = lhef
      simulate (ee)
    EOS

    system "#{bin}/whizard", "-r", testpath, "ee.sin"
    ohai "You just successfully generated 10 events!"
  end
end
