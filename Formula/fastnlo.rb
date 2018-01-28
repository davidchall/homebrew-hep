class Fastnlo < Formula
  desc "Fast pQCD calculations for PDF fits"
  homepage "http://fastnlo.hepforge.org"
  url "http://fastnlo.hepforge.org/code/v23/fastnlo_toolkit-2.3.1pre-2212.tar.gz"
  version "2.3.1.2212"
  sha256 "f7d16524db1e18cd5ee5fb493f0872ae4dc4a448e758d8ccdf5c090018b7f675"

  depends_on "lhapdf"
  depends_on "fastjet" => :optional
  depends_on "hoppet"  => :optional
  depends_on "qcdnum"  => :optional
  depends_on "yoda"    => :optional
  depends_on "homebrew/science/root" => :optional
  depends_on "python"  => :optional

  def am_opt(pkg)
    (build.with? pkg) ? "--with-#{pkg}=#{Formula[pkg].opt_prefix}" : "--without-#{pkg}"
  end

  def install
    args = %W[
      --disable-dependency-tracking
      --disable-silent-rules
      --prefix=#{prefix}
      --with-lhapdf=#{Formula["lhapdf"].opt_prefix}
    ]

    args << am_opt("fastjet")
    args << am_opt("qcdnum")
    args << am_opt("hoppet")
    args << am_opt("yoda")
    args << am_opt("root")
    args << "--enable-pyext" if build.with? "python"

    system "./configure", *args
    system "make", "install"
  end

  test do
    system "#{bin}/fnlo-tk-cppread", "-h"
  end
end
