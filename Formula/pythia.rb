class Pythia < Formula
  desc "Monte Carlo event generator"
  homepage "http://home.thep.lu.se/~torbjorn/Pythia.html"
  url "https://pythia.org/download/pythia82/pythia8243.tgz"
  version "8.243"
  sha256 "067219fb737bfd379ddb602b609ff5cd04f0569782f8d9d59e403264fd8a21f3"

  depends_on "boost"
  depends_on "hepmc"
  depends_on "lhapdf"

  def install
    args = %W[
      --prefix=#{prefix}
      --enable-shared
      --with-hepmc2=#{Formula["hepmc"].opt_prefix}
      --with-lhapdf6=#{Formula["lhapdf"].opt_prefix}
      --with-boost=#{Formula["boost"].opt_prefix}
    ]

    system "./configure", *args
    system "make", "install"
  end

  test do
    ENV["PYTHIA8DATA"] = share/"Pythia8/xmldoc"

    cp_r share/"Pythia8/examples/.", testpath
    system "make", "main01"
    system "./main01"
    system "make", "main41"
    system "./main41"
  end
end
