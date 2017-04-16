require "formula"
class Genie < Formula
  homepage "http://genie.hepforge.org"
  url "http://www.hepforge.org/archive/genie/Genie-2.8.0.tar.gz"
  sha1 "05dc62cd001f380121aa0b206e09a6dd8a493216"

  depends_on "cmake" => :build
  depends_on "homebrew/science/root"
  depends_on "davidchall/hep/pythia8"
  depends_on "davidchall/hep/lhapdf"
  depends_on "log4cpp"
  depends_on "libxml2"

  def install
    ENV['ROOTSYS'] = Formula["root"].prefix
    ENV.deparallelize

    temp_path_for_the_installation = `pwd`.gsub("\n", "")
    ENV['GENIE'] = temp_path_for_the_installation

    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--with-pythia6-lib=#{Formula['pythia8'].lib}"
    system "make", "install"
  end

  test do
    system "test $(find #{include}/GENIE -maxdepth 1 |wc -l) -eq 44"
  end
end
