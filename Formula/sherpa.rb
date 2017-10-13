class Sherpa < Formula
  desc "Monte Carlo event generator"
  homepage "https://sherpa.hepforge.org"
  url "http://www.hepforge.org/archive/sherpa/SHERPA-MC-2.2.4.tar.gz"
  sha256 "5dc8bccc9a242ead06ce1f8838988b7367641d8989466e0f9d6b7e74fa8e80e7"

  patch :p2, :DATA

  # Requires changes to MCFM code, so cannot use MCFM formula
  option "with-mcfm", "Enable use of MCFM loops"
  if build.with? "mcfm"
    depends_on "gnu-sed" => :build
  end

  depends_on "hepmc"     => :recommended
  depends_on "rivet"     => :optional
  depends_on "lhapdf"    => :recommended
  depends_on "fastjet"   => :optional
  depends_on "openloops" => :optional
  depends_on "root"      => :optional
  depends_on :mpi        => [:cc, :cxx, :f90, :optional]
  depends_on :fortran

  def install
    ENV.delete("SDKROOT") if DevelopmentTools.clang_build_version >= 900
    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
    ]

    if build.with? "mpi"
      args << "--enable-mpi"
      ENV["CC"] = ENV["MPICC"]
      ENV["CXX"] = ENV["MPICXX"]
      ENV["FC"] = ENV["MPIFC"]
    end

    args << "--enable-hepmc2=#{Formula["hepmc"].opt_prefix}"        if build.with? "hepmc"
    args << "--enable-lhapdf=#{Formula["lhapdf"].opt_prefix}"       if build.with? "lhapdf"
    args << "--enable-fastjet=#{Formula["fastjet"].opt_prefix}"     if build.with? "fastjet"
    args << "--enable-openloops=#{Formula["openloops"].opt_prefix}" if build.with? "openloops"
    args << "--enable-root=#{Formula["root"].opt_prefix}"           if build.with? "root"

    if build.with? "rivet"
      args << "--enable-rivet=#{Formula["rivet"].opt_prefix}"
      # Included rivet headers require C++11 to compile, which sherpa does not do per default
      ENV.append "CXXFLAGS", "-std=c++11"
    end

    if build.with? "mcfm"
      mcfm_path = buildpath/"mcfm"
      mcfm_path.mkdir
      cd mcfm_path do
        # MCFM build sometimes fails due to race condition
        ENV.deparallelize
        # install script uses wget, remove this dependency
        inreplace "#{buildpath}/AddOns/MCFM/install_mcfm.sh", "wget", "curl -O"
        # install script uses GNU extensions to sed
        inreplace "#{buildpath}/AddOns/MCFM/install_mcfm.sh", "sed", "gsed"
        system "#{buildpath}/AddOns/MCFM/install_mcfm.sh"
        # there is no ENV.parallelize
        ENV["MAKEFLAGS"] = "-j#{ENV.make_jobs}"
        args << "--enable-mcfm=#{mcfm_path}"
      end
    end

    system "./configure", *args
    system "make", "install"

    bash_completion.install share/"SHERPA-MC/sherpa-completion"
  end

  test do
    (testpath/"Run.dat").write <<-EOS.undent
      (beam){
        BEAM_1 = 2212; BEAM_ENERGY_1 = 7000
        BEAM_2 = 2212; BEAM_ENERGY_2 = 7000
      }(beam)

      (processes){
        Process 93 93 -> 11 -11
        Order (*,2)
        Integration_Error 0.05
        End process
      }(processes)

      (selector){
        Mass 11 -11 66 166
      }(selector)

      (mi){
        MI_HANDLER = None   # None or Amisic
      }(mi)
    EOS

    system "Sherpa", "-p", testpath, "-L", testpath, "-e", "1000"
    ohai "You just successfully generated 1000 Drell-Yan events!"
  end
end

__END__
Index: COMIX/Main/Single_Process.C
===================================================================
diff --git a/branches/COMIX/Main/Single_Process.C b/branches/COMIX/Main/Single_Process.C
--- a/branches/COMIX/Main/Single_Process.C	(revision 31007)
+++ b/branches/COMIX/Main/Single_Process.C	(revision 31008)
@@ -265,8 +265,8 @@
 	  for (size_t j(0);j<nfmap;++j) {
 	    long int src, dest;
 	    *map>>src>>dest;
-	    Flavour ft((kf_code)(abs(src)),src<0);
-	    Flavour fb((kf_code)(abs(dest)),dest<0);
+	    Flavour ft((kf_code)(std::abs(src)),src<0);
+	    Flavour fb((kf_code)(std::abs(dest)),dest<0);
 	    m_fmap[ft]=fb;
 	    msg_Debugging()<<"  fmap '"<<ft<<"' onto '"<<fb<<"'\n";
 	  }
Index: SHERPA/PerturbativePhysics/Matrix_Element_Handler.C
===================================================================
diff --git a/branches/SHERPA/PerturbativePhysics/Matrix_Element_Handler.C b/branches/SHERPA/PerturbativePhysics/Matrix_Element_Handler.C
--- a/branches/SHERPA/PerturbativePhysics/Matrix_Element_Handler.C	(revision 31007)
+++ b/branches/SHERPA/PerturbativePhysics/Matrix_Element_Handler.C	(revision 31008)
@@ -476,7 +476,7 @@
 	if (cur[0]=="No_Decay")
 	  for (size_t i(1);i<cur.size();++i) {
 	    long int kfc(ToType<long int>(cur[i]));
-	    pi.m_nodecs.push_back(Flavour(abs(kfc),kfc<0));
+	    pi.m_nodecs.push_back(Flavour(std::abs(kfc),kfc<0));
 	  }
 	if (cur[0]=="Order") {
 	  std::string cb(MakeString(cur,1));
Index: PHASIC++/Selectors/Decay_Selector.C
===================================================================
diff --git a/branches/PHASIC++/Selectors/Decay_Selector.C b/branches/PHASIC++/Selectors/Decay_Selector.C
--- a/branches/PHASIC++/Selectors/Decay_Selector.C	(revision 31007)
+++ b/branches/PHASIC++/Selectors/Decay_Selector.C	(revision 31008)
@@ -74,7 +74,7 @@
   tag.erase(tag.length()-1,1);
   DEBUG_FUNC(tag);
   long int kf(ToType<long int>(key[0][0]));
-  Flavour fl(abs(kf),kf<0);
+  Flavour fl(std::abs(kf),kf<0);
   DecayInfo_Vector decs
     (key.p_proc->Process()->Info().m_fi.GetDecayInfos());
   for (size_t i(0);i<decs.size();++i)
@@ -150,7 +150,7 @@
 {
   DEBUG_FUNC(key.m_key);
   long int kf(ToType<long int>(key[0][0]));
-  Flavour fl(abs(kf),kf<0);
+  Flavour fl(std::abs(kf),kf<0);
   DecayInfo_Vector decs
     (key.p_proc->Process()->Info().m_fi.GetDecayInfos());
   for (size_t i(0);i<decs.size();++i)
Index: PHASIC++/Selectors/Decay2_Selector.C
===================================================================
diff --git a/branches/PHASIC++/Selectors/Decay2_Selector.C b/branches/PHASIC++/Selectors/Decay2_Selector.C
--- a/branches/PHASIC++/Selectors/Decay2_Selector.C	(revision 31007)
+++ b/branches/PHASIC++/Selectors/Decay2_Selector.C	(revision 31008)
@@ -58,7 +58,7 @@
   DEBUG_FUNC(tag);
   long int kf1(ToType<long int>(key[0][0]));
   long int kf2(ToType<long int>(key[0][1]));
-  Flavour fl1(abs(kf1),kf1<0), fl2(abs(kf2),kf2<0);
+  Flavour fl1(std::abs(kf1),kf1<0), fl2(std::abs(kf2),kf2<0);
   DecayInfo_Vector decs
     (key.p_proc->Process()->Info().m_fi.GetDecayInfos());
   for (size_t i(0);i<decs.size();++i) {
Index: MODEL/Main/Model_Base.C
===================================================================
diff --git a/branches/MODEL/Main/Model_Base.C b/branches/MODEL/Main/Model_Base.C
--- a/branches/MODEL/Main/Model_Base.C	(revision 31007)
+++ b/branches/MODEL/Main/Model_Base.C	(revision 31008)
@@ -382,12 +382,12 @@
     for (size_t j(2);j<helpsvv[i].size();++j) {
       msg_Debugging()<<" "<<helpsvv[i][j];
       long int kfc(ToType<long int>(helpsvv[i][j]));
-      s_kftable[nkf]->Add(Flavour((kf_code)abs(kfc),kfc<0));
-      if (s_kftable[abs(kfc)]->m_priority)
+      s_kftable[nkf]->Add(Flavour((kf_code)std::abs(kfc),kfc<0));
+      if (s_kftable[std::abs(kfc)]->m_priority)
 	msg_Error()<<METHOD<<"(): Changing "<<Flavour(kfc)<<" sort priority: "
-		   <<s_kftable[abs(kfc)]->m_priority<<" -> "
+		   <<s_kftable[std::abs(kfc)]->m_priority<<" -> "
 		   <<s_kftable[nkf]->m_priority<<std::endl;
-      s_kftable[abs(kfc)]->m_priority=s_kftable[abs(nkf)]->m_priority;
+      s_kftable[std::abs(kfc)]->m_priority=s_kftable[std::abs(nkf)]->m_priority;
     }
     s_kftable[nkf]->SetIsGroup(true);
     msg_Debugging()<<" }\n";
Index: ATOOLS/Math/Algebra_Interpreter.C
===================================================================
diff --git a/branches/ATOOLS/Math/Algebra_Interpreter.C b/branches/ATOOLS/Math/Algebra_Interpreter.C
--- a/branches/ATOOLS/Math/Algebra_Interpreter.C	(revision 31007)
+++ b/branches/ATOOLS/Math/Algebra_Interpreter.C	(revision 31008)
@@ -821,7 +821,8 @@
 
 void Algebra_Interpreter::PrintNode(Node<Function*> *const node) const
 {
-  msg_Info()<<"("<<node<<") ["<<Demangle(typeid(*(*node)[0]).name())<<"] '"
+  Function member = *(*node)[0];
+  msg_Info()<<"("<<node<<") ["<<Demangle(typeid(member).name())<<"] '"
 	    <<((*node)[0]!=NULL?(*node)[0]->Tag():"<NULL>")<<"' {\n";
   {
     msg_Indent();
Index: ATOOLS/Phys/Flavour.C
===================================================================
diff --git a/branches/ATOOLS/Phys/Flavour.C b/branches/ATOOLS/Phys/Flavour.C
--- a/branches/ATOOLS/Phys/Flavour.C	(revision 31007)
+++ b/branches/ATOOLS/Phys/Flavour.C	(revision 31008)
@@ -298,8 +298,8 @@
 
 bool Flavour::IsDiQuark() const 
 {
-  if(abs(Kfcode())>=1103&&abs(Kfcode())<=5505) {
-    double help=abs(Kfcode())/100.0-int(abs(Kfcode())/100.0); 
+  if(Kfcode() >= 1103 && Kfcode() <= 5505) {
+    double help = Kfcode()/100.0 - int(Kfcode()/100.0); 
     if(help<0.031) return true;
   }
   return false;
@@ -307,27 +307,27 @@
 
 bool Flavour::IsBaryon() const 
 {
-  if (abs(Kfcode())%10000<1000) return false;
+  if (Kfcode() % 10000 < 1000) return false;
   return !IsDiQuark();
 }
 
 bool Flavour::IsB_Hadron() const 
 {
-  if (abs(Kfcode())<100)                            return 0;
-  if (Kfcode()-100*int(Kfcode()/100)<10)                 return 0;
-  if (abs((Kfcode()-100*int(Kfcode()/100))/10)==5)       return 1;
-  if (abs((Kfcode()-1000*int(Kfcode()/1000))/100)==5)    return 1;
-  if (abs((Kfcode()-10000*int(Kfcode()/10000))/1000)==5) return 1;
+  if (Kfcode() < 100)                               return 0;
+  if (Kfcode()-100*int(Kfcode()/100)<10)            return 0;
+  if ((Kfcode()-100*int(Kfcode()/100))/10==5)       return 1;
+  if ((Kfcode()-1000*int(Kfcode()/1000))/100==5)    return 1;
+  if ((Kfcode()-10000*int(Kfcode()/10000))/1000==5) return 1;
   return 0;
 }
 
 bool Flavour::IsC_Hadron() const 
 {
-  if (abs(Kfcode())<100)                            return 0;
-  if (Kfcode()-100*int(Kfcode()/100)<10)                 return 0;
-  if (abs((Kfcode()-100*int(Kfcode()/100))/10)==4)       return 1;
-  if (abs((Kfcode()-1000*int(Kfcode()/1000))/100)==4)    return 1;
-  if (abs((Kfcode()-10000*int(Kfcode()/10000))/1000)==4) return 1;
+  if (Kfcode() < 100)                               return 0;
+  if (Kfcode()-100*int(Kfcode()/100)<10)            return 0;
+  if ((Kfcode()-100*int(Kfcode()/100))/10==4)       return 1;
+  if ((Kfcode()-1000*int(Kfcode()/1000))/100==4)    return 1;
+  if ((Kfcode()-10000*int(Kfcode()/10000))/1000==4) return 1;
   return 0;
 }
 
Index: ATOOLS/Phys/Flavour.H
===================================================================
diff --git a/branches/ATOOLS/Phys/Flavour.H b/branches/ATOOLS/Phys/Flavour.H
--- a/branches/ATOOLS/Phys/Flavour.H	(revision 31007)
+++ b/branches/ATOOLS/Phys/Flavour.H	(revision 31008)
@@ -110,7 +110,7 @@
     
     inline Flavour(const long int &kfc=kf_none):
       p_info(NULL), m_anti(0)
-    { KFCode_ParticleInfo_Map::iterator it(s_kftable.find(abs(kfc)));
+    { KFCode_ParticleInfo_Map::iterator it(s_kftable.find(std::abs(kfc)));
       if (it!=s_kftable.end()) p_info=it->second; else return;
       if (kfc<0 && p_info->m_majorana==0) m_anti=1; }
     
Index: BEAM/Main/EPA.C
===================================================================
diff --git a/branches/BEAM/Main/EPA.C b/branches/BEAM/Main/EPA.C
--- a/branches/BEAM/Main/EPA.C	(revision 31007)
+++ b/branches/BEAM/Main/EPA.C	(revision 31008)
@@ -54,7 +54,7 @@
 
 double EPA::phi(double x, double qq)
 {
-  if (abs(m_beam.Kfcode()) == kf_p_plus) {
+  if (m_beam.Kfcode() == kf_p_plus) {
     const double a = 7.16;
     const double b = -3.96;
     const double c = .028;
@@ -179,7 +179,7 @@
     m_weight=0.0;
     return 1;
   }
-  if (abs(m_beam.Kfcode()) == kf_e) {
+  if (m_beam.Kfcode() == kf_e) {
     double f = alpha/M_PI*(1+sqr(1-m_x))/m_x*log(2.*m_energy/m_mass);
     if (f < 0) f = 0.;
     m_weight = f;
@@ -187,7 +187,7 @@
 	     <<"energy = "<<m_energy<<", "<<"mass = "<<m_mass<<".\n";
     return 1;    
   }
-  else if (abs(m_beam.Kfcode()) == kf_p_plus) {
+  else if (m_beam.Kfcode() == kf_p_plus) {
     const double qz = 0.71;
     double f, qmi, qma;
     qma=m_q2Max/qz;
Index: AddOns/Pythia/Pythia_Jet_Criterion.C
===================================================================
diff --git a/branches/AddOns/Pythia/Pythia_Jet_Criterion.C b/branches/AddOns/Pythia/Pythia_Jet_Criterion.C
--- a/branches/AddOns/Pythia/Pythia_Jet_Criterion.C	(revision 31007)
+++ b/branches/AddOns/Pythia/Pythia_Jet_Criterion.C	(revision 31008)
@@ -117,8 +117,8 @@
       double Qsq = sign * Q.Abs2();
       // Mass term of radiator
       DEBUG_VAR(ampl->MS());
-      double m2Rad = ( abs(RadAfterBranch.Flav().Kfcode()) >= 4
-                   && abs(RadAfterBranch.Flav().Kfcode()) < 7)
+      double m2Rad = ( RadAfterBranch.Flav().Kfcode() >= 4
+                   && RadAfterBranch.Flav().Kfcode() < 7)
                    ? ampl->MS()->Mass2(RadAfterBranch.Flav())
                    : 0.;
       // Construct 2->3 variables for FSR
Index: PDF/Remnant/Hadron_Remnant.C
===================================================================
diff --git a/branches/PDF/Remnant/Hadron_Remnant.C b/branches/PDF/Remnant/Hadron_Remnant.C
--- a/branches/PDF/Remnant/Hadron_Remnant.C	(revision 31007)
+++ b/branches/PDF/Remnant/Hadron_Remnant.C	(revision 31008)
@@ -188,13 +188,13 @@
     if (m_constit[i]==flav && !found) found=true;
     else rem[j++]=m_constit[i].Kfcode();
   }
-  Flavour anti=Flavour((kf_code)(abs(rem[0])*1000+abs(rem[1])*100+3));
+  Flavour anti=Flavour((kf_code)(rem[0]*1000+rem[1]*100+3));
   if (rem[0]!=rem[1]) {
     if (ran->Get()<0.25) 
-      anti=Flavour((kf_code)(abs(rem[0])*1000+abs(rem[1])*100+1));
+      anti=Flavour((kf_code)(rem[0]*1000+rem[1]*100+1));
   }
   else {
-    anti=Flavour((kf_code)(abs(rem[0])*1100+3));
+    anti=Flavour((kf_code)(rem[0]*1100+3));
   }
   if (flav.IsAnti()) anti=anti.Bar();
   return anti;
