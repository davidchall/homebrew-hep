class Vbfnlo < Formula
  desc "Parton-level Monte Carlo for processes with electroweak bosons"
  homepage "https://www.itp.kit.edu/vbfnlo"
  url "https://www.itp.kit.edu/vbfnlo/wiki/lib/exe/fetch.php?media=download:vbfnlo-3.0.0beta5.tgz"
  sha256 "d7ce67aa394a6b47da33ede3a0314436414ec12d6c30238622405bdfb76cb544"
  revision 3

  livecheck do
    skip "In longterm beta"
  end

  bottle do
    root_url "https://ghcr.io/v2/davidchall/hep"
    sha256               arm64_sonoma: "5e51bb2e8214ba30fb3f0f89c8cc86f41ce93463d2976670af432331e7be53fa"
    sha256 cellar: :any, ventura:      "db335ff994feeae3992cda1d044e87ead5381c97a0f1367172e10af101effc06"
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
