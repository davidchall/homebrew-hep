require 'formula'

class Pythia8 < Formula
  homepage 'http://pythia8.hepforge.org'
  url 'http://home.thep.lu.se/~torbjorn/pythia8/pythia8215.tgz'
  sha256 '1b654ac3bf9254055052d1741c07b84c822bd6f349fa52068b5b4a25794d097e'
  version '8.215'

  depends_on 'hepmc'

  option 'with-vincia', 'Enable VINCIA plugin (http://vincia.hepforge.org)'
  if build.with? 'vincia'

    resource 'vincia' do
      url 'http://www.hepforge.org/archive/vincia/vincia-1.2.02.tgz'
      sha256 'de4318b6f0566e4f69fa14a121b694217af8634062a73a41a9dfe063af4ef194'
    end

    depends_on 'wget' => :build
    depends_on :fortran
    cxxstdlib_check :skip
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
