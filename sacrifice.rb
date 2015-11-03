class Sacrifice < Formula
  homepage 'https://agile.hepforge.org/trac/wiki/Sacrifice'
  url 'http://www.hepforge.org/archive/agile/Sacrifice-0.9.9.tar.gz'
  sha256 'dc1630424a527fe4b3a2a92d5f740d7aec20cd79485ef87b14ed7ec6255df83f'

  head do
    url 'http://agile.hepforge.org/svn/contrib/Sacrifice', :using => :svn

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on 'pythia8'
  depends_on 'hepmc'
  depends_on 'lhapdf' => :recommended

  def install
    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --with-pythia=#{Formula['pythia8'].opt_prefix}
    ]

    system "autoreconf", "-i" if build.head?
    system "./configure", *args
    system "make", "install"
  end

  test do
    system "run-pythia --collision-energy 8000 -c 'SoftQCD:all=on' -n 100"
    ohai "Successfully generated 100 soft QCD events."
    ohai "Use 'brew test -v sacrifice' to view output"
  end

  def caveats; <<-EOS.undent
    Sacrifice has installed the executable 'run-pythia'.
    Please use 'brew home sacrifice' for more info.

    EOS
  end
end
