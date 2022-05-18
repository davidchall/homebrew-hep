class Chaplin < Formula
  desc "Complex Harmonic Polylogarithms in Fortran"
  homepage "https://chaplin.hepforge.org"
  url "https://chaplin.hepforge.org/code/chaplin-1.2.tar"
  sha256 "f17c2d985fd4e4ce36cede945450416d3fa940af68945c91fa5d3ca1d76d4b49"

  livecheck do
    url "https://chaplin.hepforge.org/downloads"
    regex(/href=.*?chaplin[._-]v?(\d+(?:\.\d+)+)\.t/i)
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
