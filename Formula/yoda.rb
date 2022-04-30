class Yoda < Formula
  include Language::Python::Shebang

  desc "Yet more Objects for Data Analysis"
  homepage "https://yoda.hepforge.org"
  url "https://yoda.hepforge.org/downloads/?f=YODA-1.9.4.tar.gz"
  sha256 "02d89e37fbe01c5b19140e7ded9082930f76bf3d15a6ff9742fd52c8f0e738d7"

  bottle do
    root_url "https://ghcr.io/v2/davidchall/hep"
    rebuild 1
    sha256 cellar: :any, monterey: "7d8066c9493267eb51dd2cf9df480723ef4e210643d33c2c4eba332722d69496"
    sha256 cellar: :any, big_sur:  "31e667ee68972ee0427ce8d2a99bdf439c48a6cbee290e68e798dc3e3d15b174"
    sha256 cellar: :any, catalina: "a3c03d1f831a4e9cfe9519abf5b07a55029cf56de1766b453910e12fadd4e25c"
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
