require 'formula'

class Madgraph5Amcatnlo < Formula
  homepage 'https://launchpad.net/mg5amcnlo'
  url 'https://launchpad.net/mg5amcnlo/2.0/2.1.0/+download/MG5_aMC_v2.1.2.tar.gz'
  sha1 '949af52852bb615e7515db555c7043ab987964f3'

  depends_on 'fastjet'
  depends_on :fortran
  depends_on :python

  option 'use-stdcxx', 'Link to libstdc++ when compiling matrix elements'

  def install
    # MadGraph5_aMC@NLO hardcodes linking to libstdc++
    filelist = %w[
      Template/LO/Source/make_opts
      Template/NLO/MCatNLO/README.shower
      Template/NLO/MCatNLO/Scripts/MCatNLO_MadFKS_HERWIG6.Script
      Template/NLO/MCatNLO/Scripts/MCatNLO_MadFKS_PYTHIA6PT.Script
      Template/NLO/MCatNLO/Scripts/MCatNLO_MadFKS_PYTHIA6Q.Script
      Template/NLO/Source/make_opts
      Template/NLO/SubProcesses/makefile_fks_dir
      madgraph/interface/amcatnlo_run_interface.py
      madgraph/iolibs/export_v4.py
    ]
    inreplace filelist, 'stdc++', 'c++' unless build.include? 'use-stdcxx'

    cp_r '.', prefix

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
    empty_dirs.each {|f| touch prefix/f/'.empty'}
  end

  test do
    system 'echo \'generate p p > t t~\' >> test.mg5'
    system 'echo \'quit\' >> test.mg5'
    system 'mg5_aMC -f test.mg5'
  end

  def caveats; <<-EOS.undent
    To shower aMC@NLO events with herwig++ or pythia8, first install
    them via homebrew and then enter in the mg5_aMC interpreter:

      set hepmc_path #{HOMEBREW_PREFIX}
      set thepeg_path #{HOMEBREW_PREFIX}
      set hwpp_path #{HOMEBREW_PREFIX}
      set pythia8_path #{HOMEBREW_PREFIX}


    If dependencies, such as fastjet, were built with libstdc++
    (e.g. using gcc or OS X <=10.8) then try the '--use-stdcxx' option

    EOS
  end
end
