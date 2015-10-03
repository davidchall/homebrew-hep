class Mcgrid < Formula
  homepage 'http://mcgrid.hepforge.org'
  url 'http://www.hepforge.org/archive/mcgrid/mcgrid-1.2.tar.gz'
  sha1 '23b5c4476aa85491eeaf42b67fc4a602ac7db6b5'

  depends_on 'rivet'
  depends_on 'applgrid'
  depends_on 'pkg-config' => :build

  resource 'examples-rivet200' do
    url 'http://www.hepforge.org/archive/mcgrid/MCgridExamples-2.0.0.tgz'
    sha1 '53ecef3a3698e3c1056de64488356bb40418b362'
  end
  resource 'examples-rivet212' do
    url 'http://www.hepforge.org/archive/mcgrid/MCgridExamples-2.1.2.tgz'
    sha1 '3a68ff8d863d596c819f00c5a1053349ba565089'
  end
  resource 'examples-rivet220' do
    url 'http://www.hepforge.org/archive/mcgrid/MCgridExamples-2.2.0.tgz'
    sha1 '89191a252fea9565cf7cd3d582ba7625fb73ab12'
  end

  def install
    args = %W[
      --disable-dependency-tracking
      --disable-silent-rules
      --prefix=#{prefix}
    ]

    system "./configure", *args
    system "make", "install"

    prefix.install("manual")
    bin.install('scripts/identifySubprocs.py')

    resource("examples-rivet200").stage {
      (prefix/"examples-rivet-2.0.0").install Dir['*']
    }
    resource("examples-rivet212").stage {
      (prefix/"examples-rivet-2.1.2").install Dir['*']
    }
    resource("examples-rivet220").stage {
      (prefix/"examples-rivet-2.2.0").install Dir['*']
    }
  end

  test do
    begin
      lhapdf_version = `lhapdf-config --version`
      ohai "Using LHAPDF version " + lhapdf_version
    rescue
      onoe "This test needs lhapdf to be installed. Please run `brew install lhapdf` and try again."
      return false
    end
    rivet_version = `rivet-config --version`
    if (rivet_version <=> '2.1.2') == -1 then
      examples_suffix = '2.0.0'
    elsif (rivet_version <=> '2.2.0') == -1 then
      examples_suffix = '2.1.2'
    else
      examples_suffix = '2.2.0'
    end
    examples_dir = 'examples-rivet-' + examples_suffix

    examples = prefix + examples_dir
    system "make -C #{examples}"

    ENV['RIVET_ANALYSIS_PATH'] = examples
    ENV['RIVET_INFO_PATH'] = examples+'data'
    ENV['RIVET_REF_PATH'] = examples+'data'
    cp "#{examples}/subproc/MCgrid_CDF_2009_S8383952.config", "#{Formula['applgrid'].share}/applgrid"

    system "rivet #{examples}/hepmc/HepMC_CDFZ_NLO_Example.hepmc --ignore-beams -a MCgrid_CDF_2009_S8383952"
    rm "#{Formula['applgrid'].share}/applgrid/MCgrid_CDF_2009_S8383952.config"

    ohai "Successfully ran MCgrid analysis over Drell-Yan events"
  end

  def caveats; <<-EOS.undent
    A manual is installed in:
      $(brew --prefix mcgrid)/manual

    Examples are installed in:
      $(brew --prefix mcgrid)/examples-rivet-2.0.0
      $(brew --prefix mcgrid)/examples-rivet-2.1.2
      $(brew --prefix mcgrid)/examples-rivet-2.2.0
    EOS
  end
end
