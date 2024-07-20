class Fastjet < Formula
  desc "Package for jet finding in pp and ee collisions"
  homepage "https://fastjet.fr"
  url "https://fastjet.fr/repo/fastjet-3.4.3.tar.gz"
  sha256 "cc175471bfab8656b8c6183a8e5e9ad05d5f7506e46f3212a9a8230905b8f6a3"
  license "GPL-2.0-or-later"

  livecheck do
    url "http://fastjet.fr/all-releases.html"
    regex(/href=.*?fastjet[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://ghcr.io/v2/davidchall/hep"
    sha256 cellar: :any, arm64_sonoma: "48190c33a348b353776b0838ea4053bc9139ccac8647f630df9a0a975218682f"
    sha256 cellar: :any, ventura:      "f35c50bc42f4ebbdae648613e18a8cba1b342950f9c8b39c323aae20bd22ded5"
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
