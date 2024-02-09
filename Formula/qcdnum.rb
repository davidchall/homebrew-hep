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
    rebuild 1
    sha256 cellar: :any, arm64_sonoma: "bc0c123edde760c89bc00eb0af23bb66427ae9598337779bacf697b7541ffdc0"
    sha256 cellar: :any, ventura:      "ba9dd4621163943b82d91a5499a651a905f302f3127e120c49ab430fb24115ea"
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
