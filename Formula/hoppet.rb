class Hoppet < Formula
  desc "QCD DGLAP evolution"
  homepage "https://hoppet.hepforge.org"
  url "https://hoppet.hepforge.org/downloads/hoppet-1.2.0.tgz"
  sha256 "bffd1bbfd3cc8d1470ded5c82fe33346d44e86cf426439eb77ab7702f319e448"
  revision 1

  livecheck do
    url "https://hoppet.hepforge.org/downloads"
    regex(/href=.*?hoppet[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://ghcr.io/v2/davidchall/hep"
    rebuild 1
    sha256 cellar: :any_skip_relocation, ventura:  "f805c56b39710f53ef2457f60c207f7eafcd8e063b50bdb1439ec96f2518a030"
    sha256 cellar: :any_skip_relocation, monterey: "d499f3cd567170274898cdefdcad96ebe88ba54ec4b500cc5a0652452f4b8cd3"
  end

  option "with-test", "Test during installation"

  depends_on "gcc" # for gfortran

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "check" if build.with? "test"
    system "make", "install"
  end

  test do
    system bin/"hoppet-config", "--libs"
  end
end
