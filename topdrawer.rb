class Topdrawer < Formula
  desc "SLAC interface for generating physics graphs"
  homepage "http://www.pa.msu.edu/reference/topdrawer-docs"
  url "http://ftp.riken.jp/pub/iris/topdrawer/topdrawer.tar.gz"
  version "1.4e"
  sha256 "2a44dffd19e243aa261b4e3cd2b0fe6247ced97ee10e3271f8c7eeae8cb62401"

  depends_on "homebrew/head-only/f2c" => :build
  depends_on "gcc" => :build
  depends_on "homebrew/x11/imake" => :build
  depends_on "ugs" => :build
  depends_on :x11

  patch :p1 do
    url "https://gist.githubusercontent.com/veprbl/80ced2fcd27dddf48d8e/raw/a5d474f7735221424ebcaa0ff03b6c36135b2d5a/topdrawer_OSX_fix.patch"
    sha256 "e8218390cd185b7a2e0fcdab120ffec3c518ab448154fcc73e928c7e0052080d"
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
