class Madgraph5Amcatnlo < Formula
  desc "Automated LO and NLO processes matched to parton showers"
  homepage "https://launchpad.net/mg5amcnlo"
  url "https://launchpad.net/mg5amcnlo/2.0/2.5.x/+download/MG5_aMC_v2.5.2.tar.gz"
  sha256 "7968f6d0543b3af2649ba497d17c3a23b089cc6f5ba352e0fd7fa106aa07a512"

  depends_on "fastjet"
  depends_on :fortran
  depends_on :python

  def install
    cp_r ".", prefix

    # Homebrew deletes empty directories, but aMC@NLO needs them
    empty_dirs = %w[
      Template/LO/Events
      Template/NLO/Events
      Template/NLO/MCatNLO/lib
      Template/NLO/MCatNLO/objects
      doc
      models/usrmod_v4
      vendor/StdHEP/bin
      vendor/StdHEP/lib
    ]
    empty_dirs.each { |f| touch prefix/f/".empty" }
  end

  def caveats; <<-EOS.undent
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
    system "mg5_aMC", "-f", "test.mg5"
  end
end
