require "formula"

class Mcgrid < Formula
  homepage "http://mcgrid.hepforge.org"
  url "http://www.hepforge.org/archive/mcgrid/mcgrid-1.0.tar.gz"
  sha1 "3a6b314bbe44aef0197c710ecb124f25f7732ebf"

  depends_on "rivet"
  depends_on "applgrid"
  depends_on "boost"

  def install

    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"

    # TODO: Consider to copy the mcgrid example directory into share

  end

  test do
    # TODO: Write test using the examples directory
    system "true"
  end
end
