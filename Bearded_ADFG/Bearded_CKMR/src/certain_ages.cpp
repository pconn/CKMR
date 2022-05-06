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
  DATA_MATRIX(n_match_PHS_bibj); // paternal half sib matches, organized by birth year of oldest, youngest
  DATA_MATRIX(n_match_MHS_bibj); // same, maternal half sibs
  DATA_MATRIX(n_comp_HS_bibj); // number of half sib comparisons
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
  //need some stable stage stuff for year 0;
  Type min_n0=10000.0;
  N_a(0,0)=min_n0+exp(n0_log); //try to prevent numerical issues w/ pop crashing during optimization
  for(int iage=1; iage<n_ages;iage++)N_a(0,iage)=N_a(0,iage-1)*S_a(iage-1);
  for(int iyr=1; iyr<n_yrs;iyr++)N_a.row(iyr)=A * N_a.row(iyr-1).transpose();  //double check!!!!

  //fill probability lookup tables
  int n_b_yrs = n_ages+n_yrs_data;
  int n_age2 = n_ages*2;
  array<Type> MPO_table(n_b_yrs,n_yrs_data,n_b_yrs); //dimensions are parent birth year, parent death year, offspring birth year
  array<Type> PPO_table(n_b_yrs,n_yrs_data,n_b_yrs); //dimensions are parent birth year, parent death year, offspring birth year
  matrix<Type> PHS_table(n_b_yrs,n_b_yrs); //dimensions are ind i's birth year, ind j's birth year
  matrix<Type> MHS_table(n_b_yrs,n_b_yrs); //dimensions are ind i's birth year, ind j's birth year
  vector<Type>N_a_yri(n_ages);
  vector<Type>N_a_yrj(n_ages);
  vector<Type>N_a_yri_min1(n_ages);
  vector<Type>N_a_yrj_min1(n_ages);
  for(int ibi=0;ibi<(n_b_yrs-1);ibi++){
    for(int ibj=ibi+1; ibj<std::min(n_b_yrs,ibi+n_ages); ibj++){
      int iyr = n_ages+ibi;
      int jyr = n_ages+ibj;
      int delta_yr = ibj-ibi;
      //std::cout<<ibi<<" "<<ibj<<"\n";
      N_a_yri=N_a.row(iyr);
      N_a_yri_min1 = N_a.row(iyr-1);
      N_a_yrj=N_a.row(jyr);
      N_a_yrj_min1 = N_a.row(jyr-1);
      PHS_table(ibi,ibj)=get_PHS_prob(n_ages,delta_yr,N_a_yri_min1,N_a_yrj_min1,S_a,Male_mat);
      MHS_table(ibi,ibj)=get_MHS_prob(n_ages,delta_yr,N_a_yri,N_a_yrj,S_a,Fem_fec);
      for(int idi=0;idi<n_yrs_data;idi++){
        int dy = idi+n_age2;
        MPO_table(ibi,idi,ibj)=get_MPO_prob(delta_yr,iyr,dy,Fem_fec,N_a_yri); //in this case delta_yr = age of parent
        PPO_table(ibi,idi,ibj)=get_PPO_prob(delta_yr-1,iyr-1,dy,Male_mat,N_a_yri_min1); //a year earlier since breeding occurs ~11 months before pups born
      }
    }
    int delta_yr = 0;
    vector<Type>N_a_yri_min1=N_a.row(n_ages+ibi-1);
    PHS_table(ibi,ibi)=get_PHS_prob(n_ages,delta_yr,N_a_yri_min1,N_a_yri_min1,S_a,Male_mat);
  }

  //likelihood
  Type logl = 0;
  for(int ibi=0;ibi<(n_b_yrs-1);ibi++){
    for(int ibj=(ibi+1);ibj<std::min(n_b_yrs,ibi+n_ages);ibj++){
      logl += dbinom_kern_log(n_comp_HS_bibj(ibi,ibj),n_match_PHS_bibj(ibi,ibj),PHS_table(ibi,ibj)); //HSPs
      logl += dbinom_kern_log(n_comp_HS_bibj(ibi,ibj),n_match_MHS_bibj(ibi,ibj),MHS_table(ibi,ibj)); //HSPs
      for(int idi = 0; idi<n_yrs_data; idi++){
        logl += dbinom_kern_log(n_comp_PPO_bidibj(ibi,idi,ibj),n_match_PPO_bidibj(ibi,idi,ibj),PPO_table(ibi,idi,ibj)); //POPs
        logl += dbinom_kern_log(n_comp_MPO_bidibj(ibi,idi,ibj),n_match_MPO_bidibj(ibi,idi,ibj),MPO_table(ibi,idi,ibj)); //POPs
      }
    }
    logl += dbinom_kern_log(n_comp_HS_bibj(ibi,ibi),n_match_PHS_bibj(ibi,ibi),PHS_table(ibi,ibi)); //HSPs
  }
  logl += dbinom_kern_log(n_comp_HS_bibj(n_b_yrs-1,n_b_yrs-1),n_match_PHS_bibj(n_b_yrs-1,n_b_yrs-1),PHS_table(n_b_yrs-1,n_b_yrs-1)); //HSPs

  
  for(int iy=0;iy<n_yrs;iy++)N(iy)=N_a.row(iy).sum();
  
  // //priors / penalty
  Type lambda = pow(N_a.row(n_yrs-1).sum()/N_a.row(0).sum(),1.0/(n_yrs-1));
  logl -= 0.5 * pow((lambda-1.0)/0.00001,2.0);  //stable pop prior; log(kernel of normal pdf)
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
  REPORT(N);
  REPORT(S_a);
  REPORT(eta1);
  REPORT(eta2);
  REPORT(eta3);
  REPORT(lambda);

  //things you want standard errors of
  ADREPORT( N );
  ADREPORT( S_a );
  ADREPORT( eta1 );
  ADREPORT( eta2 );
  ADREPORT( eta3 )
    
  REPORT(N_a);
  REPORT(n_comp_HS_bibj);
  REPORT(n_match_PHS_bibj);
  REPORT(n_match_MHS_bibj);
  REPORT(A);
  REPORT(n_comp_PPO_bidibj);
  REPORT(n_match_PPO_bidibj);
  REPORT(n_comp_MPO_bidibj);
  REPORT(n_match_MPO_bidibj);


  
  return -logl;
}
