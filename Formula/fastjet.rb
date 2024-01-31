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
    rebuild 1
    sha256 cellar: :any, arm64_sonoma: "081d2f3649258e79b01fac9ec1a963307ae49d269db95516569206aab82f66d7"
    sha256 cellar: :any, ventura:      "21a55a9714fcb7c23613c892f8d5fb9c0c0a958797545e4181ea882aa494d83d"
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
