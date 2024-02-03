class Whizard < Formula
  desc "Monte Carlo event generator"
  homepage "https://whizard.hepforge.org"
  url "https://whizard.hepforge.org/downloads/?f=whizard-3.1.4.tar.gz"
  sha256 "9da9805251d786adaf4ad5a112f9c4ee61d515778af0d2623d6460c3f1f900cd"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://whizard.hepforge.org/downloads/"
    regex(/href=.*?whizard[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://ghcr.io/v2/davidchall/hep"
    rebuild 1
    sha256               arm64_sonoma: "5bab4235dbda2e56c3774d2514078d614adbac87b2fd60e5c6ab8536b0da6d80"
    sha256 cellar: :any, ventura:      "5a62ac85ac5848da3da28f36133eada1be478daa34ddf8c781a8bc110363df08"
  end

  depends_on "gcc" # for gfortran
  depends_on "ocaml"
  depends_on "fastjet" => :optional
  depends_on "hepmc3" => :optional
  depends_on "hoppet" => :optional
  depends_on "lhapdf" => :optional

  # post-install cleaner overwrites script permissions, causing audit failure
  patch :DATA

  def install
    args = %W[
      --disable-dependency-tracking
      --enable-fc-openmp
      --prefix=#{prefix}
    ]

    args << "--enable-hoppet" if build.with? "hoppet"
    args << "--enable-fastjet" if build.with? "fastjet"

    # F90 truncates lines longer than 132 characters
    # but src/system/system_dependencies.f90 contains long path strings
    args << "FCFLAGS=-ffree-line-length-512"

    system "./configure", *args
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"ee.sin").write <<~EOS
      process ee = e1, E1 => e2, E2
      sqrts = 360 GeV
      n_events = 10
      sample_format = lhef
      simulate (ee)
    EOS

    system bin/"whizard", "-r", testpath, "ee.sin"
  end
end

__END__
diff --git a/scripts/whizard-setup.csh.in b/scripts/whizard-setup.csh.in
index abab707..898a9e2 100644
--- a/scripts/whizard-setup.csh.in
+++ b/scripts/whizard-setup.csh.in
@@ -1,3 +1,4 @@
+#!/usr/bin/env csh
 # source this file to set up environment variables for an
 # installed WHIZARD in csh(-compatible) shells
 #
diff --git a/scripts/whizard-setup.sh.in b/scripts/whizard-setup.sh.in
index aec3d25..155216f 100644
--- a/scripts/whizard-setup.sh.in
+++ b/scripts/whizard-setup.sh.in
@@ -1,3 +1,4 @@
+#!/usr/bin/env sh
 # source this file to set up environment variables for an
 # installed WHIZARD in Bourne(-compatible) shells
 #
