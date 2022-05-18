class Applgrid < Formula
  desc "Quickly reproduce NLO calculations with any input PDFs"
  homepage "https://applgrid.hepforge.org"
  url "https://applgrid.hepforge.org/downloads?f=applgrid-1.6.27.tgz"
  sha256 "87e64d1a3df7148c20e1f382c9f189ad428cdaf0c3425efa25c2e1b5ba003ad7"
  license "GPL-3.0-only"

  livecheck do
    url "https://applgrid.hepforge.org/downloads"
    regex(/href=.*?applgrid[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://ghcr.io/v2/davidchall/hep"
    sha256 cellar: :any, monterey: "19c2fe49f23f6a9f24440e272cfc7e490e83eda4bf1a0fd89d57605a8ce30548"
    sha256 cellar: :any, big_sur:  "971209fb409b6577c974b0909de087e662e1fb6f8f5bb6b89d76ce1a24d596ca"
    sha256 cellar: :any, catalina: "59c4590544e40fe820c342954220e27330fafcb910bf0de399b08fd1be2e5c0e"
  end

  depends_on "gcc" # for gfortran
  depends_on "hoppet" => :recommended
  depends_on "lhapdf" => :recommended
  depends_on "root"   => :recommended

  def install
    args = %W[
      --disable-dependency-tracking
      --disable-silent-rules
      --prefix=#{prefix}
    ]

    args << "--without-root" if build.without? "root"

    system "./configure", *args
    system "make"
    system "make", "install"
  end

  test do
    system bin/"applgrid-config", "--version"
  end
end
