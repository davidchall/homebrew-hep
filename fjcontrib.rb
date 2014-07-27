require 'formula'

class Fjcontrib < Formula
  homepage 'http://fastjet.hepforge.org/contrib/'
  url 'http://fastjet.hepforge.org/contrib/downloads/fjcontrib-1.013.tar.gz'
  sha1 'dad0182668e0f990ff17541c095b0178a5fbeae4'

  depends_on 'fastjet'
  option 'with-check', 'Test during installation'

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "check" if build.with? 'check'
    system "make", "install"
  end
end
