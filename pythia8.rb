require 'formula'

class Pythia8 < Formula
  homepage 'http://pythia8.hepforge.org'
  url 'http://home.thep.lu.se/~torbjorn/pythia8/pythia8180.tgz'
  sha1 'aacc88d27937fd2bcfb5be39cd7055569859ba30'
  version '8.180'

  depends_on 'hepmc'

  def install
    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --prefix=#{prefix}
      --enable-shared
    ]

    args << "--with-hepmc=#{Formula.factory('hepmc').opt_prefix}" if build.with? "hepmc"

    system "./configure", *args
    system "make", "install"

    prefix.install 'examples'
  end

  test do
    ENV['PYTHIA8DATA'] = "#{prefix}/xmldoc"

    system "make -C #{prefix}/examples/ main01"
    system "#{prefix}/examples/main01.exe"
    system "make -C #{prefix}/examples/ main41"
    system "#{prefix}/examples/main41.exe"
  end

  def caveats; <<-EOS.undent
    Pythia 8 must know where to find its settings and
    particle data. This can be done using the environment
    variable "PYTHIA8DATA" or as an argument to the Pythia
    constructor in your main program.

    For csh/tcsh users:
      setenv PYTHIA8DATA `brew --prefix pythia8`/xmldoc
    For bash/zsh users:
      export PYTHIA8DATA=$(brew --prefix pythia8)/xmldoc

    EOS
  end
end
