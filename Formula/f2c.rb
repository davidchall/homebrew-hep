class F2c < Formula
  desc "Compiler from Fortran to C"
  homepage "https://www.netlib.org/f2c/"
  url "https://netlib.sandia.gov/f2c/libf2c.zip"
  # brew audit errors on head-only formula (hack: set version to YYYY.MM.DD)
  version "2024.02.22"
  sha256 "cc84253b47b5c036aa1d529332a6c218a39ff71c76974296262b03776f822695"

  livecheck do
    skip "No version information available"
  end

  bottle do
    root_url "https://ghcr.io/v2/davidchall/hep"
    sha256 cellar: :any_skip_relocation, arm64_sonoma: "4ce3b9b1aa3c16b06fb5bea8b07b0e13e14a3f5b5db08c5e3784b3583891a06d"
    sha256 cellar: :any_skip_relocation, ventura:      "852176593dad5149ca38e0d0219df3fae1a0ec0f19da9bceb5fcd409b5a4b7ed"
  end

  resource "f2cexecutablesrc" do
    url "https://netlib.sandia.gov/f2c/src.tgz"
    sha256 "61c891d426edb05bc647d6f7fc345c2e7f4dce55d092c54a8fc5e1af483a3235"
  end

  resource "f2cman" do
    url "https://netlib.sandia.gov/f2c/f2c.1t", using: :nounzip
    sha256 "af6559cbfcb194a70f13535464ab62d948541cfb48a258e13145b99622eea6b7"
  end

  def install
    system "make", "-f", "makefile.u", "f2c.h"
    include.install "f2c.h"

    system "make", "-f", "makefile.u"
    lib.install "libf2c.a"

    resource("f2cexecutablesrc").stage do
      system "make", "-f", "makefile.u", "f2c"
      bin.install "f2c"
    end

    resource("f2cman").stage do
      man1.install "f2c.1t"
    end
  end

  test do
    (testpath/"test.f").write <<~EOS
      C comment line
            program hello
            print*, 'hello world'
            stop
            end
    EOS
    system bin/"f2c", "test.f"
    assert_predicate testpath/"test.c", :exist?
    system ENV.cc, "-O", "-o", "test", "test.c", "-L", lib, "-lf2c"
    assert_equal "hello world", shell_output(testpath/"test").strip
  end
end
