require 'formula'

class Fastjet < Formula
  homepage 'http://fastjet.fr/'
  url 'http://fastjet.fr/repo/fastjet-3.1.2.tar.gz'
  sha1 'dc71546f86c32699ab489ed037c85183cc64a8a8'

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

    args << "--with-cgal=#{Formula['cgal'].prefix}" if build.with? "cgal"

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
