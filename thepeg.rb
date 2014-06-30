require 'formula'

class Thepeg < Formula
  homepage 'http://herwig.hepforge.org/'
  url 'http://www.hepforge.org/archive/thepeg/ThePEG-1.9.1.tar.gz'
  sha1 'bd7adfba5c5fa6f6b55bcc58958ba4dabd228a7f'

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
    ]

    args << "--enable-stdcxx11"

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
