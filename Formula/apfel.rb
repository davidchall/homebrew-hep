class Apfel < Formula
  desc "A PDF Evolution Library"
  homepage "https://github.com/scarrazza/apfel"
  url "https://github.com/scarrazza/apfel/archive/refs/tags/3.0.6.tar.gz"
  sha256 "7063c9eee457e030b97926ac166cdaedd84625b31397e1dfd01ae47371fb9f61"

  depends_on "gcc" # for gfortran
  depends_on "lhapdf"
  depends_on "python@3.11"

  def install
    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --prefix=#{prefix}
      --enable-pywrap
      --enable-lhapdf
    ]  
    system "./configure", *args
    system "make"
    system "make", "install"
  end
end
