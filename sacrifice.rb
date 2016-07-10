class Sacrifice < Formula
  desc "Standalone package for steering Pythia8"
  homepage "https://agile.hepforge.org/trac/wiki/Sacrifice"
  url "http://www.hepforge.org/archive/agile/Sacrifice-1.0.0.tar.gz"
  sha256 "cf5cc91a01c8edb9dedc354f07aadaaf05092ab3bcf9a560f05fd7390cbe7b81"

  head do
    url "http://agile.hepforge.org/svn/contrib/Sacrifice", :using => :svn

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pythia8"
  depends_on "hepmc"
  depends_on "lhapdf" => :recommended

  def install
    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --with-pythia=#{Formula["pythia8"].opt_prefix}
    ]

    system "autoreconf", "-i" if build.head?
    system "./configure", *args
    system "make", "install"
  end

  def caveats; <<-EOS.undent
    Sacrifice has installed the executable 'run-pythia'.
    Please use 'brew home sacrifice' for more info.

    EOS
  end

  test do
    system "run-pythia --collision-energy 8000 -c 'SoftQCD:all=on' -n 100"
    ohai "Successfully generated 100 soft QCD events."
    ohai "Use 'brew test -v sacrifice' to view output"
  end
end
