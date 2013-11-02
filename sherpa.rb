require 'formula'

class Sherpa < Formula
  homepage 'https://sherpa.hepforge.org/'
  url 'http://www.hepforge.org/archive/sherpa/SHERPA-MC-2.0.0.tar.gz'
  sha1 'b1371dcb96c7cf4cea7d41fbeb4a402e2b01d05b'

  def patches
    DATA
  end

  depends_on 'hepmc'   => :recommended
  depends_on 'rivet'   => :recommended
  depends_on 'lhapdf'  => :recommended
  depends_on 'fastjet' => :optional
  depends_on :fortran

  def install
    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --enable-multithread
    ]

    args << "--enable-hepmc2=#{Formula.factory('hepmc').prefix}"    if build.with? "hepmc"
    args << "--enable-rivet=#{Formula.factory('rivet').prefix}"     if build.with? "rivet"
    args << "--enable-lhapdf=#{Formula.factory('lhapdf').prefix}"   if build.with? "lhapdf"
    args << "--enable-fastjet=#{Formula.factory('fastjet').prefix}" if build.with? "fastjet"

    system "./configure", *args
    system "make", "install"
  end

  test do
    (testpath/"Run.dat").write <<-EOS.undent
      (beam){
        BEAM_1 =  2212; BEAM_ENERGY_1 = 7000;
        BEAM_2 =  2212; BEAM_ENERGY_2 = 7000;
      }(beam)

      (processes){
        Process 93 93 -> 11 -11;
        Order_EW 2;
        Integration_Error 0.05;
        End process;
      }(processes)

      (selector){
        Mass 11 -11 66 166
      }(selector)

      (mi){
        MI_HANDLER = None   # None or Amisic
      }(mi)
    EOS

    system "Sherpa", "-p", testpath, "-L", testpath, "-e", "1000"
    puts "You just successfully generated 1000 Drell-Yan events!"
    puts "Please now delete the \"Sherpa_References.tex\" file"
  end
end


__END__
diff --git a/AHADIC++/Tools/Transitions.H b/AHADIC++/Tools/Transitions.H
index 08e761d..25cf960 100644
--- a/AHADIC++/Tools/Transitions.H
+++ b/AHADIC++/Tools/Transitions.H
@@ -13,7 +13,7 @@
 namespace AHADIC {
   class Flavour_Sorting_Mass {
   public :
-    bool operator() (const ATOOLS::Flavour & fl1,const ATOOLS::Flavour & fl2) {
+    bool operator() (const ATOOLS::Flavour & fl1,const ATOOLS::Flavour & fl2) const {
       if (fl1.HadMass()>fl2.HadMass()) return true;
       return false;
     }
@@ -52,7 +52,7 @@ namespace AHADIC {
   class Flavour_Pair_Sorting_Mass {
   public :
     bool operator() (const Flavour_Pair & flpair1,
-		     const Flavour_Pair & flpair2) {
+		     const Flavour_Pair & flpair2) const {
       if (//(flpair1.first==flpair2.second.Bar() &&
 	  //flpair1.first==flpair2.second &&
 	  //flpair1.second==flpair2.first.Bar() &&
diff --git a/MODEL/Main/SM_U1_B.C b/MODEL/Main/SM_U1_B.C
index 35f7ea2..474c52b 100644
--- a/MODEL/Main/SM_U1_B.C
+++ b/MODEL/Main/SM_U1_B.C
@@ -177,10 +177,10 @@ void SM_U1_B::FixMix() {
       for (int j=0;j<3;++j) {
 	Complex entry=Complex(0.,0.);
 	for (int k=0;k<3;++k) entry += Mix[i][k]*Mixconj[k][j];
-	if (ATOOLS::dabs(entry.real())<1.e-12) entry.real() = 0.;
-	if (ATOOLS::dabs(entry.imag())<1.e-12) entry.imag() = 0.;
-	if (ATOOLS::dabs(1.-entry.real())<1.e-12) entry.real() = 1.;
-	if (ATOOLS::dabs(1.-entry.imag())<1.e-12) entry.imag() = 1.;
+	if (ATOOLS::dabs(entry.real())<1.e-12) entry = Complex(0., entry.imag());
+	if (ATOOLS::dabs(entry.imag())<1.e-12) entry = Complex(entry.real(), 0.);
+	if (ATOOLS::dabs(1.-entry.real())<1.e-12) entry = Complex(1., entry.imag());
+	if (ATOOLS::dabs(1.-entry.imag())<1.e-12) entry = Complex(entry.real(), 1.);
 	msg_Out()<<std::setw(os)<<entry;
       }
       msg_Out()<<"\n";
