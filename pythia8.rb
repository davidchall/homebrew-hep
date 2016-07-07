class Pythia8 < Formula
  homepage 'http://pythia8.hepforge.org'
  url 'http://home.thep.lu.se/~torbjorn/pythia8/pythia8215.tgz'
  sha256 '1b654ac3bf9254055052d1741c07b84c822bd6f349fa52068b5b4a25794d097e'
  version '8.215'

  depends_on 'hepmc'

  def install
    args = %W[
      --prefix=#{prefix}
      --enable-shared
      --with-hepmc2=#{Formula['hepmc'].opt_prefix}
    ]

    system "./configure", *args
    system "make", "install"
  end

  test do
    ENV['PYTHIA8DATA'] = share/"Pythia8/xmldoc"

    cp_r share/"Pythia8/examples/.", testpath
    system "make main01"
    system "./main01"
    system "make main41"
    system "./main41"
  end

  def caveats; <<-EOS.undent
    It is recommended to 'brew install sacrifice' now, as
    the easiest way to generate Pythia 8 events.

    Otherwise, programs can be built against the Pythia 8
    libraries by making use of 'pythia8-config'.

    EOS
  end
end
