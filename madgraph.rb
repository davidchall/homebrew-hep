require 'formula'

class Madgraph < Formula
  homepage 'https://launchpad.net/madgraph5'
  url 'https://launchpad.net/madgraph5/trunk/1.5.0/+download/MadGraph5_v1.5.14.tar.gz'
  sha1 'a9409b96983d8d85c05a0cf6f8ac6cd165d58ba2'

  depends_on :fortran
  depends_on :python

  def install
    cp_r '.', prefix
    mv bin + 'mg5', bin + 'madgraph'
  end

  test do
    (testpath/'test.mg5').write("generate p p > t t~")
    system 'madgraph -f test.mg5'
    ohai "Successfully generated ttbar events"
    ohai "Use 'brew test -v madgraph' to view output"
  end
end
