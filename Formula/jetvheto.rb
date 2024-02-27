require_relative "../lib/download_pdfs"

class Jetvheto < Formula
  desc "NNLL resummation for jet-veto efficiencies and cross sections"
  homepage "https://jetvheto.hepforge.org"
  url "https://jetvheto.hepforge.org/downloads/?f=JetVHeto-3.0.0.tgz"
  sha256 "c3eaefd2ff154df70ed7d1ead053c7419e82ec854f2124a3d58585193866a40f"
  license "GPL-3.0-only"
  revision 1

  livecheck do
    url "https://jetvheto.hepforge.org/downloads/"
    regex(/href=.*?JetVHeto[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://ghcr.io/v2/davidchall/hep"
    rebuild 1
    sha256 cellar: :any, arm64_sonoma: "515cb4ec325276691eb776e57dc53c018ab8f846f34a6fc55e0e16d5e334669b"
    sha256 cellar: :any, ventura:      "253b6ce4a3bc3f698c9f6a0ed55c3fde6c133d46b470c17b897982317a6cd9e7"
  end

  depends_on "chaplin"
  depends_on "gcc" # for gfortran
  depends_on "hoppet"
  depends_on "lhapdf"

  def install
    inreplace "Makefile", /^CHAPLIN=.+/, "CHAPLIN=#{Formula["chaplin"].opt_lib}"
    system "make"
    bin.install "jetvheto"
    share.install Dir["*fixed-order*"]
    share.install Dir["*benchmarks*"]
    share.install "python"
    share.install "scripts"
  end

  test do
    download_pdfs(testpath/"pdf-sets", "MSTW2008nnlo68cl")

    cp share/"fixed-order/H125-LHC8-R04-xmur050-xmuf050-log.fxd", "input.fxd"
    inreplace "input.fxd", "MSTW2008nnlo90cl.LHgrid", "MSTW2008nnlo68cl"

    system bin/"jetvheto", "-in", "input.fxd", "-out", "output.res", "-xQ", "0.05"
    assert_predicate testpath/"output.res", :exist?
  end
end
