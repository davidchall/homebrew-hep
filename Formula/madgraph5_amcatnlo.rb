class Madgraph5Amcatnlo < Formula
  include Language::Python::Shebang

  desc "Automated LO and NLO processes matched to parton showers"
  homepage "https://launchpad.net/mg5amcnlo"
  url "https://launchpad.net/mg5amcnlo/3.0/3.5.x/+download/MG5_aMC_v3.5.2.tar.gz"
  sha256 "0a252e49ecc2b30e350bd33c24b1fd61cf7d3efc1c4b52c602aa4d23c27bf4e5"
  license "NCSA"

  livecheck do
    url "https://launchpad.net/mg5amcnlo/+download"
    regex(/href=.*?MG5_aMC[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://ghcr.io/v2/davidchall/hep"
    sha256 cellar: :any, ventura:  "c15979d34be4206f8d703d4894ed6685721c9418d02ba4045e7ae9bf1709cb78"
    sha256 cellar: :any, monterey: "2201add8a6d81b5dabf9cca3af7f0a111f940fabd78a76325a19b01f5e628f22"
  end

  depends_on "fastjet"
  depends_on "gcc" # for gfortran
  depends_on "python@3.10"
  depends_on "six"

  def python
    "python3.10"
  end

  def install
    # hardcoded paths cause problems on GCC minor version bumps
    gcc = Formula["gcc"]
    gfortran_lib = gcc.opt_lib/"gcc"/gcc.any_installed_version.major
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
