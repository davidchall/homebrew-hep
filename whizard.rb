require "formula"

class Whizard < Formula
  homepage "http://whizard.hepforge.org/"
  url "http://www.hepforge.org/archive/whizard/whizard-2.2.2.tar.gz"
  sha1 "eaad01978aa01181fdeec9788f5b8114de5e1fb5"

  depends_on :fortran
  depends_on 'objective-caml' => :recommended
  depends_on 'fastjet' => :optional
  depends_on 'hoppet' => :optional
  depends_on 'hepmc' => :optional
  depends_on 'lhapdf' => :optional


  def install
    args = %W[
          --disable-dependency-tracking
          --enable-fc-openmp
          --enable-fc-quadruple
          --prefix=#{prefix}
        ]

    args << "--enable-hoppet" if build.with? "hoppet"
    #args << "HOPPET=#{Formula['hoppet'].prefix}" if build.with? "hoppet"
    args << "--enable-fastjet" if build.with? "fastjet"
    #args << "--with-fastjet=#{Formula['fastjet'].prefix}" if build.with? "fastjet"

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
    puts "You just successfully generated 10 events!"
  end
end
