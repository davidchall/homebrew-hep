class Yoda < Formula
  homepage 'http://yoda.hepforge.org/'
  url "http://www.hepforge.org/archive/yoda/YODA-1.6.1.tar.gz"
  sha256 "70daf67163567d0d9d24fcbca5e4b9f3eca8c359f118395b8d2d21c420fc06c6"

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
