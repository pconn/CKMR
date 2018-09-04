// ----------------------------------------------------------------------------
// Bearded2.cpp
// ----------------------------------------------------------------------------
// BasiCKMR: single-sex boring-adulthood known-age POP-only (MDP) CKMR
// assumes long-term exponential growth/decline in Number-of-adults

#include "Bearded2.hpp"
#include <R.h>


// ----------------------------------------------------------------------------


// CONSTRUCTOR: you may not need to change this, if your data all comes from...
// R in one single hit
Bearded2::Bearded2(
#include "Bd_constructor_args.hpp"
)
 : AdtArrays()
{

  // include-files below are auto-generated by ADT based on the dot-hpp
  // Next line may bomb if no constructor-locals (used to; maybe fixed now)
  #include "Bd_constructor_locals.hpp"

  // Always need these two
  #include "Bd_constructor_scalars_phase_1.hpp"
  #include "Bd_constructor_arrays_phase_1.hpp"

  // Now you can do some calculations to work out further array dims...
  // that depend on stuff just passed in. Then:
  // eg  #include "Bd_constructor_arrays_phase_2.hpp"
  // etc. Might as well pass in all scalars during PHASE 1 though
  // NB PHASES are defined in the dot-hpp

  // Could do data-summary calcs here
  // but NB *no* bounds-checks inside the constructor (for good reason)
  // so I've put them into a separate function
  // Hmmm, should check: ?arrays that need to be precalced...
  // before array_plans_init

  // make_data_summaries(); Has to be called OUTSIDE the constructor at present... ADT / ViStu thing

  #include "Bd_array_plans_init.hpp"
}; // constructor

void Bearded2::make_data_summaries()
{
  int i_samp, j_samp, this_by, this_oby, this_capt, this_pby,this_maty,this_sex,i_POP;
  
   // compute birth years for each sampled animal
  for( i_samp = 1; i_samp <= n_samp; i_samp++) {
    this_by = tcap[ i_samp] - a[ i_samp];
    by[ i_samp] = this_by;

    // For i_samp as possible parent, need year of maturity...
    // or, if that's < first_y, just use first_y...
	ymat_atmost[ i_samp] = max( first_y, this_by + amat);  //note: we'll need to avoid doing comparisons where parent and offspring are both "born" in first_y
  }; // i_samp

  // Number of comparisons. Here we are treating PO as DIRECTIONAL, ie
  // 1st animal in the pair must be the Parent, and 2nd animal the Offspring
  // Look at calc_probs code first to understand why these variables are use
  
  //  comparisons by parent birth year [y], parent death year [t], offspring birth year [b], 
  //  sex [s] (0 = female), and whether there is a match or not [m]
  zero(n_comps_ytbsm);

  for (i_samp = 1; i_samp < n_samp;i_samp++) {
    for( j_samp = i_samp+1; j_samp<=n_samp; j_samp++){
		// In this case, exclude comps where adult caught in year of juve birth...
		// depends on biol & sampling
		// First case: i is P, j is O
		this_oby = by[j_samp];
		this_pby = by[i_samp];
		this_capt = tcap[i_samp];
		this_maty = ymat_atmost[i_samp];
		this_sex = sex[i_samp];

		// exclude born-in-year-of-cap - this will also remove case where offspring born <= year 1
		if ((this_oby >= this_maty) && (this_maty <= last_y) && (this_oby<this_capt) && (this_oby != this_capt)) {
			n_comps_ytbsm[this_pby][this_capt][this_oby][this_sex][0] += 1;
		}

		// Second case: i is O, j is P
		this_oby = by[i_samp];
		this_pby = by[j_samp];
		this_capt = tcap[j_samp];
		this_maty = ymat_atmost[j_samp];
		this_sex = sex[j_samp];

		// exclude born-in-year-of-cap - this will also remove case where offspring born <= year 1
		if ((this_oby >= this_maty) && (this_maty <= last_y) && (this_oby<this_capt) && (this_oby != this_capt)) {
			n_comps_ytbsm[this_pby][this_capt][this_oby][this_sex][0] += 1;
		}
	} // jsamp
  } // isamp

  for (i_POP = 1; i_POP < n_POP; i_POP++) {
	i_samp = isamp_POP[i_POP];
	j_samp = jsamp_POP[i_POP];

	// First case: i is P, j is O
	this_oby = by[j_samp];
	this_pby = by[i_samp];
	this_capt = tcap[i_samp];
	this_maty = ymat_atmost[i_samp];
	this_sex = sex[i_samp];

	// exclude born-in-year-of-cap - this will also remove case where offspring born <= year 1
	if ((this_oby >= this_maty) && (this_maty <= last_y) && (this_oby<this_capt) && (this_oby != this_capt)) {
		n_comps_ytbsm[this_pby][this_capt][this_oby][this_sex][0] -= 1;  //have to take away from negative comparisons 
		n_comps_ytbsm[this_pby][this_capt][this_oby][this_sex][1] += 1;
	}

	// Second case: i is O, j is P
	this_oby = by[i_samp];
	this_pby = by[j_samp];
	this_capt = tcap[j_samp];
	this_maty = ymat_atmost[j_samp];
	this_sex = sex[j_samp];

	// exclude born-in-year-of-cap - this will also remove case where offspring born <= year 1
	if ((this_oby >= this_maty) && (this_maty <= last_y) && (this_oby<this_capt) && (this_oby != this_capt)) {
		n_comps_ytbsm[this_pby][this_capt][this_oby][this_sex][0] -= 1;  //have to take away from negative comparisons 
		n_comps_ytbsm[this_pby][this_capt][this_oby][this_sex][1] += 1;
	}
  } // i_POP

  // ... NB I don't mind using if's in the constructor, since it's only run once
  // ... in lglk code, one_if() is faster

}; // make_data_summaries

// ----------------------------------------------------------------------------

// Unpack R parameter-vector into meaningful pop dyn params
void Bearded2::unpack(
  const ARRAY_1D pars/*n_par*/
){
  int i;

  // Surely there is a copy-style function in ADT/C ? No doc of it tho
  // ADT Pascal has one
  for ( i = 1; i <= n_par; i++) {
    temp_pars[ i] = pars[ i];
  }
  nextpari = 1;

  roi = exp( next_param());
  N0_f = exp( next_param());
  N0_m = exp(next_param());

  // Hide the next bit from  ADT; for one thing, strings aren't understood...
  // but there never any reason to AD this, so don't
  #ifndef AD
  if( nextpari != n_par+1) {
    Rf_error( "Wrong number of parameters was extracted in unpack...");
    // ... and that's how you signal an error
  };
  #endif
}; // unpack

// Helper for unpack
double Bearded2::next_param() {
  double val;
  ////
  val = temp_pars[ nextpari];
  nextpari += 1;
  return(val);
}; // next_param

// ---------------------------------------------------------------------------

// Fill in pop dyn from parameters. Age-structured version is more interesting
void Bearded2::populate(
  int dummy
){
  int y,isex;

  N_ys[first_y][0] = N0_f;
  N_ys[first_y][1] = N0_m;
  for( y = first_y+1; y <= last_y; y++){
	for (isex = 0; isex <= 1; isex++) {
		N_ys[y][isex] = N_ys[y-1][isex] * roi;
	} //isex
  } //y

  // Might as well do Total Reprod Output here in populate(), though...
  // could also do in calc_probs. Actually we just need the inverse
  for( y = first_y; y <= last_y; y++){
	  for (isex = 0; isex <= 1; isex++) {
		  inv_totfec_ys[y][isex] = 1.0 / N_ys[y][isex];
	  } //isex
  }  //y
} // populate

// ---------------------------------------------------------------------------

// All CKMR probs
void Bearded2::calc_probs(
  int dummy
){
  int pby, pdy, pcapt, pmaty, isex, oby;
  ////

  zero( Pr_PO_ytbs);

  for( pby = first_y; pby <= last_y; pby++){
	for (pcapt = first_y_sample; pcapt <= last_y; pcapt++) {
      for( oby = first_y; oby <= last_y; oby++){
		  for (isex = 0; isex <= 1; isex++) {
			  pmaty = pby + amat;
			  Pr_PO_ytbs[pby][pcapt][oby][isex] =
				  one_if(pmaty <= oby) * one_if(pcapt > oby) * one_if((pcapt-pby) <= 38)*one_if((pby - oby) <= 38) * inv_totfec_ys[oby][isex];
		  } //isex
      } // oby
    } // pcapt
  } // pmaty
} // calc_probs

// ----------------------------------------------------------------------------

// Log-likelihood
double Bearded2::lglk(
  const ARRAY_1D pars/* n_par */
){
  int pby, pcapt, oby, isex;
  double tot_lglk;
  ////

  unpack(pars);
  populate(0); // dummy arg
  calc_probs(0);

  tot_lglk = 0;


  for (pby = first_y; pby <= last_y; pby++) {
	  for (pcapt = first_y; pcapt <= last_y; pcapt++) {
		  for (oby = first_y; oby <= last_y; oby++) {  
			  for (isex = 0; isex <= 1; isex++) {
				  // Poisson approximation: fine if N is fairly big
				  /*
				  tot_lglk +=
					-n_comps_ytb[pmaty][pcapt][oby] *
					Pr_PO_ytb[pmaty][pcapt][oby]
					+ n_log_p(
						n_PO_ytb[pmaty][pcapt][oby],
						n_comps_ytb[pmaty][pcapt][oby] *
						Pr_PO_ytb[pmaty][pcapt][oby]
					);
				  */
				  tot_lglk += n_log_p(n_comps_ytbsm[pby][pcapt][oby][isex][0],
					  1 - Pr_PO_ytbs[pby][pcapt][oby][isex]);
			  } //isex
		  } // oby
	  } // pcapt
  } // pmaty

  for (pby = first_y; pby <= last_y; pby++) {
	  for (pcapt = first_y; pcapt <= last_y; pcapt++) {
		  for (oby = first_y; oby <= last_y; oby++) {  
			  for(isex = 0; isex <= 1; isex++){
			    tot_lglk += n_log_p( n_comps_ytbsm[ pby][ pcapt][ oby][isex][1],
			        Pr_PO_ytbs[ pby][ pcapt][ oby][isex]);
			  } // isex
		  } // oby
	  } // pcapt
  } // pmaty
  // Binomial version could be:
  // tot_lglk += n_log_p( n_PO_ytb[ pmaty][ pcapt][ oby],
  //      Pr_PO_ytb[ pmaty][ pcapt][ oby]) +
  //    n_log_p( n_comps_ytb[ pmaty][ pcapt][ oby] - n_PO_ytb[ pmaty][ pcapt][ oby],
  //      1-Pr_PO_ytb[ pmaty][ pcapt][ oby]);

  // Bin version *without* n_log_p needs if-statements to avoid log(0)
  // and should use log1p( -Pr_PO_ytb[ pmaty][ pcapt][ oby])
  // otherwise you can get rounding problems when N is large.
  // You have been warned !

  if (tot_lglk != tot_lglk) {
	  isex = 2;
  }
return( tot_lglk);
}; // lglk


// ----------------------------------------------------------------------------

// sqrt of all CKMR probs--- needed iff DESIGNcopy
void Bearded2::sqrt_probs(
  const ARRAY_1D pars/* n_par */
){
  int pby, pcapt, oby,isex;
  ////

  unpack(pars);
  populate( 0); // dummy arg; ADT bug
  calc_probs( 0);
  zero(sqrt_Pr_PO_ytbs);

  for( pby = first_y; pby <= last_y; pby++){
    for( pcapt = first_y ; pcapt <= last_y; pcapt++){
      for( oby = first_y ; oby <= last_y; oby++){
		  for (isex = 0; isex <= 1; isex++) {
			  sqrt_Pr_PO_ytbs[pby][pcapt][oby][isex] = sqrt(Pr_PO_ytbs[pby][pcapt][oby][isex]);
		  }
      }
    }
  }
} // sqrt_probs

// ----------------------------------------------------------------------------
// Destructor: leave this alone
Bearded2::~Bearded2(){}; // destructor

// ----------------------------------------------------------------------------
// Support routine; this and dr_n_log_p should be part of ADT maths lib, with black-box too
double n_log_p(
  const int n,
  const double p)
{
  return( n * log( p + one_if( p==0)));
}; // n_log_p


