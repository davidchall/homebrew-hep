class Partons < Formula
  desc "PARtonic Tomography Of Nucleon Software"
  homepage "https://drf-gitlab.cea.fr/partons/core/partons"
  url "https://drf-gitlab.cea.fr/partons/core/partons/-/archive/v3.0/partons-v3.0.tar.gz"
  sha256 "03a5c6382e74d89f479a85fdcc3246403b6a5c3663a04710fb39321c2002da83"
  license all_of: ["Apache-2.0", "GPL-3.0-only"]
  revision 2

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
    url "https://drf-gitlab.cea.fr/partons/core/elementary-utils/-/archive/v3.0/elementary-utils-v3.0.tar.gz"
    sha256 "cddddf26b7d0104530e75a34ed46ec0bbabd881f17ea51f0efe01265c923e812"
  end

  resource "numa" do
    url "https://drf-gitlab.cea.fr/partons/core/numa/-/archive/v3.0/numa-v3.0.tar.gz"
    sha256 "d7c15d25d092d72be55346d8c3192dc81b08ebd93b3e62b37fc809cd598d96e9"
  end

  resource "partons-test" do
    url "https://drf-gitlab.cea.fr/partons/core/partons-example/-/archive/v3.0/partons-example-v3.0.tar.gz"
    sha256 "f4f7feb64c0afd53f054cedd6c5ca91e0267c4d423986e54ce3d1e8a6cb329c6"
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
