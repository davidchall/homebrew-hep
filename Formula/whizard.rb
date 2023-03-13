class Whizard < Formula
  desc "Monte Carlo event generator"
  homepage "https://whizard.hepforge.org"
  url "https://whizard.hepforge.org/downloads/?f=whizard-3.1.1.tar.gz"
  sha256 "dd48e4e39b8a4990be47775ec6171f89d8147cb2e9e293afc7051a7dbc5a23ef"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://whizard.hepforge.org/downloads/"
    regex(/href=.*?whizard[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://ghcr.io/v2/davidchall/hep"
    sha256 cellar: :any, monterey: "c2f22ca531422a39faf992503164a6c0f74a9186f226b25a44afdeabfddadc08"
    sha256 cellar: :any, big_sur:  "8ff724f3be6e25c56044b37a04974e77bdad9e74b9a42cabfde9485cac03f665"
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
