require 'formula'

class Sacrifice < Formula
  homepage 'https://agile.hepforge.org/trac/wiki/Sacrifice'
  url 'http://www.hepforge.org/archive/agile/Sacrifice-0.9.1.tar.gz'
  sha1 'c73935f1da816a90dbf1d67d4399fcff6fb32b23'

  depends_on 'pythia8'
  depends_on 'hepmc'
  depends_on 'lhapdf' => :recommended

  def install
    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --with-pythia=#{Formula.factory('pythia8').opt_prefix}
    ]

    system "./configure", *args
    system "make", "install"
  end

  test do
    system "pythia --collision-energy 8000 -c 'SoftQCD:all=on' -n 100"
    ohai "Successfully generated 100 soft QCD events."
    ohai "Use 'brew test -v sacrifice' to view output"
  end
end
