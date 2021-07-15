class Fastjet < Formula
  desc "Package for jet finding in pp and ee collisions"
  homepage "http://fastjet.fr"
  url "http://fastjet.fr/repo/fastjet-3.3.2.tar.gz"
  sha256 "3f59af13bfc54182c6bb0b0a6a8541b409c6fda5d105f17e03c4cce8db9963c2"

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
