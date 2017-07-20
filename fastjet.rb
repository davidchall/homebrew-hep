class Fastjet < Formula
  desc "Package for jet finding in pp and ee collisions"
  homepage "http://fastjet.fr"
  url "http://fastjet.fr/repo/fastjet-3.3.0.tar.gz"
  sha256 "e9da5b9840cbbec6d05c9223f73c97af1d955c166826638e0255706a6b2da70f"

  option "with-cgal", "Enable CGAL support (required for NlnN strategy)"
  option "with-test", "Test during installation"

  depends_on :python => :recommended
  depends_on "cgal" => :optional

  def install
    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --prefix=#{prefix}
      --enable-allcxxplugins
    ]

    args << "--with-cgal=#{Formula["cgal"].opt_prefix}" if build.with? "cgal"
    args << "--enable-pyext" if build.with? "python"

    system "./configure", *args
    system "make"
    system "make", "check" if build.with? "test"

    # make install fails with multiple jobs
    ENV.deparallelize
    system "make", "install"

    prefix.install "example"
  end

  test do
    system "#{prefix}/example/fastjet_example < #{prefix}/example/data/single-event.dat"
  end
end
