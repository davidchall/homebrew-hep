require 'formula'

class Fastjet < Formula
  homepage 'http://fastjet.fr/'
  url 'http://fastjet.fr/repo/fastjet-3.0.6.tar.gz'
  sha1 'c70f175f17ea93d2f25d266c9ea7e4e4f3301d38'

  depends_on 'cgal' => :optional
  option 'with-cgal', 'Enable CGAL support (required for NlnN strategy)'
  option 'with-check', 'Test during installation'

  def install
    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --prefix=#{prefix}
      --enable-allcxxplugins
    ]

    args << "--with-cgal=#{Formula.factory('cgal').prefix}" if build.with? "cgal"

    system "./configure", *args
    system "make"
    system "make", "check" if build.with? 'check'
    system "make", "install"

    prefix.install 'example'
  end

  test do
    system "#{prefix}/example/fastjet_example < #{prefix}/example/data/single-event.dat"
  end
end
