class Qcdnum < Formula
  desc "Fast PDF evolution"
  homepage "https://www.nikhef.nl/~h24/qcdnum"
  url "https://www.nikhef.nl/~h24/qcdnum-files/download/qcdnum180000.tar.gz"
  version "18.0.0"
  sha256 "e108f926b7840352e4080ba71914d3403ed8118364f87710e221fdec320ee200"
  license "GPL-3.0-or-later"
  revision 2

  livecheck do
    url "https://www.nikhef.nl/~h24/qcdnum-files/download/"
    regex(/href=.*?qcdnum(\d{2})(\d{2})(\d{2})\.t/i)
    strategy :page_match do |page, regex|
      page.scan(regex).map { |match| match.map(&:to_i).join(".") }
    end
  end

  bottle do
    root_url "https://ghcr.io/v2/davidchall/hep"
    sha256 cellar: :any_skip_relocation, monterey: "35f97997a4f9f483982492b0c49e5e8657ae994717e77d64d0f45701928ef9e4"
    sha256 cellar: :any_skip_relocation, big_sur:  "9864423c3357cdf236d155afcee6e084925030b7068a6ff1d59a36cd4ce9a0b5"
    sha256 cellar: :any_skip_relocation, catalina: "0cb506a3aa025208d41b683708dcbbac477a2e5d975d0edb95cc74f6afc3f565"
  end

  depends_on "gcc" # for gfortran

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"

    prefix.install "testjobs"
  end

  test do
    flags = shell_output(bin/"qcdnum-config --cppflags --ldflags").split
    system "gfortran", prefix/"testjobs/example.f", "-o", "example", *flags
    system "./example"
  end
end
