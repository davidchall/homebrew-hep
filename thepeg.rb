class Thepeg < Formula
  homepage 'http://herwig.hepforge.org/'
  url 'http://www.hepforge.org/archive/thepeg/ThePEG-1.9.2.tar.gz'
  sha256 '67ad02c05bda877a338e59948c8314039f6152cc8228d881bd45edd12d1c1dc1'

  head do
    url 'http://thepeg.hepforge.org/hg/ThePEG', :using => :hg

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on 'gsl'
  depends_on 'hepmc'   => :recommended
  depends_on 'rivet'   => :recommended
  depends_on 'lhapdf'  => :recommended
  depends_on 'fastjet' => :recommended
  option 'with-check', 'Test during installation'

  def install
    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --enable-stdcxx11
    ]

    system "autoreconf", "-i" if build.head?
    system "./configure", *args
    system "make"
    system "make", "check" if build.with? 'check'
    system "make", "install"
  end

  test do
    system "setupThePEG", "#{share}/ThePEG/MultiLEP.in"
    system "runThePEG", "MultiLEP.run"
  end
end
