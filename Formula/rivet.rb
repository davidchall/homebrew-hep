class Rivet < Formula
  include Language::Python::Shebang

  desc "Monte Carlo analysis system"
  homepage "https://rivet.hepforge.org"
  url "https://rivet.hepforge.org/downloads/?f=Rivet-3.1.5.tar.gz"
  sha256 "fa5582d3b17b6197575111f3b390a09eca59502c8146d22290a9a98544c16938"

  bottle do
    root_url "https://ghcr.io/v2/davidchall/hep"
    sha256 monterey: "29424a47d929906d44afa4dd4d50a24680cb918bb911ecb89e2b55c0faa46fc1"
    sha256 big_sur:  "994733c064eb1a851d77030279d8fcf284aa1922dc82dc7b31d5de045eb924da"
    sha256 catalina: "162ca873c2a2c12a020e3df7e0b3f43cf49ed753ecb136c0966b530be18506f8"
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
