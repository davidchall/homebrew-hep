class Fastjet < Formula
  desc "Package for jet finding in pp and ee collisions"
  homepage "http://fastjet.fr"
  url "http://fastjet.fr/repo/fastjet-3.3.0.tar.gz"
  sha256 "e9da5b9840cbbec6d05c9223f73c97af1d955c166826638e0255706a6b2da70f"

  bottle do
    root_url "https://dl.bintray.com/davidchall/bottles-hep"
    cellar :any
    sha256 "9ba45a8bc1e900206e1a0643acba3c868a7810253c4ab5db2a399e7abecf025c" => :high_sierra
    sha256 "18ac7f91f6e3bc7342f4556684ab80ca358aa8bb8a1ab9ff50c2afe29806e10a" => :sierra
    sha256 "097ddf33088b34ab349a8e2e7fdac050cd45b6f2a06760ece92d3d8b152ea4e2" => :el_capitan
    sha256 "031798c04e5e7b0f5725597edbc15c5b1524c880b5bf9a73dff55ce0eb663b0d" => :yosemite
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
