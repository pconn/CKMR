// ----------------------------------------------------------------------------
// Bearded2.hpp
// ----------------------------------------------------------------------------

#ifndef __Bearded2_HPP__
#define __Bearded2_HPP__


#include <adtarrays.hpp>
#include "adtR.hpp"


// ----------------------------------------------------------------------------

class Bearded2 : public AdtArrays
{
protected:
  /* AD_LIBNAME Bearded2 */
  /* AD_ALIAS Bd=DBearded2 */
  /* AUTOINIT 1 */
  // ... IE stuff passed in from R
  int first_y;
  int first_y_sample;
  int last_y;
  int n_par;
  int n_samp;  // individuals genotyped
  int n_POP;   // pairs actually found
  int n_HS;    // number of half sibs found
  int n_ages;  //number of age classes
  int amat;    // age-at-maturity (just for summary statistics at this point)
  //double a_mean; 
  //double b_mean;
  //double c_mean;
  //double haz_mult;
  //double wt_a;  //weight on RAW 'a' prior
  //double wt_b; //weight on RAW 'b' prior
  //double wt_c;   //ibid

  ARRAY_1I tcap/* n_samp */;     // year of capture/sampling
  ARRAY_1I a/* n_samp */;     // age at capture
  ARRAY_1I sex/* n_samp */; // sex (0 = female, 1  = male)
  ARRAY_3D m_tas/* first_y_sample:last_y, 1:n_ages, 0:1 */;
  ARRAY_1I isamp_POP/* n_POP */;   // sample-index of first animal in this POP
  ARRAY_1I jsamp_POP/* n_POP */;   // ditto for second
  ARRAY_1I isamp_HS/* n_HS */;   // sample-index of first animal in this HS
  ARRAY_1I jsamp_HS/* n_HS */;   // ditto for second
  ARRAY_1I sex_HS/* n_HS */;   // parental sex of half-sibs
  //ARRAY_2D Fec_as/* 1:n_ages,0:1 */; //Fecundity by age and sex (# expected female offspring)
  ARRAY_1D Mu_eta/* 1:3 */; //mean of log scale RAW survival prior
  ARRAY_1D SD_eta/* 1:3 */; //sd of prior
  ARRAY_2D Mu_fec/* 1:2, 1:2 */; //mean of logistic fecundity params (real scale) [sex, param]
  ARRAY_2D SD_fec/* 1:2, 1:2 */; //SD of logistic fecundity params [sex, param]

  /* AUTODEC 1 */
  // Things calculated in C
  double R0;     // # new recruits of 1 sex at time 1 (assume 50:50 sex ratio)
  double a_haz;      // a,b,c are reduced additive Weibull parameters (see Choquet et al. 2011 MEE)
  double b_haz;     
  double c_haz;
  double k_fem;
  double k_male;
  double f50_fem;
  double f50_male;

  int nextpari;

  // Data summaries, set up during the constructor
  // NB: my convention is that the name of any array >=2D ends with the indices
  // ... 1D arrays I sometimes don't bother

  ARRAY_1I by/* n_samp */;
  ARRAY_1I ymat_atmost/* n_samp */;
  ARRAY_4D n_comps_ytbs /* first_y:last_y, first_y:last_y, first_y:last_y, 0:1 */;
  //ARRAY_4I n_comps_ytbs2 /* first_y:last_y, first_y:last_y, first_y:last_y, 0:1 */;
  ARRAY_4I n_match_ytbs /* first_y:last_y, first_y:last_y, first_y:last_y, 0:1 */;
  ARRAY_4D exp_match_ytbs /* first_y:last_y, first_y:last_y, first_y:last_y, 0:1 */;

  ARRAY_3D n_hs_comps_bbs /* first_y:last_y, first_y:last_y, 0:1 */;
  ARRAY_3I n_hs_match_bbs /* first_y:last_y, first_y:last_y, 0:1 */;


  // now some workspace things
  ARRAY_4D Pr_PO_ytbs/* first_y:last_y, first_y:last_y, first_y:last_y,0:1 */;
  ARRAY_3D Pr_HS_bbs/* first_y:last_y, first_y:last_y,0:1 */;
  ARRAY_4D sqrt_Pr_PO_ytbs /* first_y:last_y, first_y:last_y, first_y:last_y,0:1 */; // design only
  ARRAY_3D sqrt_Pr_HS_bbs /* first_y:last_y, first_y:last_y, 0:1 */; // design only
  ARRAY_3D rel_repro_yas /* first_y:last_y,1:n_ages, 0:1 */;
  ARRAY_3D N_yas /* first_y:last_y,1:n_ages, 0:1 */;
  ARRAY_3D N_yas_breed /* first_y:last_y,1:n_ages, 0:1 */;
  ARRAY_1D temp_pars/* n_par */;
  ARRAY_3D S_aij/* 1:n_ages,first_y:last_y,first_y:last_y */;
  ARRAY_2D Fec_as/* 1:n_ages,0:1 */; //Fecundity by age and sex (# expected female offspring)


  // Could have AUTOINIT 2 and AUTODEC 2 and AUTOINIT 3 etc here
  // ... needed iff array dims depend on calculations to be done during constructor

#include "Bd_array_plans.hpp"

public:
  Bearded2(
#include "Bd_constructor_args.hpp"
  );

  virtual ~Bearded2();

  // Now you need to manually include the headers of your own functions
  // This error-prone and rather pointless step could be automated... ADR used to !
  virtual void make_data_summaries();
  virtual void unpack(
      const ARRAY_1D pars/*n_par*/
    );
  double next_param();
  virtual void populate( int dummy);
  virtual void calc_probs( int dummy);
  virtual void calc_n_comps( const ARRAY_3D mm_tas/* first_y_sample:last_y, 1:n_ages, 0:1 */);
  // Only if FITTING
  virtual double lglk(
      const ARRAY_1D pars/*n_par*/
    );

  // Only if DESIGN
  virtual void sqrt_probs(
      const ARRAY_1D pars/* n_par */
    );

}; // class definition

// Support routine; this and dr_n_log_p should be part of ADT maths lib, with black-box too
double n_log_p(
  const int n,
  const double p);



#endif  //__Bearded2_HPP__
