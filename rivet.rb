require 'formula'

class Rivet < Formula
  homepage 'http://rivet.hepforge.org/'
  url 'http://www.hepforge.org/archive/rivet/Rivet-1.8.3.tar.gz'
  sha1 'd6a8589deff21c896c76c17cf268e445cea76c53'

  depends_on 'hepmc'
  depends_on 'fastjet'
  depends_on 'gsl'
  depends_on 'boost'
  depends_on 'yaml-cpp025' # Rivet insists on v0.2.5 API
  depends_on 'swig' => :build

  def install
    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --prefix=#{prefix}
      --with-hepmc=#{Formula.factory('hepmc').prefix}
      --with-fastjet=#{Formula.factory('fastjet').prefix}
      --with-gsl=#{Formula.factory('gsl').prefix}
      --with-yaml_cpp=#{Formula.factory('yaml-cpp025').prefix}
    ]

    system "./configure", *args
    system "make", "install"

    prefix.install 'test'
  end

  test do
    system "cat #{prefix}/test/testApi.hepmc | #{bin}/rivet -a D0_2008_S7554427"
  end
end
