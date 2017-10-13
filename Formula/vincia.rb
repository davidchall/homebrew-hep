class Vincia < Formula
  desc "Dipole-antenna shower plugin for Pythia8"
  homepage "http://vincia.hepforge.org"
  url "http://www.hepforge.org/archive/vincia/vincia-2.0.01.tgz"
  sha256 "fac9be611fa2e6812a9c89e8a9a04b1d8f25ef458dd3598ef45ba5535338fa02"

  depends_on "pythia8"
  depends_on "wget" => :build
  depends_on :fortran

  def install
    args = %W[
      --prefix=#{prefix}
      --enable-shared
      --with-pythia8=#{Formula["pythia8"].opt_prefix}
    ]

    system "./configure", *args
    system "make", "install"

    (share/"Vincia/examples").install Dir["examples/*"]
  end

  test do
    ENV["PYTHIA8DATA"] = Formula["pythia8"].share/"Pythia8/xmldoc"
    ENV["VINCIADATA"] = share/"Vincia/xmldoc"

    cp_r share/"Vincia/examples/.", testpath
    system "make", "vincia01"
    system "./vincia01"
  end
end
