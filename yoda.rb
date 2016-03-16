class Yoda < Formula
  homepage 'http://yoda.hepforge.org/'
  url "http://www.hepforge.org/archive/yoda/YODA-1.5.9.tar.bz2"
  sha256 "1a19cc8c34c08f1797a93d355250e682eb85d62d4ab277b6714d7873b4bdde75"

  head do
    url 'http://yoda.hepforge.org/hg/yoda', :using => :hg

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
    depends_on 'cython' => :python
  end

  depends_on :python
  depends_on 'boost'
  depends_on 'homebrew/science/root' => :optional
  depends_on "homebrew/python/numpy" => :recommended
  depends_on "homebrew/python/matplotlib" => :recommended
  option 'with-check', 'Test during installation'

  def install
    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --prefix=#{prefix}
    ]

    if build.with? 'root'
      args << "--enable-root"
      ENV.append "PYTHONPATH", Formula['root'].opt_prefix/"lib/root" if build.with? 'check'
    end

    system "autoreconf", "-i" if build.head?
    system "./configure", *args
    system "make"
    system "make", "check" if build.with? 'check'
    system "make", "install"

    bash_completion.install share/'YODA/yoda-completion'
  end

  test do
    system "yoda-config", "--version"
  end
end
