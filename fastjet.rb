class Fastjet < Formula
  homepage 'http://fastjet.fr/'
  url 'http://fastjet.fr/repo/fastjet-3.2.0.tar.gz'
  sha256 '96a927f1a336ad93cff30f07e2dc137a4de8ff7d74d5cd43eb455f42cf5275e3'

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
