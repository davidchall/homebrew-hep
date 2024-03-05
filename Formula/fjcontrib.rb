class Fjcontrib < Formula
  desc "Package of contributed add-ons to FastJet"
  homepage "https://fastjet.hepforge.org/contrib/"
  url "https://fastjet.hepforge.org/contrib/downloads/fjcontrib-1.054.tar.gz"
  sha256 "1ef922d4c45863e5fe7a3b64dc441703db6b1c2cc92d4160125dc629b05ac331"

  livecheck do
    url "https://fastjet.hepforge.org/contrib/downloads"
    regex(/href=.*?fjcontrib[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://ghcr.io/v2/davidchall/hep"
    sha256 cellar: :any_skip_relocation, arm64_sonoma: "1c95f6839605967ce0857a1b055bf7aaeaef3a6ee5e6e83674458ca66486d239"
    sha256 cellar: :any_skip_relocation, ventura:      "abf97fa26edccc2c290ecfce344a655ea7cf83cb0324f95f338d23d3eaf4e2b2"
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
