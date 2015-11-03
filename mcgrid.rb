class Mcgrid < Formula
  homepage 'http://mcgrid.hepforge.org'
  url 'http://www.hepforge.org/archive/mcgrid/mcgrid-1.2.tar.gz'
  sha256 'd3956ca2b516c55c12a9065aa9789efbeab8791e9b6c96abeeb16c87f8925932'

  depends_on 'rivet'
  depends_on 'applgrid'
  depends_on 'pkg-config' => :build

  resource 'examples-rivet200' do
    url 'http://www.hepforge.org/archive/mcgrid/MCgridExamples-2.0.0.tgz'
    sha256 'c0abb1d1f2d816294eb3de4637107daab95d3494a08899a56bc548e6d72cca10'
  end
  resource 'examples-rivet212' do
    url 'http://www.hepforge.org/archive/mcgrid/MCgridExamples-2.1.2.tgz'
    sha256 '90c579aa5a0921a1fdd3260a85d2a92b229f80781718cce10bdaae96adde82ea'
  end
  resource 'examples-rivet220' do
    url 'http://www.hepforge.org/archive/mcgrid/MCgridExamples-2.2.0.tgz'
    sha256 'd772decaed3f7310948d1e6f84e553e80a95358a6bca7d7974d2b877b0f2475a'
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
