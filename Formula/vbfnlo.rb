class Vbfnlo < Formula
  desc "Parton-level Monte Carlo for processes with electroweak bosons"
  homepage "https://www.itp.kit.edu/vbfnlo"
  url "https://www.itp.kit.edu/vbfnlo/wiki/lib/exe/fetch.php?media=download:vbfnlo-3.0.0beta5.tgz"
  sha256 "d7ce67aa394a6b47da33ede3a0314436414ec12d6c30238622405bdfb76cb544"
  revision 2

  livecheck do
    skip "In longterm beta"
  end

  bottle do
    root_url "https://ghcr.io/v2/davidchall/hep"
    sha256 cellar: :any, monterey: "291c743e810d2fac4f029c0a19836a2ecb6cc196058213f7cdac4bb2c3e2c562"
    sha256 cellar: :any, big_sur:  "01da231788e9fcdec02f86dc420fef47e599d3e428df0dddbbb50e4e7ef7d8b6"
    sha256 cellar: :any, catalina: "9b9695cf5bc1153d4ba453637ea82de9d14c0139d3dd493c7cfc8d7d98f681ff"
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
      --prefix=#{prefix}
    ]

    args << "--enable-spin2"                                if build.with? "spin2"
    args << "--enable-kk"                                   if build.with? "kk"
    args << "--with-LHAPDF=#{Formula["lhapdf"].opt_prefix}" if build.with? "lhapdf"
    args << "--with-root=#{Formula["root"].opt_prefix}"     if build.with? "root"

    # https://github.com/davidchall/homebrew-hep/issues/203
    args << "--disable-quad"

    # resolve gfortran compiler errors
    ENV.append "FCFLAGS", "-std=legacy"

    # link to gfortran libraries
    inreplace "utilities/Makefile.in",
              "$(libVBFNLOUtilities_la_LIBADD) $(LIBS)",
              "$(libVBFNLOUtilities_la_LIBADD) $(LIBS) $(FCLIBS)"

    system "./configure", *args
    system "make"
    system "make", "install"
  end

  test do
    system bin/"vbfnlo"
  end
end
