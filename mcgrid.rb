class Mcgrid < Formula
  desc "Projecting cross section calculations on grids"
  homepage "http://mcgrid.hepforge.org"
  url "http://www.hepforge.org/archive/mcgrid/mcgrid-2.0.1.tar.gz"
  sha256 "aeb3fb5a1b5667819bf42e86b51fe9eaff0cf826736638043c634695a657f30f"

  depends_on "rivet"
  depends_on "applgrid" => :recommended
  depends_on "fastnlo" => :recommended
  depends_on "pkg-config" => :build

  resource "examples-rivet220" do
    url "http://www.hepforge.org/archive/mcgrid/MCgrid2Examples-2.2.0.tar.gz"
    sha256 "e2f8aac995876a5f2ec3f9d21aa054cbd7a5e7d3b621d12cb8a2afdd08663a31"
  end

  resource "manual" do
    url "http://www.hepforge.org/archive/mcgrid/manual-2.0.0.pdf"
    sha256 "78ac032c459d26239329fb12560c7d33f6efbdf52d9d3ec606eee24de1f44326"
  end

  def install
    args = %W[
      --disable-dependency-tracking
      --disable-silent-rules
      --prefix=#{prefix}
    ]

    system "./configure", *args
    system "make", "install"

    bin.install("scripts/identifySubprocs.py")

    (prefix/"examples-rivet-2.2.0").install resource("examples-rivet220")
    prefix.install resource("manual")
  end

  def caveats; <<-EOS.undent
    You can disable one of the applgrid and fastnlo dependencies.
    However, the build will fail if you disable both.

    A manual is installed in:
      $(brew --prefix mcgrid)/manual.pdf

    Examples are installed in:
      $(brew --prefix mcgrid)/examples-rivet-2.2.0
    EOS
  end

  test do
    system "pkg-config", "--modversion", "mcgrid"
  end
end
