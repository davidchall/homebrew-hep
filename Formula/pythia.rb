class Pythia < Formula
  desc "Monte Carlo event generator"
  homepage "https://pythia.org"
  url "https://pythia.org/download/pythia83/pythia8309.tgz"
  version "8.309"
  sha256 "5bdafd9f2c4a1c47fd8a4e82fb9f0d8fcfba4de1003b8e14be4e0347436d6c33"
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
    sha256 monterey: "b0312c112a46542939f9f592104b7aa4a10150f1ff8f5866cd0cd73d9a81f834"
    sha256 big_sur:  "ec14f8e1ef57696755433abc66b7b4ad60c9fccf102efbcfd46b3962f5470f7b"
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
