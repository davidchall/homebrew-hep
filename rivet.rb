class Rivet < Formula
  homepage 'http://rivet.hepforge.org/'
  url "http://www.hepforge.org/archive/rivet/Rivet-2.4.2.tar.gz"
  sha256 "8b994eb3358358fd304521f23cd080c5094cae60de46925ed3d9a5d5f6ab9953"

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
  depends_on :python
  option 'with-check', 'Test during installation'
  option 'without-analyses', 'Do not build Rivet analyses'
  option 'with-unvalidated', 'Build and install unvalidated analyses'

  def install
    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --enable-stdcxx11
      --prefix=#{prefix}
      --with-fastjet=#{Formula["fastjet"].prefix}
      --with-hepmc=#{Formula["hepmc"].prefix}
      --with-yoda=#{Formula["yoda"].prefix}
      --with-boost=#{Formula["boost"].prefix}
    ]

    args << '--disable-analyses' if build.without? 'analyses'
    args << '--enable-unvalidated' if build.with? 'unvalidated'

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
