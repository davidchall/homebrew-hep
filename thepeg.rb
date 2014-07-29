require 'formula'

class Thepeg < Formula
  homepage 'http://herwig.hepforge.org/'
  url 'http://www.hepforge.org/archive/thepeg/ThePEG-1.9.2.tar.gz'
  sha1 'a5a09b90fb45e43c1e84ac55e4ee26b9bf4d55c5'

  head do
    url 'http://thepeg.hepforge.org/hg/ThePEG', :using => :hg

    depends_on :autoconf
    depends_on :automake
    depends_on :libtool
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
