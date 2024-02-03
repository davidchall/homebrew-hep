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
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_sonoma: "bc55abc45a2707672a4a9a08f92eaf24f2826b9864c36592084c60d83e1f8bad"
    sha256 cellar: :any_skip_relocation, ventura:      "cb3c59018a65ce4e08da9184645f0ec8ada0a7e22f8e02e2a7850aa82b17219d"
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
