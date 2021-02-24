class Topdrawer < Formula
  desc "SLAC interface for generating physics graphs"
  homepage "https://www.pa.msu.edu/reference/topdrawer-docs"
  url "http://ftp.riken.jp/pub/iris/topdrawer/topdrawer.tar.gz"
  version "1.4e"
  sha256 "2a44dffd19e243aa261b4e3cd2b0fe6247ced97ee10e3271f8c7eeae8cb62401"

  depends_on "f2c" => :build
  depends_on "gcc" => :build
  depends_on "imake" => :build
  depends_on "ugs" => :build
  depends_on "libice"
  depends_on "libsm"
  depends_on "libx11"
  depends_on "libxext"
  depends_on "libxt"

  patch :p1 do
    url "https://gist.githubusercontent.com/andriish/9e7da86a48fb8930d19eaadfe982a785/raw/5e5a888cc670b5f52378cc7a6c09f6be7cf377f6/patch-topdrawer-1.txt"
    sha256 "ff0ecaf06cb27daef99edaec786897c8cc53ef01e45388b4b9c0adfe6859f4a0"
  end

  env :std

  def install
    ENV.deparallelize

    inreplace "Imakefile.def", /^UGS = .+/, "UGS = #{Formula["ugs"].opt_lib/"ugs.a"}"

    system "xmkmf", "-a"
    system "make", "clean"
    system "make", "all"

    bin.install "td"
    share.install "examples"
    share.install "doc"
  end

  test do
    cd testpath do
      system bin/"td", share/"examples/muon.top", "-d", "postscr"
    end
    # ouput filename is garbled due to some bug
    ps_file = Dir[testpath/"*"].first
    type = `file -b #{ps_file}`
    assert_equal type.split.first, "PostScript"
  end
end
