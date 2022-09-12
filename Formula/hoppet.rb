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
    sha256 cellar: :any_skip_relocation, monterey: "edcc774e58323d48b7bd32249149aa004fdf1b5f6d35eaf7063ebfe1be55ca0e"
    sha256 cellar: :any_skip_relocation, big_sur:  "ad51ad289809efbeeafbda083929c16a8fda7b3d61adda228220a6527eceed9c"
    sha256 cellar: :any_skip_relocation, catalina: "24a394a8a4e59c662d76267c4b8254314cb2fc5e64705154dad1ea1e8bf4ec29"
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
