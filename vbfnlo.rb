
class Vbfnlo < Formula
  homepage "https://www.itp.kit.edu/vbfnlo/wiki/doku.php?id=overview"
  version "3.0.0beta2"
  url "https://www.itp.kit.edu/vbfnlo/wiki/lib/exe/fetch.php?media=download:vbfnlo-#{version}.tgz"
  sha256 "c4b998f7541f0b192da69ee47597f7fcdee7e537326a2542e8122cf4eed4749c"

  depends_on :fortran
  depends_on 'hepmc'   => :required
  depends_on 'lhapdf'  => :required
  depends_on 'homebrew/science/root' => :optional
  depends_on 'gsl' => :required


  def install
    ENV.delete("F77")
    args = %W[
      --prefix=#{prefix}
    ]

    if build.with? "spin2"
      args << "--enable-kk"
      args << "--enable-gsl=#{Formula['gsl'].prefix}"
    end

    args << "--enable-kk"        if build.with? "kk"
    args << "--enable-LHAPDF=#{Formula['lhapdf'].prefix}"       if build.with? "lhapdf"
    args << "--enable-ROOT=#{Formula['root'].prefix}"           if build.with? "root"
    args << "--enable-HEPMC=#{Formula['hepmc'].prefix}"         if build.with? "hepmc"
    args << "--enable-gsl=#{Formula['gsl'].prefix}"             if build.with? "gsl"

    system "./configure", *args
    system "make", "install"
  end

  def caveats; <<-EOS.undent
    Run using:
      vbfnlo --input=PATH/TO/INPUT
      ggflo --input=PATH/TO/INPUT
    EOS
  end

  test do

    system "false"

  end
end
