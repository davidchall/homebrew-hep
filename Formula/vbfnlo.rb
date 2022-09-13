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
    sha256 cellar: :any, monterey: "c0dd264d565a140cd52fddbb505d708adc0cf1e9cb5df00b2505cfcfeed36e31"
    sha256 cellar: :any, big_sur:  "5e265f263077e70e6094c594454e3c43f590f9c4a62f88dda998a3d038999e70"
    sha256 cellar: :any, catalina: "b48bc555d0e964157844e453c22aee8e36b76c2ad887b26d1ac37e9eda1b4420"
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
