require 'formula'

class Sacrifice < Formula
  homepage 'https://agile.hepforge.org/trac/wiki/Sacrifice'
  head 'http://agile.hepforge.org/svn/contrib/Sacrifice', :using => :svn

  depends_on :autoconf
  depends_on :automake
  depends_on :libtool

  depends_on 'pythia8'
  depends_on 'hepmc'
  depends_on 'lhapdf' => :recommended

  def install
    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --with-pythia=#{Formula['pythia8'].opt_prefix}
    ]

    system "autoreconf", "-i"
    system "./configure", *args
    system "make", "install"
  end

  test do
    system "pythia --collision-energy 8000 -c 'SoftQCD:all=on' -n 100"
    ohai "Successfully generated 100 soft QCD events."
    ohai "Use 'brew test -v sacrifice' to view output"
  end

  def caveats; <<-EOS.undent
    Sacrifice has installed the executable 'pythia'.
    Please use 'brew home sacrifice' for more info.

    EOS
  end
end
