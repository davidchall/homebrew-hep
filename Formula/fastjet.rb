class Fastjet < Formula
  desc "Package for jet finding in pp and ee collisions"
  homepage "http://fastjet.fr"
  url "http://fastjet.fr/repo/fastjet-3.4.0.tar.gz"
  sha256 "ee07c8747c8ead86d88de4a9e4e8d1e9e7d7614973f5631ba8297f7a02478b91"

  bottle do
    root_url "https://ghcr.io/v2/davidchall/hep"
    sha256 cellar: :any, big_sur: "70bf614b145b8bdb130f07305784040e802e7b3fbc352bc140df5bce67886b01"
  end

  option "without-cgal", "Disable CGAL support (required for NlnN strategy)"
  option "with-test", "Test during installation"

  depends_on "python@3.9"
  depends_on "cgal" => :recommended

  def install
    ENV.prepend_path "PATH", Formula["python@3.9"].opt_libexec/"bin"

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
    system "make", "install"

    prefix.install "example"
  end

  test do
    ln_s prefix/"example/data", testpath
    ln_s prefix/"example/python", testpath
    system prefix/"example/fastjet_example < data/single-event.dat"
    cd "python" do
      system Formula["python@3.9"].opt_bin/"python3", "01-basic.py"
    end
  end
end
