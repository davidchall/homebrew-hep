require 'formula'

class Madgraph < Formula
  homepage 'https://launchpad.net/madgraph5'
  url 'https://launchpad.net/madgraph5/trunk/1.5.0/+download/MadGraph5_v1.5.13.tar.gz'
  sha1 '55e0c36164be1b73a6c884d67f7a2054e86d1870'

  depends_on 'gfortran'
  depends_on :python

  def install
    cp_r '.', prefix
    mv bin + 'mg5', bin + 'madgraph'
  end

  test do
    system 'echo \'generate p p > t t~\' >> test.mg5'
    system 'echo \'quit\' >> test.mg5'
    system 'madgraph -f test.mg5'
  end
end
