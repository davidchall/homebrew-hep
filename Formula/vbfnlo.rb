class Vbfnlo < Formula
  desc "Parton-level Monte Carlo for processes with electroweak bosons"
  homepage "https://www.itp.kit.edu/vbfnlo"
  url "https://www.itp.kit.edu/vbfnlo/wiki/lib/exe/fetch.php?media=download:vbfnlo-3.0.0beta5.tgz"
  sha256 "d7ce67aa394a6b47da33ede3a0314436414ec12d6c30238622405bdfb76cb544"

  livecheck do
    skip "In longterm beta"
  end

  bottle do
    root_url "https://ghcr.io/v2/davidchall/hep"
    rebuild 1
    sha256 cellar: :any, monterey: "a201d2b48c6433a0cb2e2bdb9a8984ca9c70631e9bcffdbedc7e95a27c05dec1"
    sha256 cellar: :any, big_sur:  "944b879b9f93277279313595fba2a2e4d31372c9ab0a3f7d8b9a0f14ed09c08a"
    sha256 cellar: :any, catalina: "15e60fa3a3887b3605ff7949306185000084d76521bb48fb228884b2ff8d8b7b"
  end

  option "with-kk", "Enable Kaluza-Klein resonances"
  option "with-spin2", "Enable spin-2 resonances"

  depends_on "gcc" # for gfortran
  depends_on "lhapdf" => :recommended
  depends_on "root" => :optional

  if build.with? "kk"
    depends_on "gsl"
  else
    depends_on "gsl" => :recommended
  end

  def install
    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --enable-shared=no
      --prefix=#{prefix}
    ]

    args << "--enable-spin2"                                if build.with? "spin2"
    args << "--enable-kk"                                   if build.with? "kk"
    args << "--with-LHAPDF=#{Formula["lhapdf"].opt_prefix}" if build.with? "lhapdf"
    args << "--with-root=#{Formula["root"].opt_prefix}"     if build.with? "root"

    # https://github.com/davidchall/homebrew-hep/issues/203
    args << "--disable-quad"

    ENV.append "FCFLAGS", "-std=legacy"

    system "./configure", *args
    system "make"
    system "make", "install"
  end

  test do
    system bin/"vbfnlo"
  end
end
