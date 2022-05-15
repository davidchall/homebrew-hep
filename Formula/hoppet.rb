class Hoppet < Formula
  desc "QCD DGLAP evolution"
  homepage "https://hoppet.hepforge.org"
  url "https://hoppet.hepforge.org/downloads/hoppet-1.2.0.tgz"
  sha256 "bffd1bbfd3cc8d1470ded5c82fe33346d44e86cf426439eb77ab7702f319e448"

  livecheck do
    url "https://hoppet.hepforge.org/downloads"
    regex(/href=.*?hoppet[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://ghcr.io/v2/davidchall/hep"
    rebuild 1
    sha256 cellar: :any_skip_relocation, monterey: "e8687b0c1afff6831e8a4ec26f071aa676d70b795b697cf09ec6616fa6761e16"
    sha256 cellar: :any_skip_relocation, big_sur:  "4672285059183790b9ea035f832c33824cec851ade64a905c0f6f4117fbc6adb"
    sha256 cellar: :any_skip_relocation, catalina: "1b15536020d406d54892dead96e4eb99f6efae7fb08fd069e7fb6258859d0b8e"
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
