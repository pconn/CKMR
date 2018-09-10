//  ----------------------------------------------------------------------------
//  ADT generated header defining class DBearded2
//  ----------------------------------------------------------------------------


#ifndef __DBearded2_HPP
#define __DBearded2_HPP


#include "Bearded2.hpp"


class DBearded2  : public Bearded2
{
protected: 
  
  ARRAY_2D inv_totfec_ysb1_pars/* first_y:last_y,0:1 */;
  double n0_fb1_pars;
  double n0_mb1_pars;
  ARRAY_2D n_ysb1_pars/* first_y:last_y,0:1 */;
  ARRAY_4D pr_hs_ybbsb1_pars/* first_y:last_y,first_y:last_y,first_y:last_y,0:1 */;
  ARRAY_4D pr_po_ytbsb1_pars/* first_y:last_y,first_y:last_y,first_y:last_y,0:1 */;
  double roib1_pars;
  ARRAY_3D s_yijb1_pars/* first_y:last_y,first_y:last_y,first_y:last_y */;
  double survb1_pars;
  ARRAY_1D temp_parsb1_pars/* n_par */;
  ARRAY_1I i4stack_2_1/* dim_stack */;
  int i4stack_2_1i;
  ARRAY_1D r4stack_2_1/* dim_stack */;
  int r4stack_2_1i;
  ARRAY_1I i4stack_3_1/* dim_stack */;
  int i4stack_3_1i;
  ARRAY_1I i4stack_4_1/* dim_stack */;
  int i4stack_4_1i;
  ARRAY_1D r4stack_4_1/* dim_stack */;
  int r4stack_4_1i;
  ARRAY_1I i4stack_5_1/* dim_stack */;
  int i4stack_5_1i;
  ARRAY_1D r8stack_5_1/* dim_stack */;
  int r8stack_5_1i;
  //  b_mort = exp(next_param());
  //  c_mort = exp(next_param());
  //  d_mort = exp(next_param());
  //   Hide the next bit from  ADT; for one thing, strings aren't understood...
  //   but there never any reason to AD this, so don't
  //   unpack
  //   Helper for unpack
  double NEXT_PARAM_CB();
  //   Differentiation of bearded2__calc_probs in reverse (adjoint) mode:
  //    gradient     of useful results: pr_hs_ybbs pr_po_ytbs
  //    with respect to varying inputs: s_yij inv_totfec_ys
  //  ----------------------------------------------------------------------------
  //   populate
  //   ---------------------------------------------------------------------------
  //   All CKMR probs
  void CALC_PROBS_BPARS(int dummy);
  //   Differentiation of bearded2__populate in reverse (adjoint) mode:
  //    gradient     of useful results: s_yij inv_totfec_ys
  //    with respect to varying inputs: roi surv n0_f n0_m
  //   next_param
  //   ---------------------------------------------------------------------------
  //   Fill in pop dyn from parameters. Age-structured version is more interesting
  void POPULATE_BPARS(int dummy);
  //   Differentiation of bearded2__unpack in reverse (adjoint) mode:
  //    gradient     of useful results: roi surv n0_f n0_m
  //    with respect to varying inputs: pars
  //   i_HS
  //   ... NB I don't mind using if's in the constructor, since it's only run once
  //   ... in lglk code, one_if() is faster
  //   make_data_summaries
  //   ----------------------------------------------------------------------------
  //   Unpack R parameter-vector into meaningful pop dyn params
  void UNPACK_BPARS(const ARRAY_1D pars/* n_par */, ARRAY_1D parsb1_pars/* n_par */);
  //   Differentiation of bearded2__next_param in reverse (adjoint) mode:
  //    gradient     of useful results: temp_pars bearded2__next_param
  //    with respect to varying inputs: temp_pars
  //  b_mort = exp(next_param());
  //  c_mort = exp(next_param());
  //  d_mort = exp(next_param());
  //   Hide the next bit from  ADT; for one thing, strings aren't understood...
  //   but there never any reason to AD this, so don't
  //   unpack
  //   Helper for unpack
  void NEXT_PARAM_BPARS(double& next_paramb1_pars);
  //   i_HS
  //   ... NB I don't mind using if's in the constructor, since it's only run once
  //   ... in lglk code, one_if() is faster
  //   make_data_summaries
  //   ----------------------------------------------------------------------------
  //   Unpack R parameter-vector into meaningful pop dyn params
  void UNPACK_CB(const ARRAY_1D pars/* n_par */);
  //   Differentiation of n_log_p in reverse (adjoint) mode:
  //    gradient     of useful results: p n_log_p
  //    with respect to varying inputs: p
  //   ----------------------------------------------------------------------------
  //   Support routine; this and dr_n_log_p should be part of ADT maths lib, with black-box too
  void N_LOG_P_BPARS(int n, double p, double& pb1_pars, double& n_log_pb1_pars);
public: 
  
  #include "Bd_decl_lib_interface_methods.hpp"
  DBearded2(int arg_first_y, int arg_first_y_sample, int arg_last_y, int arg_n_par, int arg_n_samp, int arg_n_POP, int arg_n_HS, int arg_amat, const ARRAY_1I arg_tcap, const ARRAY_1I arg_a, const ARRAY_1I arg_sex, const ARRAY_1I arg_isamp_POP, const ARRAY_1I arg_jsamp_POP, const ARRAY_1I arg_isamp_HS, const ARRAY_1I arg_jsamp_HS, const ARRAY_1I arg_sex_HS);
  DBearded2(const DBearded2& rCopy);
  virtual ~DBearded2();
  //   Differentiation of bearded2__lglk in reverse (adjoint) mode:
  //    gradient     of useful results: bearded2__lglk
  //    with respect to varying inputs: pars
  //    RW status of diff variables: roi:(loc) s_yij:(loc) inv_totfec_ys:(loc)
  //                 pr_hs_ybbs:(loc) surv:(loc) n_ys:(loc) temp_pars:(loc)
  //                 n0_f:(loc) pr_po_ytbs:(loc) n0_m:(loc) bearded2__lglk:in-killed
  //                 pars:out
  //   calc_probs
  //   ----------------------------------------------------------------------------
  //   Log-likelihood
  void LGLK_BPARS(const ARRAY_1D pars/* n_par */, ARRAY_1D parsb1_pars/* n_par */, double& lglkb1_pars);
  
};


#include "Bd_decl_lib_interface_globals.hpp"
#include "Bd_decl_lib_interface_constructor.hpp"


#endif //__DBearded2_HPP

