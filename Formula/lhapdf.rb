class Lhapdf < Formula
  include Language::Python::Shebang

  desc "PDF interpolation and evaluation"
  homepage "https://lhapdf.hepforge.org/"
  url "https://lhapdf.hepforge.org/downloads/?f=LHAPDF-6.4.0.tar.gz"
  sha256 "7d2f0267e2d65b0ddee048553b342d7c893a6dbabe1e326cad62de0010dd810c"

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
    system bin/"lhapdf", "--help"
    system Formula["python@3.9"].opt_bin/"python3", "-c", "import lhapdf; lhapdf.version()"
  end
end
