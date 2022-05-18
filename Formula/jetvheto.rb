require_relative "../lib/download_pdfs"

class Jetvheto < Formula
  desc "NNLL resummation for jet-veto efficiencies and cross sections"
  homepage "https://jetvheto.hepforge.org"
  url "https://jetvheto.hepforge.org/downloads/?f=JetVHeto-3.0.0.tgz"
  sha256 "c3eaefd2ff154df70ed7d1ead053c7419e82ec854f2124a3d58585193866a40f"
  license "GPL-3.0-only"

  livecheck do
    url "https://jetvheto.hepforge.org/downloads/"
    regex(/href=.*?JetVHeto[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://ghcr.io/v2/davidchall/hep"
    sha256 cellar: :any, monterey: "b9868bd1d37ef1de91e60dfa7551dfe21cd0a5f7a4ab51ae313d53923ec72c88"
    sha256 cellar: :any, big_sur:  "8312a2c9bc2b2446814f32917a4042a10369b5d10611f36c7a2900035c96f1e9"
    sha256 cellar: :any, catalina: "bd971bcf7b4a6d47d01333fdc6ba5c7af97dd5198aee797f594a889fbf9d08aa"
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
