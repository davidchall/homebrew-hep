class Fjcontrib < Formula
  desc "Package of contributed add-ons to FastJet"
  homepage "https://fastjet.hepforge.org/contrib/"
  url "https://fastjet.hepforge.org/contrib/downloads/fjcontrib-1.055.tar.gz"
  sha256 "d9aa46560fdfd85082f202a5a9ce64768fe0c598660f013206a8c9c17ecd0f36"

  livecheck do
    url "https://fastjet.hepforge.org/contrib/downloads"
    regex(/href=.*?fjcontrib[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://ghcr.io/v2/davidchall/hep"
    sha256 cellar: :any_skip_relocation, arm64_sonoma: "5ff87291acc5892c361dd0c1ee7c398b4648aa44a0d701ca3646f3525f9344cc"
    sha256 cellar: :any_skip_relocation, ventura:      "e41496c7ea51888c23b86d69a14e0ff3b611a00ff3d4eed63fa7f636086930ee"
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
