class Pythia < Formula
  desc "Monte Carlo event generator"
  homepage "https://pythia.org"
  url "https://pythia.org/download/pythia83/pythia8310.tgz"
  version "8.310"
  sha256 "90c811abe7a3d2ffdbf9b4aeab51cf6e0a5a8befb4e3efa806f3d5b9c311e227"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://pythia.org/releases"
    regex(/href=.*?pythia(\d)(\d{3})\.t/i)
    strategy :page_match do |page, regex|
      page.scan(regex).map { |match| match.join(".") }
    end
  end

  bottle do
    root_url "https://ghcr.io/v2/davidchall/hep"
    sha256 ventura:  "338c97cf415d5b1036bdf3ba33a83bd42a603700daf21daaccd2cd2da2f303b0"
    sha256 monterey: "0e821928f0911e5d9ad149a054802eeedf2088923c1f75ef55c7c1a2abe2af6d"
  end

  depends_on "boost"
  depends_on "hepmc3"
  depends_on "lhapdf"

  def install
    args = %W[
      --prefix=#{prefix}
      --with-hepmc3=#{Formula["hepmc3"].opt_prefix}
      --with-lhapdf6=#{Formula["lhapdf"].opt_prefix}
      --with-boost=#{Formula["boost"].opt_prefix}
    ]

    system "./configure", *args
    system "make"
    system "make", "install"
  end

  test do
    cp_r share/"Pythia8/examples/.", testpath
    system "make", "main01"
    system "./main01"
  end
end
