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
  int amat;    // age-at-maturity; assumed 100% thereafter

  ARRAY_1I tcap/* n_samp */;     // year of capture/sampling
  ARRAY_1I a/* n_samp */;     // age at capture
  ARRAY_1I sex/* n_samp */; // sex (0 = female, 1  = male)
  ARRAY_1I isamp_POP/* n_POP */;   // sample-index of first animal in this POP
  ARRAY_1I jsamp_POP/* n_POP */;   // ditto for second


  /* AUTODEC 1 */
  // Things calculated in C
  double roi;     // proportional Rate Of Increase (ie 1 means constant)
  double N0_f;      // mature female abund in first_y
  double N0_m;     // mature male abund in first_y
  int nextpari;

  // Data summaries, set up during the constructor
  // NB: my convention is that the name of any array >=2D ends with the indices
  // ... 1D arrays I sometimes don't bother

  ARRAY_1I by/* n_samp */;
  ARRAY_1I ymat_atmost/* n_samp */;
  ARRAY_5I n_comps_ytbsm /* first_y:last_y, first_y:last_y, first_y:last_y, 0:1, 0:1 */;

  // now some workspace things
  ARRAY_4D Pr_PO_ytbs/* first_y:last_y, first_y:last_y, first_y:last_y,0:1 */;
  ARRAY_4D sqrt_Pr_PO_ytbs /* first_y:last_y, first_y:last_y, first_y:last_y,0:1 */; // design only
  ARRAY_2D inv_totfec_ys /* first_y:last_y, 0:1 */;
  ARRAY_2D N_ys /* first_y:last_y, 0:1 */;
  ARRAY_1D temp_pars/* n_par */;

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
