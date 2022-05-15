class Fastjet < Formula
  desc "Package for jet finding in pp and ee collisions"
  homepage "http://fastjet.fr"
  url "http://fastjet.fr/repo/fastjet-3.4.0.tar.gz"
  sha256 "ee07c8747c8ead86d88de4a9e4e8d1e9e7d7614973f5631ba8297f7a02478b91"
  license "GPL-2.0-or-later"

  livecheck do
    url "http://fastjet.fr/all-releases.html"
    regex(/href=.*?fastjet[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://ghcr.io/v2/davidchall/hep"
    rebuild 1
    sha256 cellar: :any, monterey: "8391ca25a36a28be07e680a6af1419b43c3f130c18485af6c560bd87663e782f"
    sha256 cellar: :any, big_sur:  "64793fb0741fda6358b64297cc07a2c9c5386fc25dba0fce8d125d918cb9e7d0"
    sha256 cellar: :any, catalina: "44ea80df7cdce1f0078bc40bcc1fe9039c69b73b2e37236bc6b134eb25c85d54"
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

    python = Formula["python@3.9"].opt_bin/"python3"
    cd "python" do
      system python, "01-basic.py"
    end
  end
end
