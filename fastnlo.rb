class Fastnlo < Formula
  desc "Fast pQCD calculations for PDF fits"
  homepage "http://fastnlo.hepforge.org"
  url "http://fastnlo.hepforge.org/code/v23/fastnlo_toolkit-2.3.1pre-2163.tar.gz"
  version "2.3.1.2163"
  sha256 "18c83d91bb37f526a411150e8bd3cbf7773b6bb3a70d26d9d92477a1faa24493"

  depends_on "lhapdf"
  depends_on "fastjet" => :optional
  depends_on "hoppet"  => :optional
  depends_on "qcdnum"  => :optional
  depends_on "yoda"    => :optional
  depends_on :python   => :optional

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
    args << "--enable-pyext" if build.with? "python"

    system "./configure", *args
    system "make", "install"
  end

  test do
    system "#{bin}/fnlo-tk-cppread", "-h"
  end
end
