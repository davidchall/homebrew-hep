require 'formula'

class Sherpa < Formula
  homepage 'https://sherpa.hepforge.org/'
  url 'http://www.hepforge.org/archive/sherpa/SHERPA-MC-1.4.3.tar.gz'
  sha1 'ba9d3fdf67057358a2194584bd8f9f4fa2c4940e'

  devel do
    url 'http://www.hepforge.org/archive/sherpa/SHERPA-MC-2.0.beta2.tar.gz'
    sha1 '6e0908316a00194032e19e7705c837252f7a6e83'
    version '2.0.b2'
  end

  def install
    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
    ]

    ENV.fortran
    ENV.append 'LDFLAGS', "-L/usr/lib -lstdc++"

    system "./configure", *args
    system "make"
    system "make", "install"
  end

  test do
    system "false"
  end

  def patches
    # Conform to C++ standards (to compile with clang)
    { :p0 => [
      "https://sherpa.hepforge.org/trac/raw-attachment/ticket/259/clang.patch"
    ]}
  end
end
