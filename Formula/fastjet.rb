class Fastjet < Formula
  desc "Package for jet finding in pp and ee collisions"
  homepage "http://fastjet.fr"
  url "http://fastjet.fr/repo/fastjet-3.3.2.tar.gz"
  sha256 "3f59af13bfc54182c6bb0b0a6a8541b409c6fda5d105f17e03c4cce8db9963c2"

  bottle do
    root_url "https://dl.bintray.com/davidchall/bottles-hep"
    sha256 cellar: :any, high_sierra: "9ba45a8bc1e900206e1a0643acba3c868a7810253c4ab5db2a399e7abecf025c"
    sha256 cellar: :any, sierra:      "18ac7f91f6e3bc7342f4556684ab80ca358aa8bb8a1ab9ff50c2afe29806e10a"
    sha256 cellar: :any, el_capitan:  "097ddf33088b34ab349a8e2e7fdac050cd45b6f2a06760ece92d3d8b152ea4e2"
    sha256 cellar: :any, yosemite:    "031798c04e5e7b0f5725597edbc15c5b1524c880b5bf9a73dff55ce0eb663b0d"
  end

  option "without-cgal", "Disable CGAL support (required for NlnN strategy)"
  option "with-test", "Test during installation"

  depends_on "cgal" => :recommended

  def install
    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --prefix=#{prefix}
      --enable-pyext
      --enable-allcxxplugins
    ]

    args << "--with-cgal=#{Formula["cgal"].opt_prefix}" if build.with? "cgal"

    system "./configure", *args
    system "make"
    system "make", "check" if build.with? "test"

    # make install fails with multiple jobs
    ENV.deparallelize
    system "make", "install"

    prefix.install "example"
  end

  test do
    ln_s prefix/"example/data", testpath
    ln_s prefix/"example/python", testpath
    system "#{prefix}/example/fastjet_example < data/single-event.dat"
    cd "python" do
      system "python", "01-basic.py"
    end
  end
end
