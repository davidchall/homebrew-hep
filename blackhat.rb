class Blackhat < Formula
  homepage "https://blackhat.hepforge.org/"
  url "http://www.hepforge.org/archive/blackhat/blackhat-0.9.9.tar.gz"
  sha1 "950ba2ccfa2da942e43b2b53e6472cde9614e8a1"

  depends_on "qd"
  depends_on :python => :optional

  patch :p1 do
    url "https://gist.githubusercontent.com/veprbl/b93e5487dfb8a8e6df2a/raw/3846aae47aa044e35c20c918f47a93eee3a9c79c/blackhat_0.9.9_fix.patch"
    sha1 "b22f8a72a7ba44dfe2801f5c57a31ff19cd96091"
  end

  def install
    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --with-QDpath=#{Formula["qd"].prefix}
    ]

    args << "--enable-pythoninterface" if build.with? "python"

    system "./configure", *args
    system "make", "install"

    mv share/"blackhat/assembly", share/"blackhat/datafiles/assembly"
    mv share/"blackhat/parents", share/"blackhat/datafiles/parents"
  end

  test do
    args = `#{bin}/blackhat-config --libs`.split
    system ENV.cxx, share/"blackhat/examples/cpp_example.cpp", "-o", (testpath/"test"), *args
    cp share/"blackhat/examples/contract_file.lh", testpath/"contract_file.lh"
    system (testpath/"test")
  end
end
