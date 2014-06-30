require 'formula'

class Pythia8 < Formula
  homepage 'http://pythia8.hepforge.org'
  url 'http://home.thep.lu.se/~torbjorn/pythia8/pythia8180.tgz'
  sha1 'aacc88d27937fd2bcfb5be39cd7055569859ba30'
  version '8.180'

  depends_on 'hepmc'

  option 'with-vincia', 'Enable VINCIA plugin (http://vincia.hepforge.org/)'
  if build.with? 'vincia'

    resource 'vincia' do
      url 'http://www.hepforge.org/archive/vincia/vincia-1.1.01.tgz'
      sha1 '5ec6bff1c2e9becb391d28705db644c8262074c6'
    end

    depends_on :fortran
    depends_on 'wget' => :build
  end

  def install
    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --prefix=#{prefix}
      --enable-shared
      --with-hepmc=#{Formula['hepmc'].opt_prefix}
    ]

    system "./configure", *args
    system "make", "install"

    prefix.install 'examples'

    if build.with? 'vincia'
      resource('vincia').stage do
        # Must tell VINCIA where to find Pythia 8 and libgfortran
        ENV['PYTHIA8'] = buildpath
        libgfortran = `$FC --print-file-name libgfortran.dylib`.chomp
        system "make", "FLIBS=-L#{File.dirname libgfortran} -lgfortran"

        (lib/'archive').install Dir['lib/archive/*']
        include.install Dir['include/*']
        (prefix/'xmldoc').install Dir['xmldoc/*']
        prefix.install 'README.TXT' => 'README.vincia'
        (share/'vincia').install 'antennae', 'tunes'
      end
    end
  end

  test do
    ENV['PYTHIA8DATA'] = "#{prefix}/xmldoc"

    system "make -C #{prefix}/examples/ main01"
    system "#{prefix}/examples/main01.exe"
    system "make -C #{prefix}/examples/ main41"
    system "#{prefix}/examples/main41.exe"
  end

  def caveats; <<-EOS.undent
    It is recommended to 'brew install sacrifice' now, as
    the easiest way to generate Pythia 8 events.

    Otherwise, programs can be built against the Pythia 8
    libraries by making use of 'pythia8-config'.

    EOS
  end
end
