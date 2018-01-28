class Vbfnlo < Formula
  desc "Parton-level Monte Carlo for processes with electroweak bosons"
  homepage "https://www.itp.kit.edu/vbfnlo"
  url "https://www.itp.kit.edu/vbfnlo/wiki/lib/exe/fetch.php?media=download:vbfnlo-3.0.0beta3.tgz"
  version "3.0.0beta3"
  sha256 "bd1fb2e59fc0095bd339fc7a9d2070a078c6ee16f7b74ae5035763eea153cb58"

  option "with-kk", "Enable Kaluza-Klein resonances"
  option "with-spin2", "Enable spin-2 resonances"

  depends_on "gcc" # for gfortran
  depends_on "hepmc" => :recommended
  depends_on "lhapdf" => :recommended
  depends_on "homebrew/science/root6" => :optional

  if build.with? "kk"
    depends_on "gsl"
  else
    depends_on "gsl" => :recommended
  end

  def install
    ENV.delete("F77")
    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --enable-shared=no
      --prefix=#{prefix}
    ]

    args << "--enable-spin2"                                if build.with? "spin2"
    args << "--enable-kk"                                   if build.with? "kk"
    args << "--with-LHAPDF=#{Formula["lhapdf"].opt_prefix}" if build.with? "lhapdf"
    args << "--with-root=#{Formula["root6"].opt_prefix}"    if build.with? "root6"
    args << "--with-hepmc=#{Formula["hepmc"].opt_prefix}"   if build.with? "hepmc"

    system "./configure", *args
    system "make", "install"
  end

  test do
    system "vbfnlo"
    ohai "Successfully computed VBF Higgs production cross section"
  end
end
