class Topdrawer < Formula
  desc "SLAC interface for generating physics graphs"
  homepage "https://www.pa.msu.edu/reference/topdrawer-docs"
  url "http://ftp.riken.jp/pub/iris/topdrawer/topdrawer.tar.gz"
  version "1.4e"
  sha256 "2a44dffd19e243aa261b4e3cd2b0fe6247ced97ee10e3271f8c7eeae8cb62401"

  livecheck do
    skip "No version information available"
  end

  bottle do
    root_url "https://ghcr.io/v2/davidchall/hep"
    rebuild 1
    sha256 cellar: :any, monterey: "8ff3c466a0ea835513df8a3e605866df1030810d8da57a8f0ef34fe749ed8884"
    sha256 cellar: :any, big_sur:  "24d08994cc11d9332262433764a26964a1d7e3f5423907c40c5cfe04b0a24235"
    sha256 cellar: :any, catalina: "0c05c5cb30e729e35b9ac16b0fe8e9f9cc7ffbf980681ec48fed4d928c10d588"
  end

  depends_on "f2c" => :build
  depends_on "imake" => :build
  depends_on "ugs" => :build
  depends_on "gcc"
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
    system bin/"td", share/"examples/muon.top", "-d", "postscr"

    # ouput filename is garbled due to some bug
    output_file = testpath.children.max_by { |f| File.mtime(f) }
    ps_file = testpath/"test.ps"
    mv output_file, ps_file

    file_type = shell_output("file -b #{ps_file}")
    assert_equal "PostScript", file_type.split.first
  end
end
