class Rivet < Formula
  include Language::Python::Shebang

  desc "Monte Carlo analysis system"
  homepage "https://rivet.hepforge.org"
  url "https://rivet.hepforge.org/downloads/?f=Rivet-3.1.6.tar.gz"
  sha256 "7d9b35fcf7e5cb61c4641bdcc499418e35dee84b7a06fa2d7df5d296f5f4201e"
  license "GPL-3.0-only"

  livecheck do
    url "https://rivet.hepforge.org/downloads/"
    regex(/href=.*?Rivet[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://ghcr.io/v2/davidchall/hep"
    sha256 monterey: "276fa63e2d678ea43808387d09a8c3f699a63bb3a3e00867fa4ec4f56a256d5c"
    sha256 big_sur:  "52472778d3d4a1f4ee49b7caee058d9138fdbe116c1d4ffdb7afbf66e24d0e85"
    sha256 catalina: "78153c5d89d8ea647b52d176f1f8096af7037815787e0dea7bfe3f66bd00f432"
  end

  head do
    url "http://rivet.hepforge.org/hg/rivet", using: :hg, branch: "tip"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "cython" => :build
    depends_on "libtool" => :build
  end

  option "with-test", "Test during installation"
  option "without-analyses", "Do not build Rivet analyses"
  option "with-unvalidated", "Build and install unvalidated analyses"

  depends_on "fastjet"
  depends_on "gsl"
  depends_on "hepmc3"
  depends_on "python@3.9"
  depends_on "yoda"

  # rivet needs a special installation of fjcontrib
  resource "fjcontrib" do
    url "https://fastjet.hepforge.org/contrib/downloads/fjcontrib-1.048.tar.gz"
    sha256 "f9989d3b6aeb22848bcf91095c30607f027d3ef277a4f0f704a8f0fc2e766981"
  end

  def install
    resource("fjcontrib").stage do
      inreplace "Makefile.in",
        "libfastjetcontribfragile.@DYNLIBEXT@ $(PREFIX)/lib",
        "libfastjetcontribfragile.@DYNLIBEXT@ $(PREFIX)/lib/libfastjetcontribfragile.@DYNLIBEXT@"

      system "./configure", "--prefix=#{prefix}"
      system "make", "fragile-shared-install"
      system "make", "install"
    end

    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --prefix=#{prefix}
      --with-fastjet=#{Formula["fastjet"].opt_prefix}
      --with-fjcontrib=#{prefix}
      --with-hepmc3=#{Formula["hepmc3"].opt_prefix}
      --with-yoda=#{Formula["yoda"].opt_prefix}
    ]

    args << "--disable-analyses" if build.without? "analyses"
    args << "--enable-unvalidated" if build.with? "unvalidated"

    ENV["PYTHON"] = Formula["python@3.9"].opt_bin/"python3"

    system "autoreconf", "-i" if build.head?
    system "./configure", *args
    system "make"
    system "make", "check" if build.with? "test"
    system "make", "install"

    prefix.install "test"
    rewrite_shebang detected_python_shebang, *bin.children
  end

  test do
    python = Formula["python@3.9"].opt_bin/"python3"
    system python, "-c", "import rivet"
    pipe_output bin/"rivet -q", File.read(prefix/"test/testApi.hepmc"), 0
  end
end
