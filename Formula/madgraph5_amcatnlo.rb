class Madgraph5Amcatnlo < Formula
  include Language::Python::Shebang

  desc "Automated LO and NLO processes matched to parton showers"
  homepage "https://launchpad.net/mg5amcnlo"
  url "https://launchpad.net/mg5amcnlo/3.0/3.4.x/+download/MG5_aMC_v3.4.0.tar.gz"
  sha256 "6853c311c3641e6f2d1fc99695bb72d4dcf159f9b944f8e7322e085257406611"
  license "NCSA"

  livecheck do
    url "https://launchpad.net/mg5amcnlo/+download"
    regex(/href=.*?MG5_aMC[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://ghcr.io/v2/davidchall/hep"
    sha256 cellar: :any, monterey: "0ad3787c88eb99aea48486603661f5bc0dfe90edb5f68f22000496cf7174a8b4"
    sha256 cellar: :any, big_sur:  "37de87edae1f740c90f8a88eced928c1ae40140114da351656d737fd1ce9ca46"
    sha256 cellar: :any, catalina: "94bb5dd4c52373b6b1638efc42c9f2bd0b77ac58f8b0bae53b0485e124f1b424"
  end

  depends_on "fastjet"
  depends_on "gcc" # for gfortran
  depends_on "python@3.9"

  resource "six" do
    url "https://files.pythonhosted.org/packages/71/39/171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85e/six-1.16.0.tar.gz"
    sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
  end

  def install
    resource("six").stage do
      system Formula["python@3.9"].opt_bin/"python3", *Language::Python.setup_install_args(prefix)
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
