class F2c < Formula
  desc "Compiler from Fortran to C"
  homepage "http://www.netlib.org/f2c/"
  sha256 "ca404070e9ce0a9aaa6a71fc7d5489d014ade952c5d6de7efb88de8e24f2e8e0"
  head "https://netlib.sandia.gov/f2c/libf2c.zip", using: :nounzip

  resource "f2cexecutablesrc" do
    url "https://netlib.sandia.gov/f2c/src.tgz", using: :nounzip
    sha256 "d4847456aa91c74e5e61e2097780ca6ac3b20869fae8864bfa8dcc66f6721d35"
  end

  resource "f2cman" do
    url "https://netlib.sandia.gov/f2c/f2c.1t", using: :nounzip
  end

  def install
    system "unzip", "libf2c.zip", "-d", "libf2c"
    # f2c header and libf2c.a
    cd "libf2c" do
      system "make", "-f", "makefile.u", "f2c.h"
      include.install "f2c.h"

      system "make", "-f", "makefile.u"
      lib.install "libf2c.a"
    end

    # f2cexecutable
    resource("f2cexecutablesrc").stage do
      system "tar", "zxvf", "src.tgz"
      cd "src" do
        system "make", "-f", "makefile.u", "f2c"
        bin.install "f2c"
      end
    end

    # f2cman
    resource("f2cman").stage do
      man1.install "f2c.1t"
    end
  end

  test do
    # check if executable doesn't error out
    system "#{bin}/f2c", "--version"

    # hello world test
    (testpath/"test.f").write <<-EOS.undent
      C comment line
            program hello
            print*, 'hello world'
            stop
            end
    EOS
    system "#{bin}/f2c", "test.f"
    assert_predicate testpath/"test.c", :exist?
    system "cc", "-O", "-o", "test", "test.c", "-lf2c"
    assert_equal " hello world\n", shell_output("#{testpath}/test")
  end
end
