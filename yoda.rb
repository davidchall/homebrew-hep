require 'formula'

class Yoda < Formula
  homepage 'http://yoda.hepforge.org/'
  url 'http://www.hepforge.org/archive/yoda/YODA-1.0.1.tar.gz'
  sha1 'b58d8a0f91989e6bd936180486f1e73cfbcdc795'

  depends_on 'cython' => :python
  depends_on 'boost'

  def install
    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --prefix=#{prefix}
    ]

    system "./configure", *args
    system "make", "install"
  end

  test do
    system "yoda-config", "--version"
  end
end
