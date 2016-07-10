class Vbfnlo < Formula
  desc "Parton-level Monte Carlo for processes with electroweak bosons"
  homepage "https://www.itp.kit.edu/vbfnlo"
  url "https://www.itp.kit.edu/vbfnlo/wiki/lib/exe/fetch.php?media=download:vbfnlo-3.0.0beta2.tgz"
  version "3.0.0beta2"
  sha256 "c4b998f7541f0b192da69ee47597f7fcdee7e537326a2542e8122cf4eed4749c"

  option "with-kk", "Enable Kaluza-Klein resonances"
  option "with-spin2", "Enable spin-2 resonances"

  depends_on :fortran
  depends_on "hepmc" => :recommended
  depends_on "lhapdf" => :recommended
  depends_on "homebrew/science/root" => :optional

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
      --prefix=#{prefix}
    ]

    args << "--enable-spin2"                                if build.with? "spin2"
    args << "--enable-kk"                                   if build.with? "kk"
    args << "--with-LHAPDF=#{Formula["lhapdf"].opt_prefix}" if build.with? "lhapdf"
    args << "--with-root=#{Formula["root"].opt_prefix}"     if build.with? "root"
    args << "--with-hepmc=#{Formula["hepmc"].opt_prefix}"   if build.with? "hepmc"

    system "./configure", *args
    system "make", "install"
  end

  test do
    system "vbfnlo"
    ohai "Successfully computed VBF Higgs production cross section"
  end
end
