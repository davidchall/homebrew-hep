class Yoda < Formula
  include Language::Python::Shebang

  desc "Yet more Objects for Data Analysis"
  homepage "https://yoda.hepforge.org"
  url "https://yoda.hepforge.org/downloads/?f=YODA-1.9.5.tar.gz"
  sha256 "f07704f046d12b35814acc5d9e12675d98d54391b794b57d72ac11349c74a5bf"
  license "GPL-3.0-only"

  livecheck do
    url "https://yoda.hepforge.org/downloads/"
    regex(/href=.*?YODA[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://ghcr.io/v2/davidchall/hep"
    sha256 cellar: :any, monterey: "7efae44adea74025f588c798c3e7c8c060596a49941f5eb59deee0479bed80b3"
    sha256 cellar: :any, big_sur:  "56903bd59d21e8e54ea1c2d2d41a2576f204e0c3b0dab58564d697fc07774cbb"
    sha256 cellar: :any, catalina: "a188afc53fad7b784fcb7d195ca820a2f2c9d2bd91e85c7083e6e9ad3ed0dcad"
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
