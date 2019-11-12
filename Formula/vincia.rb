class Vincia < Formula
  desc "Dipole-antenna shower plugin for Pythia8"
  homepage "https://vincia.hepforge.org"
  url "https://www.hepforge.org/archive/vincia/vincia-2.3.01.tgz"
  sha256 "ea2935fe55703559de2beabaa95f209d7b94195fb8380df93687e3cb0db99f06"

  depends_on "wget" => :build
  depends_on "gcc" # for gfortran
  depends_on "pythia"

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
