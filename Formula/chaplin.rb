class Chaplin < Formula
  desc "Complex Harmonic Polylogarithms in Fortran"
  homepage "https://chaplin.hepforge.org"
  url "https://chaplin.hepforge.org/code/chaplin-1.2.tar"
  sha256 "f17c2d985fd4e4ce36cede945450416d3fa940af68945c91fa5d3ca1d76d4b49"
  revision 1

  livecheck do
    url "https://chaplin.hepforge.org/downloads"
    regex(/href=.*?chaplin[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://ghcr.io/v2/davidchall/hep"
    sha256 cellar: :any, monterey: "6f4be0bee5810c52fbaaa5107932f8a0473fd00ffa51f671fda55b720c33fce1"
    sha256 cellar: :any, big_sur:  "3603c69604755c2e2a40f548af1b7b94a5f8838b4d5285a24d8cde8405796156"
    sha256 cellar: :any, catalina: "355b4dd464b705a29ec4054545299d08a07d2e3e4e8b825195caa15baa8e4963"
  end

  depends_on "gcc" # for gfortran

  def install
    args = %W[
      --disable-dependency-tracking
      --disable-static
      --prefix=#{prefix}
    ]
    system "./configure", *args
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.f").write <<~EOS
      C comment line
            program chaplintest

            double complex HPL2,z
            integer n1,n2

            z = dcmplx(1.54d0,0.91d0)
            do n1=-1,1
              do n2=-1,1
                print*, HPL2(n1,n2,z)
              enddo
            enddo

            end program
    EOS

    system "gfortran", "test.f", "-o", "test", "-L", lib, "-lchaplin"
    system "./test"
  end
end
