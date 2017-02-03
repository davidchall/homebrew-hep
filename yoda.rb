class Yoda < Formula
  desc "Yet more Objects for Data Analysis"
  homepage "http://yoda.hepforge.org"
  url "http://www.hepforge.org/archive/yoda/YODA-1.6.6.tar.gz"
  sha256 "407f3bea28bc668e0329f734c637a70c6d13f1d7afe0771493f6983515dd7566"

  head do
    url "http://yoda.hepforge.org/hg/yoda", :using => :hg

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
    depends_on "cython" => :python
  end

  option "with-test", "Test during installation"

  depends_on :python
  depends_on "homebrew/science/root6" => :optional
  depends_on "numpy" => :optional
  depends_on "homebrew/science/matplotlib" => :optional

  def install
    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --prefix=#{prefix}
    ]

    if build.with? "root6"
      args << "--enable-root"
      ENV.append "PYTHONPATH", Formula["root6"].opt_prefix/"lib/root" if build.with? "test"
    end

    system "autoreconf", "-i" if build.head?
    system "./configure", *args
    system "make"
    system "make", "check" if build.with? "test"
    system "make", "install"

    bash_completion.install share/"YODA/yoda-completion"
  end

  test do
    system "yoda-config", "--version"
  end
end
