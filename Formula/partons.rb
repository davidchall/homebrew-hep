class Partons < Formula
  desc "PARtonic Tomography Of Nucleon Software"
  homepage "https://drf-gitlab.cea.fr/partons/core/partons"
  url "https://drf-gitlab.cea.fr/partons/core/partons/-/archive/v4.0/partons-v4.0.tar.gz"
  sha256 "ecd6f5c307e20cb096ce4bfc5d917f84d8f9201f5090c4dfb54472174d93811f"
  license all_of: ["Apache-2.0", "GPL-3.0-only"]

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://ghcr.io/v2/davidchall/hep"
    sha256 cellar: :any, monterey: "a40f77bb02886fa7fd04fe14e1c58c58250c4191a08f5c10366180b2e4ec820b"
    sha256 cellar: :any, big_sur:  "3f74552eba67822c3e176eb51b72d58f062e3f3a5fd1aa47c19e76bf8702f8bf"
    sha256 cellar: :any, catalina: "c0e7d2d9d46cf24297d1d93e685b38a8be3e1f10dd36dd94336e1145acb3f2af"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "apfel++"
  depends_on "cln"
  depends_on "eigen"
  depends_on "gcc"
  depends_on "gsl"
  depends_on "lhapdf"
  depends_on "qt@5"
  depends_on "sfml"

  resource "elementary-utils" do
    url "https://drf-gitlab.cea.fr/partons/core/elementary-utils/-/archive/v4.0/elementary-utils-v4.0.tar.gz"
    sha256 "cc0f5f7da32464bdde63301dac353325c3b80b0077c01dcc9890041ed9110ffc"
  end

  resource "numa" do
    url "https://drf-gitlab.cea.fr/partons/core/numa/-/archive/v4.0/numa-v4.0.tar.gz"
    sha256 "1a601377f2a0c69516ae801c27f77768051811b6c1eda2baaeb15d61896b7d2a"
  end

  resource "partons-test" do
    url "https://drf-gitlab.cea.fr/partons/core/partons-example/-/archive/v4.0/partons-example-v4.0.tar.gz"
    sha256 "0e0d258e763c13677790b1d92e3b09fc5553c62b320762f0da8ec36d62166cfc"
  end

  def install
    resource("elementary-utils").stage do
      system "cmake", ".", *std_cmake_args
      system "make"
      system "make", "install"
    end

    resource("numa").stage do
      system "cmake", ".", *std_cmake_args
      system "make"
      system "make", "install"
    end

    system "cmake", ".", *std_cmake_args
    system "make"
    system "make", "install"
  end

  test do
    testpath.install resource("partons-test")
    system "cmake", ".", *std_cmake_args, "-DCMAKE_PREFIX_PATH=#{Formula["qt@5"].opt_prefix}"
    system "make"
    system testpath/"bin/PARTONS_example", "data/examples/gpd/computeSingleKinematicsForGPD.xml"
  end
end
