class Lhapdf < Formula
  include Language::Python::Shebang

  desc "PDF interpolation and evaluation"
  homepage "https://lhapdf.hepforge.org/"
  url "https://lhapdf.hepforge.org/downloads/?f=LHAPDF-6.4.0.tar.gz"
  sha256 "7d2f0267e2d65b0ddee048553b342d7c893a6dbabe1e326cad62de0010dd810c"

  bottle do
    root_url "https://ghcr.io/v2/davidchall/hep"
    rebuild 1
    sha256 monterey: "2d4038d6fa63fd8e38dd7830bf85119044de2138b90e107c2c75c3575f547da8"
    sha256 big_sur:  "bf9c3cddc0a5560686e410b47458cca7babd3507d142c67ca6692d6112b66d7a"
    sha256 catalina: "b31b3333be0bfa2983460b75954e9ac56e16700b9bc61f5cff147c765e3d5704"
  end

  head do
    url "http://lhapdf.hepforge.org/hg/lhapdf", using: :hg

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "cython" => :build
    depends_on "libtool" => :build
  end

  depends_on "python@3.9"

  def install
    ENV.prepend_path "PATH", Formula["python@3.9"].opt_libexec/"bin"
    ENV.prepend_create_path "PYTHONPATH", prefix/Language::Python.site_packages("python3.9")

    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
    ]

    system "autoreconf", "-i" if build.head?
    system "./configure", "--disable-python", *args
    system "make"
    system "make", "install"

    system "./configure", "--enable-python", *args
    cd "wrappers/python" do
      system "python3", *Language::Python.setup_install_args(prefix)
    end

    rewrite_shebang detected_python_shebang, bin/"lhapdf"
  end

  def caveats
    <<~EOS
      PDFs may be downloaded and installed with

        lhapdf install CT10nlo

      At runtime, LHAPDF searches #{share}/LHAPDF
      and paths in LHAPDF_DATA_PATH for PDF sets.

    EOS
  end

  test do
    python = Formula["python@3.9"].opt_bin/"python3"
    system bin/"lhapdf", "--help"
    system python, "-c", "import lhapdf"
  end
end
