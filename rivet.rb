require 'formula'

class Rivet < Formula
  homepage 'http://rivet.hepforge.org/'
  url 'http://www.hepforge.org/archive/rivet/Rivet-2.2.1.tar.gz'
  sha1 '6ff483a443d007a492d0e8b8f478b1311ecb592e'

  head do
    url 'http://rivet.hepforge.org/hg/rivet', :using => :hg, :branch => 'tip'

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
    depends_on 'cython' => :python
  end

  depends_on 'hepmc'
  depends_on 'fastjet'
  depends_on 'gsl'
  depends_on 'boost'
  depends_on 'yoda'
  depends_on 'yaml-cpp'
  depends_on :python
  option 'with-check', 'Test during installation'
  option 'without-analyses', 'Do not build Rivet analyses'

  def install
    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --prefix=#{prefix}
      --with-fastjet=#{Formula["fastjet"].prefix}
      --with-hepmc=#{Formula["hepmc"].prefix}
      --with-yoda=#{Formula["yoda"].prefix}
    ]

    args << '--disable-analyses' if build.without? 'analyses'

    system "autoreconf", "-i" if build.head?
    system "./configure", *args
    system "make"
    system "make", "check" if build.with? 'check'
    system "make", "install"

    prefix.install 'test'
    bash_completion.install share/'Rivet/rivet-completion'
  end

  test do
    system "cat #{prefix}/test/testApi.hepmc | rivet -a D0_2008_S7554427"
    ohai "Successfully ran dummy HepMC file through Drell-Yan analysis"
  end
end
