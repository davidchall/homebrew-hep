class Fastjet < Formula
  desc "Package for jet finding in pp and ee collisions"
  homepage "https://fastjet.fr"
  url "https://fastjet.fr/repo/fastjet-3.4.2.tar.gz"
  sha256 "b3d33155b55ce43f420cd6d99b525acf7bdc2593a7bb7ea898a9ddb3d8ca38e3"
  license "GPL-2.0-or-later"

  livecheck do
    url "http://fastjet.fr/all-releases.html"
    regex(/href=.*?fastjet[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://ghcr.io/v2/davidchall/hep"
    sha256 cellar: :any, monterey: "6e6f1ba39501284c160b663366f8997a8f75dbb372bb56eac188dc59e3eac002"
    sha256 cellar: :any, big_sur:  "e5b33f49864f0da21b01221f68a6d10054aecbd23c21963b06e0925bf2e6533c"
    sha256 cellar: :any, catalina: "71a0340ffe9e82a94f3420001c4cefd66aa549967b48ca9bb8a138796af6980b"
  end

  option "without-cgal", "Disable CGAL support (required for NlnN strategy)"
  option "with-test", "Test during installation"

  depends_on "python@3.10"
  depends_on "cgal" => :recommended

  def python
    "python3.10"
  end

  def install
    ENV.prepend_path "PATH", Formula["python@3.10"].opt_libexec/"bin"

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
      system Formula["python@3.10"].opt_bin/python, "01-basic.py"
    end
  end
end
