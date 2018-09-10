
SEXP DBearded2::_get_a(SEXP sArgList) const
{
  SEXP Result = R_ImplGetter(MemAllocator, false, (char*)a, "a", sArgList, __FILE__, __LINE__);
  
  return (Result);
}

SEXP DBearded2::_set_a(SEXP arg_a, SEXP sArgList)
{
  SEXP Result = R_ImplSetter(MemAllocator, false, (char*)a, "a", arg_a, sArgList, __FILE__, __LINE__);
  
  return (Result);
}

SEXP DBearded2::_get_nt_a(SEXP sArgList) const
{
  SEXP Result = R_ImplGetter(MemAllocator, true, (char*)a, "a", sArgList, __FILE__, __LINE__);
  
  return (Result);
}

SEXP DBearded2::_set_nt_a(SEXP arg_a, SEXP sArgList)
{
  SEXP Result = R_ImplSetter(MemAllocator, true, (char*)a, "a", arg_a, sArgList, __FILE__, __LINE__);
  
  return (Result);
}

SEXP DBearded2::_get_amat() const
{
  return (R_Scalar(amat));
}

SEXP DBearded2::_set_amat(SEXP arg_amat)
{
  R_CheckArgument("arg_amat", "INTSXP", INTSXP, arg_amat, __FILE__, __LINE__);
  
  amat = INTEGER(arg_amat)[0];
  
  return (R_Empty());
}

SEXP DBearded2::_get_by(SEXP sArgList) const
{
  SEXP Result = R_ImplGetter(MemAllocator, false, (char*)by, "by", sArgList, __FILE__, __LINE__);
  
  return (Result);
}

SEXP DBearded2::_set_by(SEXP arg_by, SEXP sArgList)
{
  SEXP Result = R_ImplSetter(MemAllocator, false, (char*)by, "by", arg_by, sArgList, __FILE__, __LINE__);
  
  return (Result);
}

SEXP DBearded2::_get_nt_by(SEXP sArgList) const
{
  SEXP Result = R_ImplGetter(MemAllocator, true, (char*)by, "by", sArgList, __FILE__, __LINE__);
  
  return (Result);
}

SEXP DBearded2::_set_nt_by(SEXP arg_by, SEXP sArgList)
{
  SEXP Result = R_ImplSetter(MemAllocator, true, (char*)by, "by", arg_by, sArgList, __FILE__, __LINE__);
  
  return (Result);
}

SEXP DBearded2::R_internal_calc_probs(SEXP dummy, bool bTranslate)
{
  int arg_dummy;
  
  R_CheckArgument("dummy", "INTSXP", INTSXP, dummy, __FILE__, __LINE__);
  
  if (bTranslate)
  {
    arg_dummy = INTEGER(dummy)[0];
  }
  else
  {
    arg_dummy = INTEGER(dummy)[0];
  }
  
  SEXP Result = Rf_allocVector(REALSXP, 1);
  
  PROTECT(Result);
  REAL(Result)[0] = 0.0;
  calc_probs(arg_dummy);
  
  
  UNPROTECT(1);
  
  return (Result);
}

SEXP DBearded2::R_calc_probs(SEXP dummy)
{
  return (R_internal_calc_probs(dummy, true));
}

SEXP DBearded2::R_nt_calc_probs(SEXP dummy)
{
  return (R_internal_calc_probs(dummy, false));
}

SEXP DBearded2::_get_first_y() const
{
  return (R_Scalar(first_y));
}

SEXP DBearded2::_set_first_y(SEXP arg_first_y)
{
  R_CheckArgument("arg_first_y", "INTSXP", INTSXP, arg_first_y, __FILE__, __LINE__);
  
  first_y = INTEGER(arg_first_y)[0];
  
  return (R_Empty());
}

SEXP DBearded2::_get_first_y_sample() const
{
  return (R_Scalar(first_y_sample));
}

SEXP DBearded2::_set_first_y_sample(SEXP arg_first_y_sample)
{
  R_CheckArgument("arg_first_y_sample", "INTSXP", INTSXP, arg_first_y_sample, __FILE__, __LINE__);
  
  first_y_sample = INTEGER(arg_first_y_sample)[0];
  
  return (R_Empty());
}

SEXP DBearded2::_get_inv_totfec_ys(SEXP sArgList) const
{
  SEXP Result = R_ImplGetter(MemAllocator, false, (char*)inv_totfec_ys, "inv_totfec_ys", sArgList, __FILE__, __LINE__);
  
  return (Result);
}

SEXP DBearded2::_set_inv_totfec_ys(SEXP arg_inv_totfec_ys, SEXP sArgList)
{
  SEXP Result = R_ImplSetter(MemAllocator, false, (char*)inv_totfec_ys, "inv_totfec_ys", arg_inv_totfec_ys, sArgList, __FILE__, __LINE__);
  
  return (Result);
}

SEXP DBearded2::_get_nt_inv_totfec_ys(SEXP sArgList) const
{
  SEXP Result = R_ImplGetter(MemAllocator, true, (char*)inv_totfec_ys, "inv_totfec_ys", sArgList, __FILE__, __LINE__);
  
  return (Result);
}

SEXP DBearded2::_set_nt_inv_totfec_ys(SEXP arg_inv_totfec_ys, SEXP sArgList)
{
  SEXP Result = R_ImplSetter(MemAllocator, true, (char*)inv_totfec_ys, "inv_totfec_ys", arg_inv_totfec_ys, sArgList, __FILE__, __LINE__);
  
  return (Result);
}

SEXP DBearded2::_get_inv_totfec_ysb1_pars(SEXP sArgList) const
{
  SEXP Result = R_ImplGetter(MemAllocator, false, (char*)inv_totfec_ysb1_pars, "inv_totfec_ysb1_pars", sArgList, __FILE__, __LINE__);
  
  return (Result);
}

SEXP DBearded2::_set_inv_totfec_ysb1_pars(SEXP arg_inv_totfec_ysb1_pars, SEXP sArgList)
{
  SEXP Result = R_ImplSetter(MemAllocator, false, (char*)inv_totfec_ysb1_pars, "inv_totfec_ysb1_pars", arg_inv_totfec_ysb1_pars, sArgList, __FILE__, __LINE__);
  
  return (Result);
}

SEXP DBearded2::_get_nt_inv_totfec_ysb1_pars(SEXP sArgList) const
{
  SEXP Result = R_ImplGetter(MemAllocator, true, (char*)inv_totfec_ysb1_pars, "inv_totfec_ysb1_pars", sArgList, __FILE__, __LINE__);
  
  return (Result);
}

SEXP DBearded2::_set_nt_inv_totfec_ysb1_pars(SEXP arg_inv_totfec_ysb1_pars, SEXP sArgList)
{
  SEXP Result = R_ImplSetter(MemAllocator, true, (char*)inv_totfec_ysb1_pars, "inv_totfec_ysb1_pars", arg_inv_totfec_ysb1_pars, sArgList, __FILE__, __LINE__);
  
  return (Result);
}

SEXP DBearded2::_get_isamp_HS(SEXP sArgList) const
{
  SEXP Result = R_ImplGetter(MemAllocator, false, (char*)isamp_HS, "isamp_HS", sArgList, __FILE__, __LINE__);
  
  return (Result);
}

SEXP DBearded2::_set_isamp_HS(SEXP arg_isamp_HS, SEXP sArgList)
{
  SEXP Result = R_ImplSetter(MemAllocator, false, (char*)isamp_HS, "isamp_HS", arg_isamp_HS, sArgList, __FILE__, __LINE__);
  
  return (Result);
}

SEXP DBearded2::_get_nt_isamp_HS(SEXP sArgList) const
{
  SEXP Result = R_ImplGetter(MemAllocator, true, (char*)isamp_HS, "isamp_HS", sArgList, __FILE__, __LINE__);
  
  return (Result);
}

SEXP DBearded2::_set_nt_isamp_HS(SEXP arg_isamp_HS, SEXP sArgList)
{
  SEXP Result = R_ImplSetter(MemAllocator, true, (char*)isamp_HS, "isamp_HS", arg_isamp_HS, sArgList, __FILE__, __LINE__);
  
  return (Result);
}

SEXP DBearded2::_get_isamp_POP(SEXP sArgList) const
{
  SEXP Result = R_ImplGetter(MemAllocator, false, (char*)isamp_POP, "isamp_POP", sArgList, __FILE__, __LINE__);
  
  return (Result);
}

SEXP DBearded2::_set_isamp_POP(SEXP arg_isamp_POP, SEXP sArgList)
{
  SEXP Result = R_ImplSetter(MemAllocator, false, (char*)isamp_POP, "isamp_POP", arg_isamp_POP, sArgList, __FILE__, __LINE__);
  
  return (Result);
}

SEXP DBearded2::_get_nt_isamp_POP(SEXP sArgList) const
{
  SEXP Result = R_ImplGetter(MemAllocator, true, (char*)isamp_POP, "isamp_POP", sArgList, __FILE__, __LINE__);
  
  return (Result);
}

SEXP DBearded2::_set_nt_isamp_POP(SEXP arg_isamp_POP, SEXP sArgList)
{
  SEXP Result = R_ImplSetter(MemAllocator, true, (char*)isamp_POP, "isamp_POP", arg_isamp_POP, sArgList, __FILE__, __LINE__);
  
  return (Result);
}

SEXP DBearded2::_get_jsamp_HS(SEXP sArgList) const
{
  SEXP Result = R_ImplGetter(MemAllocator, false, (char*)jsamp_HS, "jsamp_HS", sArgList, __FILE__, __LINE__);
  
  return (Result);
}

SEXP DBearded2::_set_jsamp_HS(SEXP arg_jsamp_HS, SEXP sArgList)
{
  SEXP Result = R_ImplSetter(MemAllocator, false, (char*)jsamp_HS, "jsamp_HS", arg_jsamp_HS, sArgList, __FILE__, __LINE__);
  
  return (Result);
}

SEXP DBearded2::_get_nt_jsamp_HS(SEXP sArgList) const
{
  SEXP Result = R_ImplGetter(MemAllocator, true, (char*)jsamp_HS, "jsamp_HS", sArgList, __FILE__, __LINE__);
  
  return (Result);
}

SEXP DBearded2::_set_nt_jsamp_HS(SEXP arg_jsamp_HS, SEXP sArgList)
{
  SEXP Result = R_ImplSetter(MemAllocator, true, (char*)jsamp_HS, "jsamp_HS", arg_jsamp_HS, sArgList, __FILE__, __LINE__);
  
  return (Result);
}

SEXP DBearded2::_get_jsamp_POP(SEXP sArgList) const
{
  SEXP Result = R_ImplGetter(MemAllocator, false, (char*)jsamp_POP, "jsamp_POP", sArgList, __FILE__, __LINE__);
  
  return (Result);
}

SEXP DBearded2::_set_jsamp_POP(SEXP arg_jsamp_POP, SEXP sArgList)
{
  SEXP Result = R_ImplSetter(MemAllocator, false, (char*)jsamp_POP, "jsamp_POP", arg_jsamp_POP, sArgList, __FILE__, __LINE__);
  
  return (Result);
}

SEXP DBearded2::_get_nt_jsamp_POP(SEXP sArgList) const
{
  SEXP Result = R_ImplGetter(MemAllocator, true, (char*)jsamp_POP, "jsamp_POP", sArgList, __FILE__, __LINE__);
  
  return (Result);
}

SEXP DBearded2::_set_nt_jsamp_POP(SEXP arg_jsamp_POP, SEXP sArgList)
{
  SEXP Result = R_ImplSetter(MemAllocator, true, (char*)jsamp_POP, "jsamp_POP", arg_jsamp_POP, sArgList, __FILE__, __LINE__);
  
  return (Result);
}

SEXP DBearded2::_get_last_y() const
{
  return (R_Scalar(last_y));
}

SEXP DBearded2::_set_last_y(SEXP arg_last_y)
{
  R_CheckArgument("arg_last_y", "INTSXP", INTSXP, arg_last_y, __FILE__, __LINE__);
  
  last_y = INTEGER(arg_last_y)[0];
  
  return (R_Empty());
}

SEXP DBearded2::R_internal_lglk(SEXP pars, bool bTranslate)
{
  ARRAY_1D arg_pars;
  
  R_CheckArgument("pars", "REALSXP", REALSXP, pars, __FILE__, __LINE__, 1, 1, n_par);
  
  if (bTranslate)
  {
    arg_pars = 0;
    
    Plan_7.create(MemAllocator, arg_pars);
    
    AdtArrayPlanActor::R_to_ADlib(MemAllocator, (char*)REAL(pars), (char*)arg_pars);
    
  }
  else
  {
    arg_pars = 0;
    
    Plan_7.create(MemAllocator, arg_pars, (void*)REAL(pars));
    
  }
  
  SEXP Result = Rf_allocVector(REALSXP, 1);
  
  PROTECT(Result);
  REAL(Result)[0] = lglk(arg_pars);
  
  
  AdtArrayPlan::destroy(MemAllocator, arg_pars);
  UNPROTECT(1);
  
  return (Result);
}

SEXP DBearded2::R_lglk(SEXP pars)
{
  return (R_internal_lglk(pars, true));
}

SEXP DBearded2::R_nt_lglk(SEXP pars)
{
  return (R_internal_lglk(pars, false));
}

SEXP DBearded2::R_internal_LGLK_BPARS(SEXP pars, SEXP parsb1_pars, SEXP lglkb1_pars, bool bTranslate)
{
  ARRAY_1D arg_pars;
  ARRAY_1D arg_parsb1_pars;
  double arg_lglkb1_pars;
  
  R_CheckArgument("pars", "REALSXP", REALSXP, pars, __FILE__, __LINE__, 1, 1, n_par);
  
  R_CheckArgument("parsb1_pars", "REALSXP", REALSXP, parsb1_pars, __FILE__, __LINE__, 1, 1, n_par);
  
  R_CheckArgument("lglkb1_pars", "REALSXP", REALSXP, lglkb1_pars, __FILE__, __LINE__);
  
  if (bTranslate)
  {
    arg_pars = 0;
    
    Plan_7.create(MemAllocator, arg_pars);
    
    AdtArrayPlanActor::R_to_ADlib(MemAllocator, (char*)REAL(pars), (char*)arg_pars);
    
    arg_parsb1_pars = 0;
    
    Plan_7.create(MemAllocator, arg_parsb1_pars);
    
    AdtArrayPlanActor::R_to_ADlib(MemAllocator, (char*)REAL(parsb1_pars), (char*)arg_parsb1_pars);
    
    arg_lglkb1_pars = REAL(lglkb1_pars)[0];
  }
  else
  {
    arg_pars = 0;
    
    Plan_7.create(MemAllocator, arg_pars, (void*)REAL(pars));
    
    arg_parsb1_pars = 0;
    
    Plan_7.create(MemAllocator, arg_parsb1_pars, (void*)REAL(parsb1_pars));
    
    arg_lglkb1_pars = REAL(lglkb1_pars)[0];
  }
  
  SEXP Result = Rf_allocVector(REALSXP, 1);
  
  PROTECT(Result);
  REAL(Result)[0] = 0.0;
  LGLK_BPARS(arg_pars, arg_parsb1_pars, arg_lglkb1_pars);
  
  if (bTranslate)
  {
    AdtArrayPlanActor::ADlib_to_R(MemAllocator, (char*)arg_parsb1_pars, (char*)REAL(parsb1_pars));
    REAL(lglkb1_pars)[0] = arg_lglkb1_pars;
  }
  else
  {
    REAL(lglkb1_pars)[0] = arg_lglkb1_pars;
  }
  
  AdtArrayPlan::destroy(MemAllocator, arg_pars);
  AdtArrayPlan::destroy(MemAllocator, arg_parsb1_pars);
  UNPROTECT(1);
  
  return (Result);
}

SEXP DBearded2::R_LGLK_BPARS(SEXP pars, SEXP parsb1_pars, SEXP lglkb1_pars)
{
  return (R_internal_LGLK_BPARS(pars, parsb1_pars, lglkb1_pars, true));
}

SEXP DBearded2::R_nt_LGLK_BPARS(SEXP pars, SEXP parsb1_pars, SEXP lglkb1_pars)
{
  return (R_internal_LGLK_BPARS(pars, parsb1_pars, lglkb1_pars, false));
}

SEXP DBearded2::R_internal_make_data_summaries(bool bTranslate)
{
  if (bTranslate)
  {
  }
  else
  {
  }
  
  SEXP Result = Rf_allocVector(REALSXP, 1);
  
  PROTECT(Result);
  REAL(Result)[0] = 0.0;
  make_data_summaries();
  
  UNPROTECT(1);
  
  return (Result);
}

SEXP DBearded2::R_make_data_summaries()
{
  return (R_internal_make_data_summaries(true));
}

SEXP DBearded2::R_nt_make_data_summaries()
{
  return (R_internal_make_data_summaries(false));
}

SEXP DBearded2::_get_N0_f() const
{
  return (R_Scalar(N0_f));
}

SEXP DBearded2::_set_N0_f(SEXP arg_N0_f)
{
  R_CheckArgument("arg_N0_f", "REALSXP", REALSXP, arg_N0_f, __FILE__, __LINE__);
  
  N0_f = REAL(arg_N0_f)[0];
  
  return (R_Empty());
}

SEXP DBearded2::_get_n0_fb1_pars() const
{
  return (R_Scalar(n0_fb1_pars));
}

SEXP DBearded2::_set_n0_fb1_pars(SEXP arg_n0_fb1_pars)
{
  R_CheckArgument("arg_n0_fb1_pars", "REALSXP", REALSXP, arg_n0_fb1_pars, __FILE__, __LINE__);
  
  n0_fb1_pars = REAL(arg_n0_fb1_pars)[0];
  
  return (R_Empty());
}

SEXP DBearded2::_get_N0_m() const
{
  return (R_Scalar(N0_m));
}

SEXP DBearded2::_set_N0_m(SEXP arg_N0_m)
{
  R_CheckArgument("arg_N0_m", "REALSXP", REALSXP, arg_N0_m, __FILE__, __LINE__);
  
  N0_m = REAL(arg_N0_m)[0];
  
  return (R_Empty());
}

SEXP DBearded2::_get_n0_mb1_pars() const
{
  return (R_Scalar(n0_mb1_pars));
}

SEXP DBearded2::_set_n0_mb1_pars(SEXP arg_n0_mb1_pars)
{
  R_CheckArgument("arg_n0_mb1_pars", "REALSXP", REALSXP, arg_n0_mb1_pars, __FILE__, __LINE__);
  
  n0_mb1_pars = REAL(arg_n0_mb1_pars)[0];
  
  return (R_Empty());
}

SEXP DBearded2::_get_n_comps_ytbsm(SEXP sArgList) const
{
  SEXP Result = R_ImplGetter(MemAllocator, false, (char*)n_comps_ytbsm, "n_comps_ytbsm", sArgList, __FILE__, __LINE__);
  
  return (Result);
}

SEXP DBearded2::_set_n_comps_ytbsm(SEXP arg_n_comps_ytbsm, SEXP sArgList)
{
  SEXP Result = R_ImplSetter(MemAllocator, false, (char*)n_comps_ytbsm, "n_comps_ytbsm", arg_n_comps_ytbsm, sArgList, __FILE__, __LINE__);
  
  return (Result);
}

SEXP DBearded2::_get_nt_n_comps_ytbsm(SEXP sArgList) const
{
  SEXP Result = R_ImplGetter(MemAllocator, true, (char*)n_comps_ytbsm, "n_comps_ytbsm", sArgList, __FILE__, __LINE__);
  
  return (Result);
}

SEXP DBearded2::_set_nt_n_comps_ytbsm(SEXP arg_n_comps_ytbsm, SEXP sArgList)
{
  SEXP Result = R_ImplSetter(MemAllocator, true, (char*)n_comps_ytbsm, "n_comps_ytbsm", arg_n_comps_ytbsm, sArgList, __FILE__, __LINE__);
  
  return (Result);
}

SEXP DBearded2::_get_n_HS() const
{
  return (R_Scalar(n_HS));
}

SEXP DBearded2::_set_n_HS(SEXP arg_n_HS)
{
  R_CheckArgument("arg_n_HS", "INTSXP", INTSXP, arg_n_HS, __FILE__, __LINE__);
  
  n_HS = INTEGER(arg_n_HS)[0];
  
  return (R_Empty());
}

SEXP DBearded2::_get_n_hs_comps_yy(SEXP sArgList) const
{
  SEXP Result = R_ImplGetter(MemAllocator, false, (char*)n_hs_comps_yy, "n_hs_comps_yy", sArgList, __FILE__, __LINE__);
  
  return (Result);
}

SEXP DBearded2::_set_n_hs_comps_yy(SEXP arg_n_hs_comps_yy, SEXP sArgList)
{
  SEXP Result = R_ImplSetter(MemAllocator, false, (char*)n_hs_comps_yy, "n_hs_comps_yy", arg_n_hs_comps_yy, sArgList, __FILE__, __LINE__);
  
  return (Result);
}

SEXP DBearded2::_get_nt_n_hs_comps_yy(SEXP sArgList) const
{
  SEXP Result = R_ImplGetter(MemAllocator, true, (char*)n_hs_comps_yy, "n_hs_comps_yy", sArgList, __FILE__, __LINE__);
  
  return (Result);
}

SEXP DBearded2::_set_nt_n_hs_comps_yy(SEXP arg_n_hs_comps_yy, SEXP sArgList)
{
  SEXP Result = R_ImplSetter(MemAllocator, true, (char*)n_hs_comps_yy, "n_hs_comps_yy", arg_n_hs_comps_yy, sArgList, __FILE__, __LINE__);
  
  return (Result);
}

SEXP DBearded2::_get_n_hs_match_yys(SEXP sArgList) const
{
  SEXP Result = R_ImplGetter(MemAllocator, false, (char*)n_hs_match_yys, "n_hs_match_yys", sArgList, __FILE__, __LINE__);
  
  return (Result);
}

SEXP DBearded2::_set_n_hs_match_yys(SEXP arg_n_hs_match_yys, SEXP sArgList)
{
  SEXP Result = R_ImplSetter(MemAllocator, false, (char*)n_hs_match_yys, "n_hs_match_yys", arg_n_hs_match_yys, sArgList, __FILE__, __LINE__);
  
  return (Result);
}

SEXP DBearded2::_get_nt_n_hs_match_yys(SEXP sArgList) const
{
  SEXP Result = R_ImplGetter(MemAllocator, true, (char*)n_hs_match_yys, "n_hs_match_yys", sArgList, __FILE__, __LINE__);
  
  return (Result);
}

SEXP DBearded2::_set_nt_n_hs_match_yys(SEXP arg_n_hs_match_yys, SEXP sArgList)
{
  SEXP Result = R_ImplSetter(MemAllocator, true, (char*)n_hs_match_yys, "n_hs_match_yys", arg_n_hs_match_yys, sArgList, __FILE__, __LINE__);
  
  return (Result);
}

SEXP DBearded2::_get_n_par() const
{
  return (R_Scalar(n_par));
}

SEXP DBearded2::_set_n_par(SEXP arg_n_par)
{
  R_CheckArgument("arg_n_par", "INTSXP", INTSXP, arg_n_par, __FILE__, __LINE__);
  
  n_par = INTEGER(arg_n_par)[0];
  
  return (R_Empty());
}

SEXP DBearded2::_get_n_POP() const
{
  return (R_Scalar(n_POP));
}

SEXP DBearded2::_set_n_POP(SEXP arg_n_POP)
{
  R_CheckArgument("arg_n_POP", "INTSXP", INTSXP, arg_n_POP, __FILE__, __LINE__);
  
  n_POP = INTEGER(arg_n_POP)[0];
  
  return (R_Empty());
}

SEXP DBearded2::_get_n_samp() const
{
  return (R_Scalar(n_samp));
}

SEXP DBearded2::_set_n_samp(SEXP arg_n_samp)
{
  R_CheckArgument("arg_n_samp", "INTSXP", INTSXP, arg_n_samp, __FILE__, __LINE__);
  
  n_samp = INTEGER(arg_n_samp)[0];
  
  return (R_Empty());
}

SEXP DBearded2::_get_N_ys(SEXP sArgList) const
{
  SEXP Result = R_ImplGetter(MemAllocator, false, (char*)N_ys, "N_ys", sArgList, __FILE__, __LINE__);
  
  return (Result);
}

SEXP DBearded2::_set_N_ys(SEXP arg_N_ys, SEXP sArgList)
{
  SEXP Result = R_ImplSetter(MemAllocator, false, (char*)N_ys, "N_ys", arg_N_ys, sArgList, __FILE__, __LINE__);
  
  return (Result);
}

SEXP DBearded2::_get_nt_N_ys(SEXP sArgList) const
{
  SEXP Result = R_ImplGetter(MemAllocator, true, (char*)N_ys, "N_ys", sArgList, __FILE__, __LINE__);
  
  return (Result);
}

SEXP DBearded2::_set_nt_N_ys(SEXP arg_N_ys, SEXP sArgList)
{
  SEXP Result = R_ImplSetter(MemAllocator, true, (char*)N_ys, "N_ys", arg_N_ys, sArgList, __FILE__, __LINE__);
  
  return (Result);
}

SEXP DBearded2::_get_n_ysb1_pars(SEXP sArgList) const
{
  SEXP Result = R_ImplGetter(MemAllocator, false, (char*)n_ysb1_pars, "n_ysb1_pars", sArgList, __FILE__, __LINE__);
  
  return (Result);
}

SEXP DBearded2::_set_n_ysb1_pars(SEXP arg_n_ysb1_pars, SEXP sArgList)
{
  SEXP Result = R_ImplSetter(MemAllocator, false, (char*)n_ysb1_pars, "n_ysb1_pars", arg_n_ysb1_pars, sArgList, __FILE__, __LINE__);
  
  return (Result);
}

SEXP DBearded2::_get_nt_n_ysb1_pars(SEXP sArgList) const
{
  SEXP Result = R_ImplGetter(MemAllocator, true, (char*)n_ysb1_pars, "n_ysb1_pars", sArgList, __FILE__, __LINE__);
  
  return (Result);
}

SEXP DBearded2::_set_nt_n_ysb1_pars(SEXP arg_n_ysb1_pars, SEXP sArgList)
{
  SEXP Result = R_ImplSetter(MemAllocator, true, (char*)n_ysb1_pars, "n_ysb1_pars", arg_n_ysb1_pars, sArgList, __FILE__, __LINE__);
  
  return (Result);
}

SEXP DBearded2::R_internal_next_param(bool bTranslate)
{
  if (bTranslate)
  {
  }
  else
  {
  }
  
  SEXP Result = Rf_allocVector(REALSXP, 1);
  
  PROTECT(Result);
  REAL(Result)[0] = next_param();
  
  UNPROTECT(1);
  
  return (Result);
}

SEXP DBearded2::R_next_param()
{
  return (R_internal_next_param(true));
}

SEXP DBearded2::R_nt_next_param()
{
  return (R_internal_next_param(false));
}

SEXP DBearded2::_get_nextpari() const
{
  return (R_Scalar(nextpari));
}

SEXP DBearded2::_set_nextpari(SEXP arg_nextpari)
{
  R_CheckArgument("arg_nextpari", "INTSXP", INTSXP, arg_nextpari, __FILE__, __LINE__);
  
  nextpari = INTEGER(arg_nextpari)[0];
  
  return (R_Empty());
}

SEXP DBearded2::R_internal_populate(SEXP dummy, bool bTranslate)
{
  int arg_dummy;
  
  R_CheckArgument("dummy", "INTSXP", INTSXP, dummy, __FILE__, __LINE__);
  
  if (bTranslate)
  {
    arg_dummy = INTEGER(dummy)[0];
  }
  else
  {
    arg_dummy = INTEGER(dummy)[0];
  }
  
  SEXP Result = Rf_allocVector(REALSXP, 1);
  
  PROTECT(Result);
  REAL(Result)[0] = 0.0;
  populate(arg_dummy);
  
  
  UNPROTECT(1);
  
  return (Result);
}

SEXP DBearded2::R_populate(SEXP dummy)
{
  return (R_internal_populate(dummy, true));
}

SEXP DBearded2::R_nt_populate(SEXP dummy)
{
  return (R_internal_populate(dummy, false));
}

SEXP DBearded2::_get_Pr_HS_bbs(SEXP sArgList) const
{
  SEXP Result = R_ImplGetter(MemAllocator, false, (char*)Pr_HS_bbs, "Pr_HS_bbs", sArgList, __FILE__, __LINE__);
  
  return (Result);
}

SEXP DBearded2::_set_Pr_HS_bbs(SEXP arg_Pr_HS_bbs, SEXP sArgList)
{
  SEXP Result = R_ImplSetter(MemAllocator, false, (char*)Pr_HS_bbs, "Pr_HS_bbs", arg_Pr_HS_bbs, sArgList, __FILE__, __LINE__);
  
  return (Result);
}

SEXP DBearded2::_get_nt_Pr_HS_bbs(SEXP sArgList) const
{
  SEXP Result = R_ImplGetter(MemAllocator, true, (char*)Pr_HS_bbs, "Pr_HS_bbs", sArgList, __FILE__, __LINE__);
  
  return (Result);
}

SEXP DBearded2::_set_nt_Pr_HS_bbs(SEXP arg_Pr_HS_bbs, SEXP sArgList)
{
  SEXP Result = R_ImplSetter(MemAllocator, true, (char*)Pr_HS_bbs, "Pr_HS_bbs", arg_Pr_HS_bbs, sArgList, __FILE__, __LINE__);
  
  return (Result);
}

SEXP DBearded2::_get_Pr_HS_ybbs(SEXP sArgList) const
{
  SEXP Result = R_ImplGetter(MemAllocator, false, (char*)Pr_HS_ybbs, "Pr_HS_ybbs", sArgList, __FILE__, __LINE__);
  
  return (Result);
}

SEXP DBearded2::_set_Pr_HS_ybbs(SEXP arg_Pr_HS_ybbs, SEXP sArgList)
{
  SEXP Result = R_ImplSetter(MemAllocator, false, (char*)Pr_HS_ybbs, "Pr_HS_ybbs", arg_Pr_HS_ybbs, sArgList, __FILE__, __LINE__);
  
  return (Result);
}

SEXP DBearded2::_get_nt_Pr_HS_ybbs(SEXP sArgList) const
{
  SEXP Result = R_ImplGetter(MemAllocator, true, (char*)Pr_HS_ybbs, "Pr_HS_ybbs", sArgList, __FILE__, __LINE__);
  
  return (Result);
}

SEXP DBearded2::_set_nt_Pr_HS_ybbs(SEXP arg_Pr_HS_ybbs, SEXP sArgList)
{
  SEXP Result = R_ImplSetter(MemAllocator, true, (char*)Pr_HS_ybbs, "Pr_HS_ybbs", arg_Pr_HS_ybbs, sArgList, __FILE__, __LINE__);
  
  return (Result);
}

SEXP DBearded2::_get_pr_hs_ybbsb1_pars(SEXP sArgList) const
{
  SEXP Result = R_ImplGetter(MemAllocator, false, (char*)pr_hs_ybbsb1_pars, "pr_hs_ybbsb1_pars", sArgList, __FILE__, __LINE__);
  
  return (Result);
}

SEXP DBearded2::_set_pr_hs_ybbsb1_pars(SEXP arg_pr_hs_ybbsb1_pars, SEXP sArgList)
{
  SEXP Result = R_ImplSetter(MemAllocator, false, (char*)pr_hs_ybbsb1_pars, "pr_hs_ybbsb1_pars", arg_pr_hs_ybbsb1_pars, sArgList, __FILE__, __LINE__);
  
  return (Result);
}

SEXP DBearded2::_get_nt_pr_hs_ybbsb1_pars(SEXP sArgList) const
{
  SEXP Result = R_ImplGetter(MemAllocator, true, (char*)pr_hs_ybbsb1_pars, "pr_hs_ybbsb1_pars", sArgList, __FILE__, __LINE__);
  
  return (Result);
}

SEXP DBearded2::_set_nt_pr_hs_ybbsb1_pars(SEXP arg_pr_hs_ybbsb1_pars, SEXP sArgList)
{
  SEXP Result = R_ImplSetter(MemAllocator, true, (char*)pr_hs_ybbsb1_pars, "pr_hs_ybbsb1_pars", arg_pr_hs_ybbsb1_pars, sArgList, __FILE__, __LINE__);
  
  return (Result);
}

SEXP DBearded2::_get_Pr_PO_ytbs(SEXP sArgList) const
{
  SEXP Result = R_ImplGetter(MemAllocator, false, (char*)Pr_PO_ytbs, "Pr_PO_ytbs", sArgList, __FILE__, __LINE__);
  
  return (Result);
}

SEXP DBearded2::_set_Pr_PO_ytbs(SEXP arg_Pr_PO_ytbs, SEXP sArgList)
{
  SEXP Result = R_ImplSetter(MemAllocator, false, (char*)Pr_PO_ytbs, "Pr_PO_ytbs", arg_Pr_PO_ytbs, sArgList, __FILE__, __LINE__);
  
  return (Result);
}

SEXP DBearded2::_get_nt_Pr_PO_ytbs(SEXP sArgList) const
{
  SEXP Result = R_ImplGetter(MemAllocator, true, (char*)Pr_PO_ytbs, "Pr_PO_ytbs", sArgList, __FILE__, __LINE__);
  
  return (Result);
}

SEXP DBearded2::_set_nt_Pr_PO_ytbs(SEXP arg_Pr_PO_ytbs, SEXP sArgList)
{
  SEXP Result = R_ImplSetter(MemAllocator, true, (char*)Pr_PO_ytbs, "Pr_PO_ytbs", arg_Pr_PO_ytbs, sArgList, __FILE__, __LINE__);
  
  return (Result);
}

SEXP DBearded2::_get_pr_po_ytbsb1_pars(SEXP sArgList) const
{
  SEXP Result = R_ImplGetter(MemAllocator, false, (char*)pr_po_ytbsb1_pars, "pr_po_ytbsb1_pars", sArgList, __FILE__, __LINE__);
  
  return (Result);
}

SEXP DBearded2::_set_pr_po_ytbsb1_pars(SEXP arg_pr_po_ytbsb1_pars, SEXP sArgList)
{
  SEXP Result = R_ImplSetter(MemAllocator, false, (char*)pr_po_ytbsb1_pars, "pr_po_ytbsb1_pars", arg_pr_po_ytbsb1_pars, sArgList, __FILE__, __LINE__);
  
  return (Result);
}

SEXP DBearded2::_get_nt_pr_po_ytbsb1_pars(SEXP sArgList) const
{
  SEXP Result = R_ImplGetter(MemAllocator, true, (char*)pr_po_ytbsb1_pars, "pr_po_ytbsb1_pars", sArgList, __FILE__, __LINE__);
  
  return (Result);
}

SEXP DBearded2::_set_nt_pr_po_ytbsb1_pars(SEXP arg_pr_po_ytbsb1_pars, SEXP sArgList)
{
  SEXP Result = R_ImplSetter(MemAllocator, true, (char*)pr_po_ytbsb1_pars, "pr_po_ytbsb1_pars", arg_pr_po_ytbsb1_pars, sArgList, __FILE__, __LINE__);
  
  return (Result);
}

SEXP DBearded2::_get_roi() const
{
  return (R_Scalar(roi));
}

SEXP DBearded2::_set_roi(SEXP arg_roi)
{
  R_CheckArgument("arg_roi", "REALSXP", REALSXP, arg_roi, __FILE__, __LINE__);
  
  roi = REAL(arg_roi)[0];
  
  return (R_Empty());
}

SEXP DBearded2::_get_roib1_pars() const
{
  return (R_Scalar(roib1_pars));
}

SEXP DBearded2::_set_roib1_pars(SEXP arg_roib1_pars)
{
  R_CheckArgument("arg_roib1_pars", "REALSXP", REALSXP, arg_roib1_pars, __FILE__, __LINE__);
  
  roib1_pars = REAL(arg_roib1_pars)[0];
  
  return (R_Empty());
}

SEXP DBearded2::_get_S_yij(SEXP sArgList) const
{
  SEXP Result = R_ImplGetter(MemAllocator, false, (char*)S_yij, "S_yij", sArgList, __FILE__, __LINE__);
  
  return (Result);
}

SEXP DBearded2::_set_S_yij(SEXP arg_S_yij, SEXP sArgList)
{
  SEXP Result = R_ImplSetter(MemAllocator, false, (char*)S_yij, "S_yij", arg_S_yij, sArgList, __FILE__, __LINE__);
  
  return (Result);
}

SEXP DBearded2::_get_nt_S_yij(SEXP sArgList) const
{
  SEXP Result = R_ImplGetter(MemAllocator, true, (char*)S_yij, "S_yij", sArgList, __FILE__, __LINE__);
  
  return (Result);
}

SEXP DBearded2::_set_nt_S_yij(SEXP arg_S_yij, SEXP sArgList)
{
  SEXP Result = R_ImplSetter(MemAllocator, true, (char*)S_yij, "S_yij", arg_S_yij, sArgList, __FILE__, __LINE__);
  
  return (Result);
}

SEXP DBearded2::_get_s_yijb1_pars(SEXP sArgList) const
{
  SEXP Result = R_ImplGetter(MemAllocator, false, (char*)s_yijb1_pars, "s_yijb1_pars", sArgList, __FILE__, __LINE__);
  
  return (Result);
}

SEXP DBearded2::_set_s_yijb1_pars(SEXP arg_s_yijb1_pars, SEXP sArgList)
{
  SEXP Result = R_ImplSetter(MemAllocator, false, (char*)s_yijb1_pars, "s_yijb1_pars", arg_s_yijb1_pars, sArgList, __FILE__, __LINE__);
  
  return (Result);
}

SEXP DBearded2::_get_nt_s_yijb1_pars(SEXP sArgList) const
{
  SEXP Result = R_ImplGetter(MemAllocator, true, (char*)s_yijb1_pars, "s_yijb1_pars", sArgList, __FILE__, __LINE__);
  
  return (Result);
}

SEXP DBearded2::_set_nt_s_yijb1_pars(SEXP arg_s_yijb1_pars, SEXP sArgList)
{
  SEXP Result = R_ImplSetter(MemAllocator, true, (char*)s_yijb1_pars, "s_yijb1_pars", arg_s_yijb1_pars, sArgList, __FILE__, __LINE__);
  
  return (Result);
}

SEXP DBearded2::_get_sex(SEXP sArgList) const
{
  SEXP Result = R_ImplGetter(MemAllocator, false, (char*)sex, "sex", sArgList, __FILE__, __LINE__);
  
  return (Result);
}

SEXP DBearded2::_set_sex(SEXP arg_sex, SEXP sArgList)
{
  SEXP Result = R_ImplSetter(MemAllocator, false, (char*)sex, "sex", arg_sex, sArgList, __FILE__, __LINE__);
  
  return (Result);
}

SEXP DBearded2::_get_nt_sex(SEXP sArgList) const
{
  SEXP Result = R_ImplGetter(MemAllocator, true, (char*)sex, "sex", sArgList, __FILE__, __LINE__);
  
  return (Result);
}

SEXP DBearded2::_set_nt_sex(SEXP arg_sex, SEXP sArgList)
{
  SEXP Result = R_ImplSetter(MemAllocator, true, (char*)sex, "sex", arg_sex, sArgList, __FILE__, __LINE__);
  
  return (Result);
}

SEXP DBearded2::_get_sex_HS(SEXP sArgList) const
{
  SEXP Result = R_ImplGetter(MemAllocator, false, (char*)sex_HS, "sex_HS", sArgList, __FILE__, __LINE__);
  
  return (Result);
}

SEXP DBearded2::_set_sex_HS(SEXP arg_sex_HS, SEXP sArgList)
{
  SEXP Result = R_ImplSetter(MemAllocator, false, (char*)sex_HS, "sex_HS", arg_sex_HS, sArgList, __FILE__, __LINE__);
  
  return (Result);
}

SEXP DBearded2::_get_nt_sex_HS(SEXP sArgList) const
{
  SEXP Result = R_ImplGetter(MemAllocator, true, (char*)sex_HS, "sex_HS", sArgList, __FILE__, __LINE__);
  
  return (Result);
}

SEXP DBearded2::_set_nt_sex_HS(SEXP arg_sex_HS, SEXP sArgList)
{
  SEXP Result = R_ImplSetter(MemAllocator, true, (char*)sex_HS, "sex_HS", arg_sex_HS, sArgList, __FILE__, __LINE__);
  
  return (Result);
}

SEXP DBearded2::_get_sqrt_Pr_PO_ytbs(SEXP sArgList) const
{
  SEXP Result = R_ImplGetter(MemAllocator, false, (char*)sqrt_Pr_PO_ytbs, "sqrt_Pr_PO_ytbs", sArgList, __FILE__, __LINE__);
  
  return (Result);
}

SEXP DBearded2::_set_sqrt_Pr_PO_ytbs(SEXP arg_sqrt_Pr_PO_ytbs, SEXP sArgList)
{
  SEXP Result = R_ImplSetter(MemAllocator, false, (char*)sqrt_Pr_PO_ytbs, "sqrt_Pr_PO_ytbs", arg_sqrt_Pr_PO_ytbs, sArgList, __FILE__, __LINE__);
  
  return (Result);
}

SEXP DBearded2::_get_nt_sqrt_Pr_PO_ytbs(SEXP sArgList) const
{
  SEXP Result = R_ImplGetter(MemAllocator, true, (char*)sqrt_Pr_PO_ytbs, "sqrt_Pr_PO_ytbs", sArgList, __FILE__, __LINE__);
  
  return (Result);
}

SEXP DBearded2::_set_nt_sqrt_Pr_PO_ytbs(SEXP arg_sqrt_Pr_PO_ytbs, SEXP sArgList)
{
  SEXP Result = R_ImplSetter(MemAllocator, true, (char*)sqrt_Pr_PO_ytbs, "sqrt_Pr_PO_ytbs", arg_sqrt_Pr_PO_ytbs, sArgList, __FILE__, __LINE__);
  
  return (Result);
}

SEXP DBearded2::R_internal_sqrt_probs(SEXP pars, bool bTranslate)
{
  ARRAY_1D arg_pars;
  
  R_CheckArgument("pars", "REALSXP", REALSXP, pars, __FILE__, __LINE__, 1, 1, n_par);
  
  if (bTranslate)
  {
    arg_pars = 0;
    
    Plan_7.create(MemAllocator, arg_pars);
    
    AdtArrayPlanActor::R_to_ADlib(MemAllocator, (char*)REAL(pars), (char*)arg_pars);
    
  }
  else
  {
    arg_pars = 0;
    
    Plan_7.create(MemAllocator, arg_pars, (void*)REAL(pars));
    
  }
  
  SEXP Result = Rf_allocVector(REALSXP, 1);
  
  PROTECT(Result);
  REAL(Result)[0] = 0.0;
  sqrt_probs(arg_pars);
  
  
  AdtArrayPlan::destroy(MemAllocator, arg_pars);
  UNPROTECT(1);
  
  return (Result);
}

SEXP DBearded2::R_sqrt_probs(SEXP pars)
{
  return (R_internal_sqrt_probs(pars, true));
}

SEXP DBearded2::R_nt_sqrt_probs(SEXP pars)
{
  return (R_internal_sqrt_probs(pars, false));
}

SEXP DBearded2::_get_surv() const
{
  return (R_Scalar(surv));
}

SEXP DBearded2::_set_surv(SEXP arg_surv)
{
  R_CheckArgument("arg_surv", "REALSXP", REALSXP, arg_surv, __FILE__, __LINE__);
  
  surv = REAL(arg_surv)[0];
  
  return (R_Empty());
}

SEXP DBearded2::_get_survb1_pars() const
{
  return (R_Scalar(survb1_pars));
}

SEXP DBearded2::_set_survb1_pars(SEXP arg_survb1_pars)
{
  R_CheckArgument("arg_survb1_pars", "REALSXP", REALSXP, arg_survb1_pars, __FILE__, __LINE__);
  
  survb1_pars = REAL(arg_survb1_pars)[0];
  
  return (R_Empty());
}

SEXP DBearded2::_get_tcap(SEXP sArgList) const
{
  SEXP Result = R_ImplGetter(MemAllocator, false, (char*)tcap, "tcap", sArgList, __FILE__, __LINE__);
  
  return (Result);
}

SEXP DBearded2::_set_tcap(SEXP arg_tcap, SEXP sArgList)
{
  SEXP Result = R_ImplSetter(MemAllocator, false, (char*)tcap, "tcap", arg_tcap, sArgList, __FILE__, __LINE__);
  
  return (Result);
}

SEXP DBearded2::_get_nt_tcap(SEXP sArgList) const
{
  SEXP Result = R_ImplGetter(MemAllocator, true, (char*)tcap, "tcap", sArgList, __FILE__, __LINE__);
  
  return (Result);
}

SEXP DBearded2::_set_nt_tcap(SEXP arg_tcap, SEXP sArgList)
{
  SEXP Result = R_ImplSetter(MemAllocator, true, (char*)tcap, "tcap", arg_tcap, sArgList, __FILE__, __LINE__);
  
  return (Result);
}

SEXP DBearded2::_get_temp_pars(SEXP sArgList) const
{
  SEXP Result = R_ImplGetter(MemAllocator, false, (char*)temp_pars, "temp_pars", sArgList, __FILE__, __LINE__);
  
  return (Result);
}

SEXP DBearded2::_set_temp_pars(SEXP arg_temp_pars, SEXP sArgList)
{
  SEXP Result = R_ImplSetter(MemAllocator, false, (char*)temp_pars, "temp_pars", arg_temp_pars, sArgList, __FILE__, __LINE__);
  
  return (Result);
}

SEXP DBearded2::_get_nt_temp_pars(SEXP sArgList) const
{
  SEXP Result = R_ImplGetter(MemAllocator, true, (char*)temp_pars, "temp_pars", sArgList, __FILE__, __LINE__);
  
  return (Result);
}

SEXP DBearded2::_set_nt_temp_pars(SEXP arg_temp_pars, SEXP sArgList)
{
  SEXP Result = R_ImplSetter(MemAllocator, true, (char*)temp_pars, "temp_pars", arg_temp_pars, sArgList, __FILE__, __LINE__);
  
  return (Result);
}

SEXP DBearded2::_get_temp_parsb1_pars(SEXP sArgList) const
{
  SEXP Result = R_ImplGetter(MemAllocator, false, (char*)temp_parsb1_pars, "temp_parsb1_pars", sArgList, __FILE__, __LINE__);
  
  return (Result);
}

SEXP DBearded2::_set_temp_parsb1_pars(SEXP arg_temp_parsb1_pars, SEXP sArgList)
{
  SEXP Result = R_ImplSetter(MemAllocator, false, (char*)temp_parsb1_pars, "temp_parsb1_pars", arg_temp_parsb1_pars, sArgList, __FILE__, __LINE__);
  
  return (Result);
}

SEXP DBearded2::_get_nt_temp_parsb1_pars(SEXP sArgList) const
{
  SEXP Result = R_ImplGetter(MemAllocator, true, (char*)temp_parsb1_pars, "temp_parsb1_pars", sArgList, __FILE__, __LINE__);
  
  return (Result);
}

SEXP DBearded2::_set_nt_temp_parsb1_pars(SEXP arg_temp_parsb1_pars, SEXP sArgList)
{
  SEXP Result = R_ImplSetter(MemAllocator, true, (char*)temp_parsb1_pars, "temp_parsb1_pars", arg_temp_parsb1_pars, sArgList, __FILE__, __LINE__);
  
  return (Result);
}

SEXP DBearded2::R_internal_unpack(SEXP pars, bool bTranslate)
{
  ARRAY_1D arg_pars;
  
  R_CheckArgument("pars", "REALSXP", REALSXP, pars, __FILE__, __LINE__, 1, 1, n_par);
  
  if (bTranslate)
  {
    arg_pars = 0;
    
    Plan_7.create(MemAllocator, arg_pars);
    
    AdtArrayPlanActor::R_to_ADlib(MemAllocator, (char*)REAL(pars), (char*)arg_pars);
    
  }
  else
  {
    arg_pars = 0;
    
    Plan_7.create(MemAllocator, arg_pars, (void*)REAL(pars));
    
  }
  
  SEXP Result = Rf_allocVector(REALSXP, 1);
  
  PROTECT(Result);
  REAL(Result)[0] = 0.0;
  unpack(arg_pars);
  
  
  AdtArrayPlan::destroy(MemAllocator, arg_pars);
  UNPROTECT(1);
  
  return (Result);
}

SEXP DBearded2::R_unpack(SEXP pars)
{
  return (R_internal_unpack(pars, true));
}

SEXP DBearded2::R_nt_unpack(SEXP pars)
{
  return (R_internal_unpack(pars, false));
}

SEXP DBearded2::_get_ymat_atmost(SEXP sArgList) const
{
  SEXP Result = R_ImplGetter(MemAllocator, false, (char*)ymat_atmost, "ymat_atmost", sArgList, __FILE__, __LINE__);
  
  return (Result);
}

SEXP DBearded2::_set_ymat_atmost(SEXP arg_ymat_atmost, SEXP sArgList)
{
  SEXP Result = R_ImplSetter(MemAllocator, false, (char*)ymat_atmost, "ymat_atmost", arg_ymat_atmost, sArgList, __FILE__, __LINE__);
  
  return (Result);
}

SEXP DBearded2::_get_nt_ymat_atmost(SEXP sArgList) const
{
  SEXP Result = R_ImplGetter(MemAllocator, true, (char*)ymat_atmost, "ymat_atmost", sArgList, __FILE__, __LINE__);
  
  return (Result);
}

SEXP DBearded2::_set_nt_ymat_atmost(SEXP arg_ymat_atmost, SEXP sArgList)
{
  SEXP Result = R_ImplSetter(MemAllocator, true, (char*)ymat_atmost, "ymat_atmost", arg_ymat_atmost, sArgList, __FILE__, __LINE__);
  
  return (Result);
}
