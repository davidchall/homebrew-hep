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
    sha256 cellar: :any, ventura:  "98a14d74829c9789ed804b0badbd8c448c08b4c922fd5be0e031c330b8f6cd35"
    sha256 cellar: :any, monterey: "dc94d67bed0c86bc965fa2447cb2a98734a35b14d47c0b3e22676fe16a28e865"
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
