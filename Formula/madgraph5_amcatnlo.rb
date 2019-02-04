class Madgraph5Amcatnlo < Formula
  desc "Automated LO and NLO processes matched to parton showers"
  homepage "https://launchpad.net/mg5amcnlo"
  url "https://launchpad.net/mg5amcnlo/2.0/2.6.x/+download/MG5_aMC_v2.6.4.tar.gz"
  sha256 "ec7f13018433888319536adba436012fca4a2ccb715b2f525c7efa5e870e7605"

  bottle :unneeded

  depends_on "fastjet"
  depends_on "gcc" # for gfortran

  def install
    # fix broken dynamic links
    MachO::Tools.change_install_name("vendor/DiscreteSampler/check",
                                     "/opt/local/lib/libgcc/libgfortran.3.dylib",
                                     "#{Formula["gcc"].lib}/gcc/#{Formula["gcc"].version_suffix}/libgfortran.dylib")
    MachO::Tools.change_install_name("vendor/DiscreteSampler/check",
                                     "/opt/local/lib/libgcc/libquadmath.0.dylib",
                                     "#{Formula["gcc"].lib}/gcc/#{Formula["gcc"].version_suffix}/libquadmath.0.dylib")

    cp_r ".", prefix

    # Homebrew deletes empty directories, but aMC@NLO needs them
    Dir["**/"].reverse_each { |d| touch prefix/d/".keepthisdir" if Dir.entries(d).sort==%w[. ..] }
  end

  def caveats; <<~EOS
    To shower aMC@NLO events with herwig++ or pythia8, first install
    them via homebrew and then enter in the mg5_aMC interpreter:

      set hepmc_path #{HOMEBREW_PREFIX}
      set thepeg_path #{HOMEBREW_PREFIX}
      set hwpp_path #{HOMEBREW_PREFIX}
      set pythia8_path #{HOMEBREW_PREFIX}

  EOS
  end

  test do
    system "echo \'generate p p > t t~\' >> test.mg5"
    system "echo \'quit\' >> test.mg5"
    system "#{bin}/mg5_aMC", "-f", "test.mg5"
  end
end
