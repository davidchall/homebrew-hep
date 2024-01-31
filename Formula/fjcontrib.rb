class Fjcontrib < Formula
  desc "Package of contributed add-ons to FastJet"
  homepage "https://fastjet.hepforge.org/contrib/"
  url "https://fastjet.hepforge.org/contrib/downloads/fjcontrib-1.053.tar.gz"
  sha256 "b12a248e0b143934c99e3b7c8dd83265122f6c6c09533c2a03df44f5eff1e6fa"

  livecheck do
    url "https://fastjet.hepforge.org/contrib/downloads"
    regex(/href=.*?fjcontrib[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  option "with-test", "Test during installation"

  depends_on "fastjet"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "check" if build.with? "test"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <vector>
      #include "fastjet/PseudoJet.hh"
      #include "fastjet/ClusterSequence.hh"
      #include "fastjet/contrib/SoftDrop.hh"
      int main() {
        std::vector<fastjet::PseudoJet> particles{{1,1,0,2}, {1,-1,0,2}};
        fastjet::ClusterSequence cs(particles, fastjet::JetDefinition(fastjet::antikt_algorithm, 0.4));
        fastjet::contrib::SoftDrop sd(0.5, 0.1);
        for (const fastjet::PseudoJet& j : cs.inclusive_jets()) {
          const fastjet::PseudoJet& jsd = sd(j);
        }
        return 0;
      }
    EOS

    flags = [
      "-I#{Formula["fastjet"].opt_include}",
      "-I#{opt_include}",
      "-L#{Formula["fastjet"].opt_lib}", "-lfastjet", "-lfastjettools",
      "-L#{opt_lib}", "-lRecursiveTools"
    ]

    system ENV.cxx, "-std=c++11", "test.cpp", "-o", "test", *flags
    system "./test"
  end
end
