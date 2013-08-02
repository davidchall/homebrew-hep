require 'formula'

class Fjcontrib < Formula
  homepage 'http://fastjet.hepforge.org/contrib/'
  url 'http://fastjet.hepforge.org/contrib/downloads/fjcontrib-1.005.tar.gz'
  sha1 '766c108453f97da7412dbb16ce0f08ebbd1fcd4e'

  depends_on 'fastjet'

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end
end
