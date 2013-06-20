require 'formula'

class Madgraph < Formula
  homepage 'https://launchpad.net/madgraph5'
  url 'https://launchpad.net/madgraph5/trunk/1.5.0/+download/MadGraph5_v1.5.10.tar.gz'
  sha1 '905c534bb2e1582e2c589af8eadb652e0336bc49'

  def install
    system "cp -r . #{prefix}"
  end

  test do
    system "echo \"generate p p > t t~\" >> test.mg5"
    system "echo \"quit\" >> test.mg5"
    system "mg5 -f test.mg5"
  end
end
