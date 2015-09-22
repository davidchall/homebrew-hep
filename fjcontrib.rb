require 'formula'

class Fjcontrib < Formula
  homepage 'http://fastjet.hepforge.org/contrib/'
  url 'http://fastjet.hepforge.org/contrib/downloads/fjcontrib-1.018.tar.gz'
  sha1 'c63eaa6d561271df408f9e48969d9189ad3fa4c8'

  depends_on 'fastjet'
  option 'with-check', 'Test during installation'

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "check" if build.with? 'check'
    system "make", "install"
  end
end
