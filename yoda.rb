require 'formula'

class Yoda < Formula
  homepage 'http://yoda.hepforge.org/'
  url 'http://www.hepforge.org/archive/yoda/YODA-1.0.0.tar.gz'
  sha1 '78282a031dd1f46bf5e9e737e733a3d69c25b3d1'

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
