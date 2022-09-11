class Rivet < Formula
  include Language::Python::Shebang

  desc "Monte Carlo analysis system"
  homepage "https://rivet.hepforge.org"
  url "https://rivet.hepforge.org/downloads/?f=Rivet-3.1.6.tar.gz"
  sha256 "7d9b35fcf7e5cb61c4641bdcc499418e35dee84b7a06fa2d7df5d296f5f4201e"
  license "GPL-3.0-only"
  revision 2

  livecheck do
    url "https://rivet.hepforge.org/downloads/"
    regex(/href=.*?Rivet[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://ghcr.io/v2/davidchall/hep"
    sha256 monterey: "bda35157a4d67caa4092c593a6febf197cecda8a45793fd5ec0c525b541d713e"
    sha256 big_sur:  "1556d7cc6147f961f27c461271610553997ac2ed061b892d5bd20f15e32c8dc1"
    sha256 catalina: "576a653c861e19bf5ef55a3fcf278fed79af809db86f43ff76cd62b42247c9ec"
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
  depends_on "python@3.10"
  depends_on "yoda"

  # rivet needs a special installation of fjcontrib
  resource "fjcontrib" do
    url "https://fastjet.hepforge.org/contrib/downloads/fjcontrib-1.048.tar.gz"
    sha256 "f9989d3b6aeb22848bcf91095c30607f027d3ef277a4f0f704a8f0fc2e766981"
  end

  def python
    "python3.10"
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

    ENV["PYTHON"] = Formula["python@3.10"].opt_bin/python

    # fix error: could not create '/opt/homebrew/lib/python3.9/site-packages/rivet':
    # Operation not permitted
    site_packages = prefix/Language::Python.site_packages(python)
    inreplace "pyext/Makefile.in",
              "$(abs_builddir)/setup.py install \\",
              "$(abs_builddir)/setup.py install --install-lib #{site_packages} \\"

    system "autoreconf", "-i" if build.head?
    system "./configure", *args
    system "make"
    system "make", "check" if build.with? "test"
    system "make", "install"

    prefix.install "test"
    rewrite_shebang detected_python_shebang, *bin.children
  end

  test do
    system Formula["python@3.10"].opt_bin/python, "-c", "import rivet"
    pipe_output bin/"rivet -q", File.read(prefix/"test/testApi.hepmc"), 0
  end
end
