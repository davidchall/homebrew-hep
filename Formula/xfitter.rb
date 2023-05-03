class Xfitter < Formula
  desc "Open source QCD fitting tool"
  homepage "https://www.xfitter.org/xFitter/"
  url "https://gitlab.cern.ch/fitters/xfitter/-/archive/2.2.0_Future_Freeze/xfitter-2.2.0_Future_Freeze.tar.gz"
  version "2.2.0"
  sha256 "7063c9eee457e030b97926ac166cdaedd84625b31397e1dfd01ae47371fb9f61"
  license "GPL-3.0-or-later"
  revision 1

  livecheck do
    url "https://gitlab.cern.ch/fitters/xfitter/-/archive/2.2.0_Future_Freeze/"
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

  depends_on "gcc@12" => :build
  depends_on "libyaml" => :build
  depends_on "yaml-cpp" => :build
  depends_on "gsl" => :build
  
  depends_on "hoppet"
  depends_on "apfel++"
  #  depends_on "apfel"
  #  depends_on "dyturbo"
  depends_on "lhapdf"
  depends_on "applgrid"
  depends_on "root"
  depends_on "qcdnum"

  
  fails_with :clang

  def install
    system "./make.sh", "install"
  end

  test do
    system bin/"xfitter"
  end
end
