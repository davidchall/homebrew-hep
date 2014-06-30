require 'formula'

class Sacrifice < Formula
  homepage 'https://agile.hepforge.org/trac/wiki/Sacrifice'
  url 'http://www.hepforge.org/archive/agile/Sacrifice-0.9.9.tar.gz'
  sha1 '3ce1ac020dea5c3b4505f6bf2de1e5c951cb4033'

  head do
    url 'http://agile.hepforge.org/svn/contrib/Sacrifice', :using => :svn

    depends_on :autoconf
    depends_on :automake
    depends_on :libtool
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
