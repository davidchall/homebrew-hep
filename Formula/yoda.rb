class Yoda < Formula
  include Language::Python::Shebang

  desc "Yet more Objects for Data Analysis"
  homepage "https://yoda.hepforge.org"
  url "https://yoda.hepforge.org/downloads/?f=YODA-1.9.6.tar.gz"
  sha256 "5c57914eb8d8068844560e3a3e545f68d89ca49796dcc0932cdd42ee62064955"
  license "GPL-3.0-only"

  livecheck do
    url "https://yoda.hepforge.org/downloads/"
    regex(/href=.*?YODA[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://ghcr.io/v2/davidchall/hep"
    sha256 cellar: :any, monterey: "0ec3a35c6f5dc9acda350b6262e4fa3cef856f3ba327728ce2aec93118f82641"
    sha256 cellar: :any, big_sur:  "8817e9daa8c24ab08fb8ef3c1d30863ea702246929942c5ecffaff4cbf909bd8"
    sha256 cellar: :any, catalina: "387cca231a0d2104b5da40545bc357ef930f0b525cff204a548f9351fb4e24bd"
  end

  head do
    url "http://yoda.hepforge.org/hg/yoda", using: :hg

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "cython" => :build
    depends_on "libtool" => :build
  end

  option "with-test", "Test during installation"

  depends_on "python@3.9"
  depends_on "numpy" => :optional
  depends_on "root" => :optional

  def install
    ENV.prepend_path "PATH", Formula["python@3.9"].opt_libexec/"bin"

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

    rewrite_shebang detected_python_shebang, *bin.children
  end

  test do
    python = Formula["python@3.9"].opt_bin/"python3"
    system python, "-c", "import yoda"
    system bin/"yoda-config", "--version"
    system bin/"yodastack", "--help"
  end
end
