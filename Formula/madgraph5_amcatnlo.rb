class Madgraph5Amcatnlo < Formula
  include Language::Python::Shebang

  desc "Automated LO and NLO processes matched to parton showers"
  homepage "https://launchpad.net/mg5amcnlo"
  url "https://launchpad.net/mg5amcnlo/3.0/3.4.x/+download/MG5_aMC_v3.4.1.tar.gz"
  sha256 "d0dc25a84393687017dcd9154e8f0eee0ba3d6a7122b4a61541db24ffbc148c3"
  license "NCSA"
  revision 1

  livecheck do
    url "https://launchpad.net/mg5amcnlo/+download"
    regex(/href=.*?MG5_aMC[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://ghcr.io/v2/davidchall/hep"
    sha256 cellar: :any, monterey: "57fc59f9ae920d7c7b286688ace2812d5926d05d3cba31f82212e73ad6759778"
    sha256 cellar: :any, big_sur:  "bb44cbabfb83583479cb895793adc14ff45fe77aad79e7c2539c8dfe2774c7cc"
    sha256 cellar: :any, catalina: "982151e7e0ed80c587a8c2fdefbf4f168fb0ba6a7d32a82aca5eb97620586474"
  end

  depends_on "fastjet"
  depends_on "gcc" # for gfortran
  depends_on "python@3.10"

  resource "six" do
    url "https://files.pythonhosted.org/packages/71/39/171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85e/six-1.16.0.tar.gz"
    sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
  end

  def python
    "python3.10"
  end

  def install
    resource("six").stage do
      system python, *Language::Python.setup_install_args(prefix, python)
    end

    # fix broken dynamic links
    gfortran_lib = Formula["gcc"].opt_lib/"gcc"/Formula["gcc"].version_suffix
    MachO::Tools.change_install_name("vendor/DiscreteSampler/check",
                                     "/opt/local/lib/libgcc/libgfortran.3.dylib",
                                     "#{gfortran_lib}/libgfortran.dylib")
    MachO::Tools.change_install_name("vendor/DiscreteSampler/check",
                                     "/opt/local/lib/libgcc/libquadmath.0.dylib",
                                     "#{gfortran_lib}/libquadmath.0.dylib")

    prefix.install Dir["*"]

    # Homebrew deletes empty directories, but aMC@NLO needs them
    Dir["**/"].reverse_each { |d| touch prefix/d/".keepthisdir" if Dir.entries(d).sort==%w[. ..] }

    rewrite_shebang detected_python_shebang, bin/"mg5_aMC"
  end

  test do
    (testpath/"test.mg5").write <<~EOS
      generate p p > t t~
      quit
    EOS
    system bin/"mg5_aMC", "-f", "test.mg5"
  end
end
