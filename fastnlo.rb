class Fastnlo < Formula
  homepage 'http://fastnlo.hepforge.org'
  url 'http://fastnlo.hepforge.org/code/v23/fastnlo_toolkit-2.3.1pre-1871.tar.gz'
  sha1 'bf536b78c5bb5bc5568e546454fc9dcb87db6978'
  version '2.3.1.1871'

  depends_on 'lhapdf'
  depends_on 'fastjet' => :optional
  depends_on 'hoppet'  => :optional
  depends_on 'qcdnum'  => :optional
  depends_on 'yoda'    => :optional
  depends_on :python   => :optional

  def am_opt(pkg)
    (build.with? pkg) ? "--with-#{pkg}=#{Formula[pkg].prefix}" : "--without-#{pkg}"
  end

  def install
    args = %W[
      --disable-dependency-tracking
      --disable-silent-rules
      --prefix=#{prefix}
      --with-lhapdf=#{Formula["lhapdf"].prefix}
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
