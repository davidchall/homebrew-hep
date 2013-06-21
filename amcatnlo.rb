require 'formula'

class Amcatnlo < Formula
  homepage 'http://amcatnlo.web.cern.ch'
  url 'https://launchpad.net/madgraph5/trunk/1.5.0/+download/MadGraph5_v2.0.0.beta3.tar.gz'
  sha1 '84b931103e42de210db9b93cc4e6da56db5f18f8'
  version '2.0.0.beta3'

  depends_on 'fastjet'
  depends_on 'gfortran'

  def install
    cp_r '.', prefix
    mv bin + 'mg5', bin + 'amcatnlo'
  end

  test do
    system 'echo \'generate p p > t t~\' >> test.mg5'
    system 'echo \'quit\' >> test.mg5'
    system 'amcatnlo -f test.mg5'
  end

  def caveats; <<-EOS.undent
    Currently, in order to shower aMC@NLO events with Herwig++,
    it is necessary to change the HWPPPATH, THEPEGPATH and HEPMCPATH
    variables in ./Cards/shower_card.dat to /usr/local

    EOS
  end
end
