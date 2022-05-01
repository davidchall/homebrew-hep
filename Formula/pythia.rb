class Pythia < Formula
  desc "Monte Carlo event generator"
  homepage "https://pythia.org"
  url "https://pythia.org/download/pythia83/pythia8307.tgz"
  version "8.307"
  sha256 "e5b14d44aa5943332e32dd5dda9a18fdd1a0085c7198e28d840e04167fa6013d"

  depends_on "boost"
  depends_on "hepmc3"
  depends_on "lhapdf"

  def install
    args = %W[
      --prefix=#{prefix}
      --with-hepmc3=#{Formula["hepmc3"].opt_prefix}
      --with-lhapdf6=#{Formula["lhapdf"].opt_prefix}
      --with-boost=#{Formula["boost"].opt_prefix}
    ]

    system "./configure", *args
    system "make"
    system "make", "install"
  end

  test do
    cp_r share/"Pythia8/examples/.", testpath
    system "make", "main01"
    system "./main01"
    system "make", "main41"
    system "./main41"
  end
end
