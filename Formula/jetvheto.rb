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
    sha256 cellar: :any, monterey: "81153b6f3b612d32957845a7ce02c66b8a6d15d000c9a4cf966815cc271b0278"
    sha256 cellar: :any, big_sur:  "4e54ecc432ccc7e8ab68b4b53ca00067bb31ffb206bb77754d793750b63f4e52"
    sha256 cellar: :any, catalina: "58a768e3b9fe3077a8a56c4c15902d999415c11ed8f6cf2da21b428955d6f437"
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
