class Partons < Formula
  desc "PARtonic Tomography Of Nucleon Software"
  homepage "http://partons.cea.fr/partons/doc/html/index.html"
  url "https://drf-gitlab.cea.fr/partons/core/partons/repository/v2.0/archive.tar.gz"
  sha256 "75afa187f575f77b3ec63d6e5565c1ccdc7843988f24a8c8b5fdeeb1b4420c82"

  depends_on "cmake" => :build
  depends_on "cln"
  depends_on "elementary-utils"
  depends_on "gcc"
  depends_on "gsl"
  depends_on "numa"
  depends_on "qt@4"
  depends_on "sfml"

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  def caveats
    <<~EOS
      The PARTONS library is now installed on this machine.
      An example suite can be found here:

          https://drf-gitlab.cea.fr/partons/core/partons-example/repository/v2.0/archive.tar.gz

      A usage guide is available at:

          http://partons.cea.fr/partons/doc/html/index.html

    EOS
  end

  test do
    system "false"
  end
end
