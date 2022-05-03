class F2c < Formula
  desc "Compiler from Fortran to C"
  homepage "https://www.netlib.org/f2c/"
  url "https://netlib.sandia.gov/f2c/libf2c.zip"
  # brew audit errors on head-only formula (hack: set version to YYYY.MM.DD)
  version "2022.04.25"
  sha256 "ca404070e9ce0a9aaa6a71fc7d5489d014ade952c5d6de7efb88de8e24f2e8e0"

  resource "f2cexecutablesrc" do
    url "https://netlib.sandia.gov/f2c/src.tgz"
    sha256 "d4847456aa91c74e5e61e2097780ca6ac3b20869fae8864bfa8dcc66f6721d35"
  end

  resource "f2cman" do
    url "https://netlib.sandia.gov/f2c/f2c.1t", using: :nounzip
    sha256 "d37a61295b245906a81d262a667f2a4491f5bd9243b07d46a6fb2e1689e8e8e5"
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
