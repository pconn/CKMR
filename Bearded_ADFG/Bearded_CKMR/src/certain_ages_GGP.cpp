// TMB model for bearded seal CKMR w/ known ages
//author: Paul Conn
#include <TMB.hpp>
//#include <Eigen/Eigenvalues>
//#include <Eigen/Eigensolver>

template<class Type>
Type plogis(Type x){
  return 1.0 / (1.0 + exp(-x));
}

template<class Type>
Type dbinom_kern_log(Type n, Type x, Type p){
  Type p0 = p==0;
  return x*log(p+p0)+(n-x)*log(1.0-p);
}


template<class Type>
Type get_PPO_prob(int age_p,int cy,int dy,vector<Type> M_a, vector<Type> N_a_yr){
  // age of parent; conception year; parent death year; maturity-at-age; vector of age-specific abundance for cy
  int ideath = (dy>=cy);  //death of dad greater than equal to time of conception for positive prob  
  Type repro_tot = (M_a*N_a_yr).sum();
  return ideath*2.0*M_a(age_p)/repro_tot;
}

template<class Type>
Type get_MPO_prob(int age_p,int by,int dy,vector<Type> f_a, vector<Type> N_a_yr){
  int ideath = (dy>=by);  //death of mom greater than or equal to time of birth for positive prob  
  Type repro_tot = (f_a*N_a_yr).sum();
  return ideath*2.0*f_a(age_p)/repro_tot;
}

template<class Type>
Type get_PHS_prob(int n_ages,int delta_yr,vector<Type>N_a_yri,vector<Type>N_a_yrj,vector<Type>S_a,vector<Type>m_a){
  int upper = n_ages-delta_yr;
  Type phi = 1.0;
  Type cum_prob = 0.0;
  Type rel_repro1 = 0.0;
  Type rel_repro2 = 0.0;
  for(int ia=0;ia<n_ages;ia++){
    rel_repro1 += N_a_yri(ia)*m_a(ia);
    rel_repro2 += N_a_yrj(ia)*m_a(ia);
  }
  for(int ia=0;ia<upper;ia++){
    phi = 1.0;
    if(delta_yr>0){
      for(int ic=ia;ic<(ia+delta_yr);ic++){
        phi = phi*S_a(ic);
      }
    }
    cum_prob = cum_prob + phi*m_a(ia)*m_a(ia+delta_yr)*N_a_yri(ia);
  }
  return 2.0*cum_prob/(rel_repro1*rel_repro2);  //2.0 is because of 50/50 age structure
}

template<class Type>  //could get rid of a function as PHS, MHS are basically the same
Type get_MHS_prob(int n_ages,int delta_yr,vector<Type> N_a_yri,vector<Type> N_a_yrj,vector<Type>S_a,vector<Type>f_a){
  int upper = n_ages-delta_yr;
  Type phi = 1.0;
  Type cum_prob = 0.0;
  Type rel_repro1 = 0.0;
  Type rel_repro2 = 0.0;
  for(int ia=0;ia<n_ages;ia++){
    rel_repro1 += N_a_yri(ia)*f_a(ia);
    rel_repro2 += N_a_yrj(ia)*f_a(ia);
  }
  for(int ia=0;ia<upper;ia++){
    phi = 1.0;
    if(delta_yr>0){
      for(int ic=ia;ic<(ia+delta_yr);ic++){
        phi = phi*S_a(ic);
      }
    }
    cum_prob = cum_prob + phi*f_a(ia)*f_a(ia+delta_yr)*N_a_yri(ia);
  }
  return 2.0*cum_prob/(rel_repro1*rel_repro2);  
}

template<class Type>  //this is prob of GGP when older animal is female and the two animals share mtDNA
Type get_f_mt_GGP_prob(int n_ages,int bi, int bj, int di, int min_repro_fem,matrix<Type>N_a,vector<Type>S_a,vector<Type>f_a){
  int delta_yr = bj-bi;
  int min_repro_gap = 2.0*(min_repro_fem);
  Type tot_prob = 0.0;
  if(delta_yr>=min_repro_gap && di>=(bj-min_repro_fem)){  //GGP can only happen if there's time for two generations and of Grandmother lives to time of mother's first possible birth
    Type phi = 1.0;
    Type cum_prob = 0.0;
    Type tot_repro_k = 0.0;
    Type tot_repro_j = 0.0;
    vector<Type> N_a_yrk;
    vector<Type> N_a_yrj = N_a.row(bj);   
    int lower = bi+min_repro_fem;  //first year mother's birth possible
    int upper = std::min(di,bj-min_repro_fem);  //last year mother's birth possible
    for(int ia=0;ia<n_ages;ia++){
      tot_repro_j += N_a_yrj(ia)*f_a(ia);  
    }
    for(int ibk=lower;ibk<=upper;ibk++){  //sum over years of possible mom's birth
      tot_repro_k = 0;
      N_a_yrk = N_a.row(ibk);
        for(int ia=0;ia<n_ages;ia++){
          tot_repro_k += N_a_yrk(ia)*f_a(ia);
        }
      phi=1.0;
      for(int iak=0;iak<(bj-ibk);iak++)phi=phi*S_a(iak); //cum survival of mom through year prior to j's birth
      tot_prob += f_a(ibk-bi)*f_a(bj-ibk)*N_a_yrk(0)*phi/tot_repro_k;
    }
    tot_prob = tot_prob * 2.0 / tot_repro_j;    //4/tot_repro_j factors out of summation so multiply that at the end
  }
  return(tot_prob);
}

template<class Type>  //this is prob of GGP when older animal is female and the two animals do not share mtDNA (parent must be father)
Type get_f_nomt_GGP_prob(int n_ages,int bi, int bj, int di, int min_repro_fem,int min_repro_male,matrix<Type>N_a,vector<Type>S_a,vector<Type>f_a,vector<Type>m_a){
  int delta_yr = bj-bi;
  int min_repro_gap = min_repro_fem+min_repro_male+1;
  Type tot_prob = 0.0;
  if(delta_yr>=min_repro_gap && di>=(bj-min_repro_male-1)){  //GGP can only happen if there's time for two generations and of Grandmother lives to time of father's first possible birth
    Type phi = 1.0;
    Type cum_prob = 0.0;
    Type tot_repro_k = 0.0;
    Type tot_repro_j = 0.0;
    vector<Type> N_a_yrk;
    vector<Type> N_a_yrj = N_a.row(bj-1);   
    int lower = bi+min_repro_fem;  //first year father's birth possible
    int upper = std::min(di,bj-min_repro_male-1);  //last year father's birth possible
    for(int ia=0;ia<n_ages;ia++){
      tot_repro_j += N_a_yrj(ia)*m_a(ia);  
    }
    for(int ibk=lower;ibk<=upper;ibk++){  //sum over years of possible father's birth
      tot_repro_k = 0;
      N_a_yrk = N_a.row(ibk);
      for(int ia=0;ia<n_ages;ia++){
        tot_repro_k += N_a_yrk(ia)*f_a(ia);
      }
      phi=1.0;
      for(int iak=0;iak<(bj-ibk-1);iak++)phi=phi*S_a(iak); //cum survival of dad
      tot_prob += f_a(ibk-bi)*m_a(bj-ibk-1)*N_a_yrk(0)*phi/tot_repro_k; //can be any of the new males in year k
    }
    tot_prob = tot_prob * 2.0 / tot_repro_j;    //2/tot_repro_j factors out of summation so multiply that at the end
  }
  return(tot_prob);
}

template<class Type>  //this is prob of GGP when older animal is male and the two animals do not share mtDNA (parent can be either mother or father)
Type get_m_nomt_GGP_prob(int n_ages,int bi, int bj, int di, int min_repro_fem,int min_repro_male,matrix<Type>N_a,vector<Type>S_a,vector<Type>f_a,vector<Type>m_a){
  int delta_yr = bj-bi;
  //(1) parent is father
  int min_repro_gap = 2*(min_repro_male+1);
  Type tot_prob = 0.0;
  if(delta_yr>=min_repro_gap && di>=(bj-min_repro_male-1)){  //GGP can only happen if there's time for two generations 
    Type phi = 1.0;
    Type cum_prob = 0.0;
    Type tot_repro_k = 0.0;
    Type tot_repro_j = 0.0;
    vector<Type> N_a_yrk;
    vector<Type> N_a_yrj = N_a.row(bj-1);   
    int lower = bi+min_repro_male+1;  //first year father's birth possible
    int upper = std::min(di,bj-min_repro_male-1);  //last year father's birth possible
    for(int ia=0;ia<n_ages;ia++){
      tot_repro_j += N_a_yrj(ia)*m_a(ia);  
    }
    for(int ibk=lower;ibk<=upper;ibk++){  //sum over years of possible father's birth
      tot_repro_k = 0;
      N_a_yrk = N_a.row(ibk-1);
      for(int ia=0;ia<n_ages;ia++){
        tot_repro_k += N_a_yrk(ia)*m_a(ia);
      }
      phi=1.0;
      for(int iak=0;iak<(bj-ibk-1);iak++)phi=phi*S_a(iak); //cum survival of dad 
      tot_prob += m_a(ibk-bi-1)*m_a(bj-ibk-1)*N_a_yrk(0)*phi/tot_repro_k;
    }
    tot_prob = tot_prob * 2.0 / tot_repro_j;    //4/tot_repro_j factors out of summation multiply that at the end
  }
  //(2) parent is mother
  min_repro_gap = min_repro_male+1+min_repro_fem;
  Type tot_prob2 = 0.0;
  if(delta_yr>=min_repro_gap && di>=(bj-min_repro_fem)){  //GGP can only happen if there's time for two generations 
    Type phi = 1.0;
    Type cum_prob = 0.0;
    Type tot_repro_k = 0.0;
    Type tot_repro_j = 0.0;
    vector<Type> N_a_yrk;
    vector<Type> N_a_yrj = N_a.row(bj);   
    int lower = bi+min_repro_male+1;  //first year mother's birth possible
    int upper = std::min(di,bj-min_repro_fem);  //last year mother's birth possible
    for(int ia=0;ia<n_ages;ia++){
      tot_repro_j += N_a_yrj(ia)*f_a(ia);  
    }
    for(int ibk=lower;ibk<=upper;ibk++){  //sum over years of possible mother's birth
      tot_repro_k = 0;
      N_a_yrk = N_a.row(ibk-1);
      for(int ia=0;ia<n_ages;ia++){
        tot_repro_k += N_a_yrk(ia)*m_a(ia);
      }
      phi=1.0;
      for(int iak=0;iak<(bj-ibk);iak++)phi=phi*S_a(iak); //cum survival of mom 
      tot_prob2 += m_a(ibk-bi-1)*f_a(bj-ibk)*N_a_yrk(0)*phi/tot_repro_k;
    }
    tot_prob2 = tot_prob2 * 2.0 / tot_repro_j;    //4/tot_repro_j factors out of summation multiply that at the end
  }
  tot_prob = tot_prob+tot_prob2;
  
  return(tot_prob);
}


template<class Type>
vector<Type> get_S_RAW(Type eta1, Type eta2, Type eta3, int n_ages){
  vector<Type> S_a(n_ages);
  Type eta2_inv = 1/eta2;
  for(int i=0;i<n_ages;i++){
    int a = i+1;
    S_a(i) = exp(-pow(a*eta1,eta2) - pow(a*eta1,eta2_inv) - eta3*a);
  }
  return S_a;
}


template<class Type>
Type objective_function<Type>::operator() ()
{
  using namespace Eigen;  
  using namespace density;
  
  // Data
  DATA_INTEGER( n_yrs );  //number of years modeled
  DATA_INTEGER( n_yrs_data ); //span of years genetic sampling conducted
  DATA_INTEGER( n_seals );
  DATA_INTEGER( n_ages );
  DATA_VECTOR( Male_mat );  //male maturity-at-age vector
  DATA_VECTOR(Fem_fec);  //female fecundity-at-age vector
  DATA_MATRIX(A);  //Leslie matrix model (survival will be replaced each likelihood evaluation)
  DATA_ARRAY(n_match_HSGGP_sibidibjmij); // half sib + GGP matches by older animal sex, birth year of oldest, death year old oldest, birth year of youngest, and whether they share mtDNA or not
  DATA_ARRAY(n_comp_HSGGP_sibidibj); // number of half sib + GGP comparisons 
  DATA_ARRAY(n_match_MPO_bidibj); // maternal parent-offspring matches organized by birth of mother, death of mother, birth of offspring
  DATA_ARRAY(n_match_PPO_bidibj); // paternal parent-offspring matches 
  DATA_ARRAY(n_comp_MPO_bidibj); // maternal parent-offspring comparisons organized by birth of mother, death of mother, birth of offspring
  DATA_ARRAY(n_comp_PPO_bidibj); // paternal parent-offspring comparisons 
  DATA_SCALAR(mu_log_eta1);  //mean of eta1 prior
  DATA_SCALAR(mu_log_eta2);  //mean of eta2 prior
  DATA_SCALAR(mu_log_eta3);  //mean of eta3 prior
  DATA_SCALAR(sd_log_eta1);  //sd of eta1 prior
  DATA_SCALAR(sd_log_eta2);  //sd of eta2 prior
  DATA_SCALAR(sd_log_eta3);  //sd of eta3 prior
  DATA_SCALAR(lambda_expect); // lambda to match during optimization
  DATA_INTEGER(min_repro_fem); //index of Fem_fec for first value >0 (for increased efficiency in GGP calcs)
  DATA_INTEGER(min_repro_male);
  
  PARAMETER(n0_log); //number of age 0, year 1
  PARAMETER(log_eta1);
  PARAMETER(log_eta2);
  PARAMETER(log_eta3);
  
  vector<Type> N(n_yrs);
  Type eta1 = exp(log_eta1);
  Type eta2 = exp(log_eta2);
  Type eta3 = exp(log_eta3);

  vector<Type> Surv_a = get_S_RAW(eta1,eta2,eta3,n_ages+1); //survival function on (0,a)
  vector<Type> S_a(n_ages);
  S_a(0)=Surv_a(0);
  for(int iage=1;iage<n_ages;iage++)S_a(iage)=Surv_a(iage)/(Surv_a(iage-1));  //annual survival-at-age vector
  
  //fill in leslie matrix with survival values
  for(int iage=0; iage<(n_ages-1); iage++){
    A(iage+1,iage)=S_a(iage); //assume post-breeding census; fecundity already filled in and assumed fixed
  }

  //fill in N-at-age matrix
  matrix<Type> N_a(n_yrs,n_ages);
  //need some stable stage stuff for year 0
  Type min_n0=10000.0;
  N_a(0,0)=min_n0+exp(n0_log); //try to prevent numerical issues w/ pop crashing during optimization
  Type lam_power=1.0;
  for(int iage=1; iage<n_ages;iage++){  //stable stage calc using expected lambda
    lam_power = lam_power*lambda_expect;  
    N_a(0,iage)=N_a(0,iage-1)*S_a(iage-1)/lam_power;
  }
  for(int iyr=1; iyr<n_yrs;iyr++)N_a.row(iyr)=A * N_a.row(iyr-1).transpose();  //double check!!!!

  //fill probability lookup tables
  array<Type> MPO_table(n_yrs,n_yrs_data,n_yrs); //dimensions are parent birth year, parent death year, offspring birth year
  array<Type> PPO_table(n_yrs,n_yrs_data,n_yrs); //dimensions are parent birth year, parent death year, offspring birth year
  matrix<Type> PHS_table(n_yrs,n_yrs); //dimensions are ind i's birth year, ind j's birth year
  matrix<Type> MHS_table(n_yrs,n_yrs); //dimensions are ind i's birth year, ind j's birth year
  array<Type> GGP_table(2,n_yrs,n_yrs_data,n_yrs,2);  // 2 and 2 are sex of i, mtDNA=0 or 1
  vector<Type>N_a_yri(n_ages);
  vector<Type>N_a_yrj(n_ages);
  vector<Type>N_a_yri_min1(n_ages);
  vector<Type>N_a_yrj_min1(n_ages);
  for(int ibi=1;ibi<(n_yrs-1);ibi++){ //need access to previous year abundance for male probs
    for(int ibj=ibi+1; ibj<std::min(n_yrs,ibi+n_ages); ibj++){
      int delta_yr = ibj-ibi;
      //std::cout<<ibi<<" "<<ibj<<"\n";
      N_a_yri=N_a.row(ibi);
      N_a_yri_min1 = N_a.row(ibi-1);
      N_a_yrj=N_a.row(ibj);
      N_a_yrj_min1 = N_a.row(ibj-1);
      PHS_table(ibi,ibj)=get_PHS_prob(n_ages,delta_yr,N_a_yri_min1,N_a_yrj_min1,S_a,Male_mat);
      MHS_table(ibi,ibj)=get_MHS_prob(n_ages,delta_yr,N_a_yri,N_a_yrj,S_a,Fem_fec);
      for(int idi=0;idi<n_yrs_data;idi++){
        int dy = idi+n_ages;
        GGP_table(0,ibi,idi,ibj,1)=get_f_mt_GGP_prob(n_ages,ibi,ibj,dy,min_repro_fem,N_a,S_a,Fem_fec);
        GGP_table(0,ibi,idi,ibj,0)=get_f_nomt_GGP_prob(n_ages,ibi,ibj,dy,min_repro_fem,min_repro_male,N_a,S_a,Fem_fec,Male_mat);
        GGP_table(1,ibi,idi,ibj,1)=0.0;
        GGP_table(1,ibi,idi,ibj,0)=get_m_nomt_GGP_prob(n_ages,ibi,ibj,dy,min_repro_fem,min_repro_male,N_a,S_a,Fem_fec,Male_mat);
        MPO_table(ibi,idi,ibj)=get_MPO_prob(delta_yr,ibi,dy,Fem_fec,N_a_yri); //in this case delta_yr = age of parent
        PPO_table(ibi,idi,ibj)=get_PPO_prob(delta_yr-1,ibi-1,dy,Male_mat,N_a_yri_min1); //a year earlier since breeding occurs ~11 months before pups born
      }
    }
    int delta_yr = 0;
    vector<Type>N_a_yri_min1=N_a.row(ibi-1);
    PHS_table(ibi,ibi)=get_PHS_prob(n_ages,delta_yr,N_a_yri_min1,N_a_yri_min1,S_a,Male_mat);
  }

  //likelihood
  array<Type> LogL_table(2,n_yrs,n_yrs_data,n_yrs,2);
  Type logl = 0;
  for(int ibi=1;ibi<(n_yrs-1);ibi++){  //start at 1 since PPO,PHS need access to abundance the year before
    for(int ibj=(ibi+1);ibj<std::min(n_yrs,ibi+n_ages);ibj++){
      for(int idi = 0; idi<n_yrs_data; idi++){
        for(int isi=0; isi<2;isi++){
          LogL_table(isi,ibi,idi,ibj,0)=dbinom_kern_log(n_comp_HSGGP_sibidibj(isi,ibi,idi,ibj),n_match_HSGGP_sibidibjmij(isi,ibi,idi,ibj,0),PHS_table(ibi,ibj)+GGP_table(isi,ibi,idi,ibj,0)); //HSPs + GGPs
          LogL_table(isi,ibi,idi,ibj,1)=dbinom_kern_log(n_comp_HSGGP_sibidibj(isi,ibi,idi,ibj),n_match_HSGGP_sibidibjmij(isi,ibi,idi,ibj,1),MHS_table(ibi,ibj)+GGP_table(isi,ibi,idi,ibj,1)); //HSPs + GGPs
          logl += dbinom_kern_log(n_comp_HSGGP_sibidibj(isi,ibi,idi,ibj),n_match_HSGGP_sibidibjmij(isi,ibi,idi,ibj,0),PHS_table(ibi,ibj)+GGP_table(isi,ibi,idi,ibj,0)); //HSPs + GGPs
          logl += dbinom_kern_log(n_comp_HSGGP_sibidibj(isi,ibi,idi,ibj),n_match_HSGGP_sibidibjmij(isi,ibi,idi,ibj,1),MHS_table(ibi,ibj)+GGP_table(isi,ibi,idi,ibj,1)); //HSPs + GGPs
        } 
        logl += dbinom_kern_log(n_comp_PPO_bidibj(ibi,idi,ibj),n_match_PPO_bidibj(ibi,idi,ibj),PPO_table(ibi,idi,ibj)); //POPs
        logl += dbinom_kern_log(n_comp_MPO_bidibj(ibi,idi,ibj),n_match_MPO_bidibj(ibi,idi,ibj),MPO_table(ibi,idi,ibj)); //POPs
      }
    }
    for(int isi=0; isi<2; isi++){
      for(int idi=0;idi<n_yrs_data;idi++){
        LogL_table(isi,ibi,idi,ibi,0)=dbinom_kern_log(n_comp_HSGGP_sibidibj(isi,ibi,idi,ibi),n_match_HSGGP_sibidibjmij(isi,ibi,idi,ibi,0),PHS_table(ibi,ibi)); //HSPs equal birth year
        logl += dbinom_kern_log(n_comp_HSGGP_sibidibj(isi,ibi,idi,ibi),n_match_HSGGP_sibidibjmij(isi,ibi,idi,ibi,0),PHS_table(ibi,ibi)); //HSPs equal birth year
      }
    }
  }
  for(int isi=0; isi<2; isi++){
    for(int idi=0;idi<n_yrs_data;idi++){
      LogL_table(isi,n_yrs-1,idi,n_yrs-1,0)=dbinom_kern_log(n_comp_HSGGP_sibidibj(isi,n_yrs-1,idi,n_yrs-1),n_match_HSGGP_sibidibjmij(isi,n_yrs-1,idi,n_yrs-1,0),PHS_table(n_yrs-1,n_yrs-1)); //HSPs
      logl += dbinom_kern_log(n_comp_HSGGP_sibidibj(isi,n_yrs-1,idi,n_yrs-1),n_match_HSGGP_sibidibjmij(isi,n_yrs-1,idi,n_yrs-1,0),PHS_table(n_yrs-1,n_yrs-1)); //HSPs
    }
  }
  Type logl1= logl;

  for(int iy=0;iy<n_yrs;iy++)N(iy)=N_a.row(iy).sum();

  // //priors / penalty
  Type lambda = pow(N_a.row(n_yrs-1).sum()/N_a.row(0).sum(),1.0/(n_yrs-1));
  logl -= 0.5 * pow((lambda-lambda_expect)/0.00001,2.0);  //pop growth prior; log(kernel of normal pdf)
  //logl -= 0.5 * pow((log_eta1-mu_log_eta1)/sd_log_eta1,2.0);
  //logl -= 0.5 * pow((log_eta2-mu_log_eta2)/sd_log_eta2,2.0);
  //logl -= 0.5 * pow((log_eta3-mu_log_eta3)/sd_log_eta3,2.0);
  logl += dnorm(log_eta1,mu_log_eta1,sd_log_eta1,1);
  logl += dnorm(log_eta2,mu_log_eta2,sd_log_eta2,1);
  logl += dnorm(log_eta3,mu_log_eta3,sd_log_eta3,1);
  
  // 
  // //to get access to most recent values computed from arguments passed to the function
  REPORT(PPO_table);
  REPORT(PHS_table);
  REPORT(MPO_table);
  REPORT(MHS_table);
  REPORT(GGP_table);
  REPORT(N);
  REPORT(S_a);
  REPORT(eta1);
  REPORT(eta2);
  REPORT(eta3);
  REPORT(lambda);
  REPORT(logl);
  REPORT(logl1);
  REPORT(LogL_table);

  //things you want standard errors of
  ADREPORT( N );
  ADREPORT( S_a );
  ADREPORT( eta1 );
  ADREPORT( eta2 );
  ADREPORT( eta3 )
    
  REPORT(N_a);
  REPORT(A);
  REPORT(n_comp_PPO_bidibj);
  REPORT(n_match_PPO_bidibj);
  REPORT(n_comp_MPO_bidibj);
  REPORT(n_match_MPO_bidibj);


  
  return -logl;
}
