require 'formula'

class Fastjet < Formula
  homepage 'http://fastjet.fr/'
  url 'http://fastjet.fr/repo/fastjet-3.0.4.tar.gz'
  sha1 '4e9aa6b93222949ab7367b5a8d3a8525b4f19d6e'

  depends_on 'cgal' => :optional
  option 'with-cgal', 'Enable CGAL support (required for NlnN strategy)'

  def install
    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --prefix=#{prefix}
      --enable-allcxxplugins
    ]

    args << "--with-cgal=#{Formula.factory('cgal').prefix}" if build.with? "cgal"

    system "./configure", *args
    system "make", "install"

    prefix.install 'example'
  end

  test do
    system "#{prefix}/example/fastjet_example < #{prefix}/example/data/single-event.dat"
  end
end
