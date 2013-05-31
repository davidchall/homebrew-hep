require 'formula'

class Thepeg < Formula
  homepage 'http://herwig.hepforge.org/'
  url 'http://www.hepforge.org/archive/thepeg/ThePEG-1.8.3.tar.gz'
  sha1 '26a5971265f3e2d4bebddc9bc233d1ce757b3736'

  depends_on 'gsl'
  depends_on 'hepmc' => :recommended
  depends_on 'rivet' => :recommended

  def install
    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
    ]

    system "./configure", *args
    system "make", "install"
  end

  test do
    system "#{bin}/runThePEG --version"
  end
end
