class Madgraph5Amcatnlo < Formula
  include Language::Python::Shebang

  desc "Automated LO and NLO processes matched to parton showers"
  homepage "https://launchpad.net/mg5amcnlo"
  url "https://launchpad.net/mg5amcnlo/3.0/3.5.x/+download/MG5_aMC_v3.5.5.tar.gz"
  sha256 "3b4262024cefb8a06082faa9a7ba43484b27a3f2b940a06fbe49c640c5b7ebd7"
  license "NCSA"

  livecheck do
    url "https://launchpad.net/mg5amcnlo/+download"
    regex(/href=.*?MG5_aMC[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://ghcr.io/v2/davidchall/hep"
    sha256 cellar: :any, arm64_sonoma: "5aabeb28661c48ca2de77b7532d239620dba8b49022630ccdbba28f073411c75"
    sha256 cellar: :any, ventura:      "ef0a2820f9b1cd7ded646277d0dd6241ad532469aeb4a6bacf7e6375d85325ce"
  end

  depends_on "fastjet"
  depends_on "gcc" # for gfortran
  depends_on "python@3.12"
  depends_on "six"

  def python
    "python3.12"
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
