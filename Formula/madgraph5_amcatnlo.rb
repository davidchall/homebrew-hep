class Madgraph5Amcatnlo < Formula
  include Language::Python::Shebang

  desc "Automated LO and NLO processes matched to parton showers"
  homepage "https://launchpad.net/mg5amcnlo"
  url "https://launchpad.net/mg5amcnlo/3.0/3.4.x/+download/MG5_aMC_v3.4.2.tar.gz"
  sha256 "ca8631e10cc384f9d05a4d3311f6cb101eeaa57cb39ab7325ee5d1aec1fe218f"
  license "NCSA"
  revision 2

  livecheck do
    url "https://launchpad.net/mg5amcnlo/+download"
    regex(/href=.*?MG5_aMC[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://ghcr.io/v2/davidchall/hep"
    sha256 cellar: :any, monterey: "4cd5fd9ffd46b22e7f9a17bc171bbc4ab9dfe3f42bfead1821d7ed796d0821e7"
    sha256 cellar: :any, big_sur:  "b38fedb47b503f927efd283fbaf81ca581f8fadab7615a04c31bb6afd9c0f4ff"
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
