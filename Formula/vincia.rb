class Vincia < Formula
  desc "Dipole-antenna shower plugin for Pythia8"
  homepage "https://vincia.hepforge.org"
  url "https://www.hepforge.org/archive/vincia/vincia-2.2.01.tgz"
  sha256 "ca98d1bb5f73192e01d1e054f3ba9c385df49a1256dc4c932bf40434b6d56d69"

  depends_on "pythia"
  depends_on "wget" => :build
  depends_on "gcc" # for gfortran

  def install
    args = %W[
      --prefix=#{prefix}
      --enable-shared
      --with-pythia8=#{Formula["pythia"].opt_prefix}
    ]

    system "./configure", *args
    system "make", "install"

    (share/"Vincia/examples").install Dir["examples/*"]
  end

  test do
    ENV["PYTHIA8DATA"] = Formula["pythia"].share/"Pythia8/xmldoc"
    ENV["VINCIADATA"] = share/"Vincia/xmldoc"

    cp_r share/"Vincia/examples/.", testpath
    system "make", "vincia01"
    system "./vincia01"
  end
end
