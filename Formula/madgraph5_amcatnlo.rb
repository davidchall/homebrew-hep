class Madgraph5Amcatnlo < Formula
  include Language::Python::Shebang

  desc "Automated LO and NLO processes matched to parton showers"
  homepage "https://launchpad.net/mg5amcnlo"
  url "https://launchpad.net/mg5amcnlo/3.0/3.4.x/+download/MG5_aMC_v3.4.1.tar.gz"
  sha256 "d0dc25a84393687017dcd9154e8f0eee0ba3d6a7122b4a61541db24ffbc148c3"
  license "NCSA"

  livecheck do
    url "https://launchpad.net/mg5amcnlo/+download"
    regex(/href=.*?MG5_aMC[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://ghcr.io/v2/davidchall/hep"
    sha256 cellar: :any, monterey: "cbe17b73aeb1da2cbe0a2d46d19f44a0c4b05732dad7ecc4a9a5579084463526"
    sha256 cellar: :any, big_sur:  "2a7283a357002afbb8ef2ae5c1dbf8442884baba6c87d652b5c99d4f4182487e"
    sha256 cellar: :any, catalina: "8fa66ec78e978f16b49c7af0a7222586e1057344d162f3631459528b9b0f9959"
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
      system Formula["python@3.9"].opt_bin/"python3.9", *Language::Python.setup_install_args(prefix)
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
