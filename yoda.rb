require 'formula'

class Yoda < Formula
  homepage 'http://yoda.hepforge.org/'
  url 'http://www.hepforge.org/archive/yoda/YODA-1.0.4.tar.gz'
  sha1 '8077b5de16e6198826014a9e01adc7cbb30df401'

  head do
    url 'http://yoda.hepforge.org/hg/yoda', :using => :hg

    depends_on :autoconf
    depends_on :automake
    depends_on :libtool
    depends_on 'cython' => :python
  end

  depends_on :python
  depends_on 'boost'
  depends_on 'homebrew/science/root' => :optional
  option 'with-check', 'Test during installation'

  def install
    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --prefix=#{prefix}
    ]

    if build.with? 'root'
      args << "--enable-root"
      ENV.append "PYTHONPATH", Formula.factory('root').opt_prefix/"lib/root" if build.with? 'check'
    end

    system "autoreconf", "-i" if build.head?
    system "./configure", *args
    system "make"
    system "make", "check" if build.with? 'check'
    system "make", "install"
  end

  test do
    system "yoda-config", "--version"
  end

  def caveats; <<-EOS.undent
    For yoda2root script, try 'brew install yoda --HEAD --with-root'

    EOS
  end
end
