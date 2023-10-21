class Madgraph5Amcatnlo < Formula
  include Language::Python::Shebang

  desc "Automated LO and NLO processes matched to parton showers"
  homepage "https://launchpad.net/mg5amcnlo"
  url "https://launchpad.net/mg5amcnlo/3.0/3.5.x/+download/MG5_aMC_v3.5.1.tar.gz"
  sha256 "e7464caf72f61bbb49a4ab41e7affb763f77e26a4ca23b843120c60a52160f74"
  license "NCSA"

  livecheck do
    url "https://launchpad.net/mg5amcnlo/+download"
    regex(/href=.*?MG5_aMC[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://ghcr.io/v2/davidchall/hep"
    sha256 cellar: :any, monterey: "622cba4ed27785e89f53e5e2e8c55719870b5cf654b75b4f7692cf75c770b385"
    sha256 cellar: :any, big_sur:  "d8ae21e5bfcd4319933bf77142305c04e451d4164f03c4710cdc3f12a92f2e0d"
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
