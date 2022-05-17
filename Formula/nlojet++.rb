class Nlojetxx < Formula
  desc "LO and NLO cross sections"
  homepage "https://www.desy.de/~znagy/Site/NLOJet++.html"
  url "https://desy.de/~znagy/hep-programs/nlojet++/nlojet++-4.1.3.tar.gz"
  sha256 "176d081bbc8c167cdd4516959cbcb2b9ba8f5515f503d29380deee2f67b10ea3"

  livecheck do
    url :homepage
    regex(/href=.*?nlojet\+\+[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  patch :p1 do
    url "https://gist.githubusercontent.com/veprbl/e404103016ba819d580b/raw/917c57e8cb47b025b8eef1cf6d74174540fb3ccd/nlojet_clang_fix.patch"
    sha256 "4f7b10953b95b8568f10e7db674628f22e7198b158ed158e870a428b9f0b02d1"
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system bin/"nlojet++"
  end
end
