class Yoda < Formula
  desc "Yet more Objects for Data Analysis"
  homepage "https://yoda.hepforge.org"
  url "https://www.hepforge.org/archive/yoda/YODA-1.6.7.tar.gz"
  sha256 "9fbdb8e9b2951ee6b984b2d5350b0a5a9c93c6f4a70c51dd77daa87336753cf6"

  head do
    url "http://yoda.hepforge.org/hg/yoda", :using => :hg

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
    depends_on "cython" => :build
  end

  option "with-test", "Test during installation"

  depends_on "root" => :optional
  depends_on "numpy" => :optional
  depends_on "homebrew/science/matplotlib" => :optional

  def install
    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --prefix=#{prefix}
    ]

    if build.with? "root"
      args << "--enable-root"
      ENV.append "PYTHONPATH", Formula["root"].opt_prefix/"lib/root" if build.with? "test"
    end

    system "autoreconf", "-i" if build.head?
    system "./configure", *args
    system "make"
    system "make", "check" if build.with? "test"
    system "make", "install"

    bash_completion.install share/"YODA/yoda-completion"
  end

  test do
    system bin/"yoda-config", "--version"
  end
end
