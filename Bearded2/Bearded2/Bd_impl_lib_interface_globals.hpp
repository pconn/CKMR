IMPL_TYPE_TAG(DBearded2)


EXPORT SEXP Bd_get_a(SEXP args)
{
  SEXP rInstance;
  SEXP sArgList;
  args = CDR(args); rInstance = CAR(args);
  args = CDR(args); sArgList = CAR(args);
  
  ASSERT_TYPE_TAG(rInstance, DBearded2);
  
  DBearded2* pContext = (DBearded2*)R_ExternalPtrAddr(rInstance);
  
  return (pContext->_get_a(sArgList));
}

EXPORT SEXP Bd_set_a(SEXP args)
{
  SEXP rInstance;
  SEXP arg_a;
  SEXP sArgList;
  
  
  args = CDR(args); rInstance = CAR(args);
  args = CDR(args); arg_a = CAR(args);
  args = CDR(args); sArgList = CAR(args);
  
  ASSERT_TYPE_TAG(rInstance, DBearded2);
  
  DBearded2* pContext = (DBearded2*)R_ExternalPtrAddr(rInstance);
  
  return (pContext->_set_a(arg_a, sArgList));
}


EXPORT SEXP Bd_get_nt_a(SEXP args)
{
  SEXP rInstance;
  SEXP sArgList;
  args = CDR(args); rInstance = CAR(args);
  args = CDR(args); sArgList = CAR(args);
  
  ASSERT_TYPE_TAG(rInstance, DBearded2);
  
  DBearded2* pContext = (DBearded2*)R_ExternalPtrAddr(rInstance);
  
  return (pContext->_get_nt_a(sArgList));
}

EXPORT SEXP Bd_set_nt_a(SEXP args)
{
  SEXP rInstance;
  SEXP arg_a;
  SEXP sArgList;
  
  
  args = CDR(args); rInstance = CAR(args);
  args = CDR(args); arg_a = CAR(args);
  args = CDR(args); sArgList = CAR(args);
  
  ASSERT_TYPE_TAG(rInstance, DBearded2);
  
  DBearded2* pContext = (DBearded2*)R_ExternalPtrAddr(rInstance);
  
  return (pContext->_set_nt_a(arg_a, sArgList));
}


EXPORT SEXP Bd_get_amat(SEXP args)
{
  SEXP rInstance;
  args = CDR(args); rInstance = CAR(args);
  
  ASSERT_TYPE_TAG(rInstance, DBearded2);
  
  DBearded2* pContext = (DBearded2*)R_ExternalPtrAddr(rInstance);
  
  return (pContext->_get_amat());
}

EXPORT SEXP Bd_set_amat(SEXP args)
{
  SEXP rInstance;
  SEXP arg_amat;
  
  
  args = CDR(args); rInstance = CAR(args);
  args = CDR(args); arg_amat = CAR(args);
  
  ASSERT_TYPE_TAG(rInstance, DBearded2);
  
  DBearded2* pContext = (DBearded2*)R_ExternalPtrAddr(rInstance);
  
  return (pContext->_set_amat(arg_amat));
}


EXPORT SEXP Bd_get_by(SEXP args)
{
  SEXP rInstance;
  SEXP sArgList;
  args = CDR(args); rInstance = CAR(args);
  args = CDR(args); sArgList = CAR(args);
  
  ASSERT_TYPE_TAG(rInstance, DBearded2);
  
  DBearded2* pContext = (DBearded2*)R_ExternalPtrAddr(rInstance);
  
  return (pContext->_get_by(sArgList));
}

EXPORT SEXP Bd_set_by(SEXP args)
{
  SEXP rInstance;
  SEXP arg_by;
  SEXP sArgList;
  
  
  args = CDR(args); rInstance = CAR(args);
  args = CDR(args); arg_by = CAR(args);
  args = CDR(args); sArgList = CAR(args);
  
  ASSERT_TYPE_TAG(rInstance, DBearded2);
  
  DBearded2* pContext = (DBearded2*)R_ExternalPtrAddr(rInstance);
  
  return (pContext->_set_by(arg_by, sArgList));
}


EXPORT SEXP Bd_get_nt_by(SEXP args)
{
  SEXP rInstance;
  SEXP sArgList;
  args = CDR(args); rInstance = CAR(args);
  args = CDR(args); sArgList = CAR(args);
  
  ASSERT_TYPE_TAG(rInstance, DBearded2);
  
  DBearded2* pContext = (DBearded2*)R_ExternalPtrAddr(rInstance);
  
  return (pContext->_get_nt_by(sArgList));
}

EXPORT SEXP Bd_set_nt_by(SEXP args)
{
  SEXP rInstance;
  SEXP arg_by;
  SEXP sArgList;
  
  
  args = CDR(args); rInstance = CAR(args);
  args = CDR(args); arg_by = CAR(args);
  args = CDR(args); sArgList = CAR(args);
  
  ASSERT_TYPE_TAG(rInstance, DBearded2);
  
  DBearded2* pContext = (DBearded2*)R_ExternalPtrAddr(rInstance);
  
  return (pContext->_set_nt_by(arg_by, sArgList));
}


EXPORT SEXP Bd_R_calc_probs(SEXP args)
{
  SEXP rInstance;
  SEXP dummy;
  
  args = CDR(args); rInstance = CAR(args);
  args = CDR(args); dummy = CAR(args);
  
  ASSERT_TYPE_TAG(rInstance, DBearded2);
  
  DBearded2* pContext = (DBearded2*)R_ExternalPtrAddr(rInstance);
  
  SEXP Result = pContext->R_calc_probs(dummy);
  
  return (Result);
}

EXPORT SEXP Bd_R_nt_calc_probs(SEXP args)
{
  SEXP rInstance;
  SEXP dummy;
  
  args = CDR(args); rInstance = CAR(args);
  args = CDR(args); dummy = CAR(args);
  
  ASSERT_TYPE_TAG(rInstance, DBearded2);
  
  DBearded2* pContext = (DBearded2*)R_ExternalPtrAddr(rInstance);
  
  SEXP Result = pContext->R_nt_calc_probs(dummy);
  
  return (Result);
}

EXPORT SEXP Bd_get_first_y(SEXP args)
{
  SEXP rInstance;
  args = CDR(args); rInstance = CAR(args);
  
  ASSERT_TYPE_TAG(rInstance, DBearded2);
  
  DBearded2* pContext = (DBearded2*)R_ExternalPtrAddr(rInstance);
  
  return (pContext->_get_first_y());
}

EXPORT SEXP Bd_set_first_y(SEXP args)
{
  SEXP rInstance;
  SEXP arg_first_y;
  
  
  args = CDR(args); rInstance = CAR(args);
  args = CDR(args); arg_first_y = CAR(args);
  
  ASSERT_TYPE_TAG(rInstance, DBearded2);
  
  DBearded2* pContext = (DBearded2*)R_ExternalPtrAddr(rInstance);
  
  return (pContext->_set_first_y(arg_first_y));
}


EXPORT SEXP Bd_get_first_y_sample(SEXP args)
{
  SEXP rInstance;
  args = CDR(args); rInstance = CAR(args);
  
  ASSERT_TYPE_TAG(rInstance, DBearded2);
  
  DBearded2* pContext = (DBearded2*)R_ExternalPtrAddr(rInstance);
  
  return (pContext->_get_first_y_sample());
}

EXPORT SEXP Bd_set_first_y_sample(SEXP args)
{
  SEXP rInstance;
  SEXP arg_first_y_sample;
  
  
  args = CDR(args); rInstance = CAR(args);
  args = CDR(args); arg_first_y_sample = CAR(args);
  
  ASSERT_TYPE_TAG(rInstance, DBearded2);
  
  DBearded2* pContext = (DBearded2*)R_ExternalPtrAddr(rInstance);
  
  return (pContext->_set_first_y_sample(arg_first_y_sample));
}


EXPORT SEXP Bd_get_inv_totfec_ys(SEXP args)
{
  SEXP rInstance;
  SEXP sArgList;
  args = CDR(args); rInstance = CAR(args);
  args = CDR(args); sArgList = CAR(args);
  
  ASSERT_TYPE_TAG(rInstance, DBearded2);
  
  DBearded2* pContext = (DBearded2*)R_ExternalPtrAddr(rInstance);
  
  return (pContext->_get_inv_totfec_ys(sArgList));
}

EXPORT SEXP Bd_set_inv_totfec_ys(SEXP args)
{
  SEXP rInstance;
  SEXP arg_inv_totfec_ys;
  SEXP sArgList;
  
  
  args = CDR(args); rInstance = CAR(args);
  args = CDR(args); arg_inv_totfec_ys = CAR(args);
  args = CDR(args); sArgList = CAR(args);
  
  ASSERT_TYPE_TAG(rInstance, DBearded2);
  
  DBearded2* pContext = (DBearded2*)R_ExternalPtrAddr(rInstance);
  
  return (pContext->_set_inv_totfec_ys(arg_inv_totfec_ys, sArgList));
}


EXPORT SEXP Bd_get_nt_inv_totfec_ys(SEXP args)
{
  SEXP rInstance;
  SEXP sArgList;
  args = CDR(args); rInstance = CAR(args);
  args = CDR(args); sArgList = CAR(args);
  
  ASSERT_TYPE_TAG(rInstance, DBearded2);
  
  DBearded2* pContext = (DBearded2*)R_ExternalPtrAddr(rInstance);
  
  return (pContext->_get_nt_inv_totfec_ys(sArgList));
}

EXPORT SEXP Bd_set_nt_inv_totfec_ys(SEXP args)
{
  SEXP rInstance;
  SEXP arg_inv_totfec_ys;
  SEXP sArgList;
  
  
  args = CDR(args); rInstance = CAR(args);
  args = CDR(args); arg_inv_totfec_ys = CAR(args);
  args = CDR(args); sArgList = CAR(args);
  
  ASSERT_TYPE_TAG(rInstance, DBearded2);
  
  DBearded2* pContext = (DBearded2*)R_ExternalPtrAddr(rInstance);
  
  return (pContext->_set_nt_inv_totfec_ys(arg_inv_totfec_ys, sArgList));
}


EXPORT SEXP Bd_get_inv_totfec_ysb1_pars(SEXP args)
{
  SEXP rInstance;
  SEXP sArgList;
  args = CDR(args); rInstance = CAR(args);
  args = CDR(args); sArgList = CAR(args);
  
  ASSERT_TYPE_TAG(rInstance, DBearded2);
  
  DBearded2* pContext = (DBearded2*)R_ExternalPtrAddr(rInstance);
  
  return (pContext->_get_inv_totfec_ysb1_pars(sArgList));
}

EXPORT SEXP Bd_set_inv_totfec_ysb1_pars(SEXP args)
{
  SEXP rInstance;
  SEXP arg_inv_totfec_ysb1_pars;
  SEXP sArgList;
  
  
  args = CDR(args); rInstance = CAR(args);
  args = CDR(args); arg_inv_totfec_ysb1_pars = CAR(args);
  args = CDR(args); sArgList = CAR(args);
  
  ASSERT_TYPE_TAG(rInstance, DBearded2);
  
  DBearded2* pContext = (DBearded2*)R_ExternalPtrAddr(rInstance);
  
  return (pContext->_set_inv_totfec_ysb1_pars(arg_inv_totfec_ysb1_pars, sArgList));
}


EXPORT SEXP Bd_get_nt_inv_totfec_ysb1_pars(SEXP args)
{
  SEXP rInstance;
  SEXP sArgList;
  args = CDR(args); rInstance = CAR(args);
  args = CDR(args); sArgList = CAR(args);
  
  ASSERT_TYPE_TAG(rInstance, DBearded2);
  
  DBearded2* pContext = (DBearded2*)R_ExternalPtrAddr(rInstance);
  
  return (pContext->_get_nt_inv_totfec_ysb1_pars(sArgList));
}

EXPORT SEXP Bd_set_nt_inv_totfec_ysb1_pars(SEXP args)
{
  SEXP rInstance;
  SEXP arg_inv_totfec_ysb1_pars;
  SEXP sArgList;
  
  
  args = CDR(args); rInstance = CAR(args);
  args = CDR(args); arg_inv_totfec_ysb1_pars = CAR(args);
  args = CDR(args); sArgList = CAR(args);
  
  ASSERT_TYPE_TAG(rInstance, DBearded2);
  
  DBearded2* pContext = (DBearded2*)R_ExternalPtrAddr(rInstance);
  
  return (pContext->_set_nt_inv_totfec_ysb1_pars(arg_inv_totfec_ysb1_pars, sArgList));
}


EXPORT SEXP Bd_get_isamp_POP(SEXP args)
{
  SEXP rInstance;
  SEXP sArgList;
  args = CDR(args); rInstance = CAR(args);
  args = CDR(args); sArgList = CAR(args);
  
  ASSERT_TYPE_TAG(rInstance, DBearded2);
  
  DBearded2* pContext = (DBearded2*)R_ExternalPtrAddr(rInstance);
  
  return (pContext->_get_isamp_POP(sArgList));
}

EXPORT SEXP Bd_set_isamp_POP(SEXP args)
{
  SEXP rInstance;
  SEXP arg_isamp_POP;
  SEXP sArgList;
  
  
  args = CDR(args); rInstance = CAR(args);
  args = CDR(args); arg_isamp_POP = CAR(args);
  args = CDR(args); sArgList = CAR(args);
  
  ASSERT_TYPE_TAG(rInstance, DBearded2);
  
  DBearded2* pContext = (DBearded2*)R_ExternalPtrAddr(rInstance);
  
  return (pContext->_set_isamp_POP(arg_isamp_POP, sArgList));
}


EXPORT SEXP Bd_get_nt_isamp_POP(SEXP args)
{
  SEXP rInstance;
  SEXP sArgList;
  args = CDR(args); rInstance = CAR(args);
  args = CDR(args); sArgList = CAR(args);
  
  ASSERT_TYPE_TAG(rInstance, DBearded2);
  
  DBearded2* pContext = (DBearded2*)R_ExternalPtrAddr(rInstance);
  
  return (pContext->_get_nt_isamp_POP(sArgList));
}

EXPORT SEXP Bd_set_nt_isamp_POP(SEXP args)
{
  SEXP rInstance;
  SEXP arg_isamp_POP;
  SEXP sArgList;
  
  
  args = CDR(args); rInstance = CAR(args);
  args = CDR(args); arg_isamp_POP = CAR(args);
  args = CDR(args); sArgList = CAR(args);
  
  ASSERT_TYPE_TAG(rInstance, DBearded2);
  
  DBearded2* pContext = (DBearded2*)R_ExternalPtrAddr(rInstance);
  
  return (pContext->_set_nt_isamp_POP(arg_isamp_POP, sArgList));
}


EXPORT SEXP Bd_get_jsamp_POP(SEXP args)
{
  SEXP rInstance;
  SEXP sArgList;
  args = CDR(args); rInstance = CAR(args);
  args = CDR(args); sArgList = CAR(args);
  
  ASSERT_TYPE_TAG(rInstance, DBearded2);
  
  DBearded2* pContext = (DBearded2*)R_ExternalPtrAddr(rInstance);
  
  return (pContext->_get_jsamp_POP(sArgList));
}

EXPORT SEXP Bd_set_jsamp_POP(SEXP args)
{
  SEXP rInstance;
  SEXP arg_jsamp_POP;
  SEXP sArgList;
  
  
  args = CDR(args); rInstance = CAR(args);
  args = CDR(args); arg_jsamp_POP = CAR(args);
  args = CDR(args); sArgList = CAR(args);
  
  ASSERT_TYPE_TAG(rInstance, DBearded2);
  
  DBearded2* pContext = (DBearded2*)R_ExternalPtrAddr(rInstance);
  
  return (pContext->_set_jsamp_POP(arg_jsamp_POP, sArgList));
}


EXPORT SEXP Bd_get_nt_jsamp_POP(SEXP args)
{
  SEXP rInstance;
  SEXP sArgList;
  args = CDR(args); rInstance = CAR(args);
  args = CDR(args); sArgList = CAR(args);
  
  ASSERT_TYPE_TAG(rInstance, DBearded2);
  
  DBearded2* pContext = (DBearded2*)R_ExternalPtrAddr(rInstance);
  
  return (pContext->_get_nt_jsamp_POP(sArgList));
}

EXPORT SEXP Bd_set_nt_jsamp_POP(SEXP args)
{
  SEXP rInstance;
  SEXP arg_jsamp_POP;
  SEXP sArgList;
  
  
  args = CDR(args); rInstance = CAR(args);
  args = CDR(args); arg_jsamp_POP = CAR(args);
  args = CDR(args); sArgList = CAR(args);
  
  ASSERT_TYPE_TAG(rInstance, DBearded2);
  
  DBearded2* pContext = (DBearded2*)R_ExternalPtrAddr(rInstance);
  
  return (pContext->_set_nt_jsamp_POP(arg_jsamp_POP, sArgList));
}


EXPORT SEXP Bd_get_last_y(SEXP args)
{
  SEXP rInstance;
  args = CDR(args); rInstance = CAR(args);
  
  ASSERT_TYPE_TAG(rInstance, DBearded2);
  
  DBearded2* pContext = (DBearded2*)R_ExternalPtrAddr(rInstance);
  
  return (pContext->_get_last_y());
}

EXPORT SEXP Bd_set_last_y(SEXP args)
{
  SEXP rInstance;
  SEXP arg_last_y;
  
  
  args = CDR(args); rInstance = CAR(args);
  args = CDR(args); arg_last_y = CAR(args);
  
  ASSERT_TYPE_TAG(rInstance, DBearded2);
  
  DBearded2* pContext = (DBearded2*)R_ExternalPtrAddr(rInstance);
  
  return (pContext->_set_last_y(arg_last_y));
}


EXPORT SEXP Bd_R_lglk(SEXP args)
{
  SEXP rInstance;
  SEXP pars;
  
  args = CDR(args); rInstance = CAR(args);
  args = CDR(args); pars = CAR(args);
  
  ASSERT_TYPE_TAG(rInstance, DBearded2);
  
  DBearded2* pContext = (DBearded2*)R_ExternalPtrAddr(rInstance);
  
  SEXP Result = pContext->R_lglk(pars);
  
  return (Result);
}

EXPORT SEXP Bd_R_nt_lglk(SEXP args)
{
  SEXP rInstance;
  SEXP pars;
  
  args = CDR(args); rInstance = CAR(args);
  args = CDR(args); pars = CAR(args);
  
  ASSERT_TYPE_TAG(rInstance, DBearded2);
  
  DBearded2* pContext = (DBearded2*)R_ExternalPtrAddr(rInstance);
  
  SEXP Result = pContext->R_nt_lglk(pars);
  
  return (Result);
}

EXPORT SEXP Bd_R_LGLK_BPARS(SEXP args)
{
  SEXP rInstance;
  SEXP pars;
  SEXP parsb1_pars;
  SEXP lglkb1_pars;
  
  args = CDR(args); rInstance = CAR(args);
  args = CDR(args); pars = CAR(args);
  args = CDR(args); parsb1_pars = CAR(args);
  args = CDR(args); lglkb1_pars = CAR(args);
  
  ASSERT_TYPE_TAG(rInstance, DBearded2);
  
  DBearded2* pContext = (DBearded2*)R_ExternalPtrAddr(rInstance);
  
  SEXP Result = pContext->R_LGLK_BPARS(pars, parsb1_pars, lglkb1_pars);
  
  return (Result);
}

EXPORT SEXP Bd_R_nt_LGLK_BPARS(SEXP args)
{
  SEXP rInstance;
  SEXP pars;
  SEXP parsb1_pars;
  SEXP lglkb1_pars;
  
  args = CDR(args); rInstance = CAR(args);
  args = CDR(args); pars = CAR(args);
  args = CDR(args); parsb1_pars = CAR(args);
  args = CDR(args); lglkb1_pars = CAR(args);
  
  ASSERT_TYPE_TAG(rInstance, DBearded2);
  
  DBearded2* pContext = (DBearded2*)R_ExternalPtrAddr(rInstance);
  
  SEXP Result = pContext->R_nt_LGLK_BPARS(pars, parsb1_pars, lglkb1_pars);
  
  return (Result);
}

EXPORT SEXP Bd_R_make_data_summaries(SEXP args)
{
  SEXP rInstance;
  
  
  args = CDR(args); rInstance = CAR(args);
  
  
  ASSERT_TYPE_TAG(rInstance, DBearded2);
  
  DBearded2* pContext = (DBearded2*)R_ExternalPtrAddr(rInstance);
  
  SEXP Result = pContext->R_make_data_summaries();
  
  return (Result);
}

EXPORT SEXP Bd_R_nt_make_data_summaries(SEXP args)
{
  SEXP rInstance;
  
  
  args = CDR(args); rInstance = CAR(args);
  
  
  ASSERT_TYPE_TAG(rInstance, DBearded2);
  
  DBearded2* pContext = (DBearded2*)R_ExternalPtrAddr(rInstance);
  
  SEXP Result = pContext->R_nt_make_data_summaries();
  
  return (Result);
}

EXPORT SEXP Bd_get_N0_f(SEXP args)
{
  SEXP rInstance;
  args = CDR(args); rInstance = CAR(args);
  
  ASSERT_TYPE_TAG(rInstance, DBearded2);
  
  DBearded2* pContext = (DBearded2*)R_ExternalPtrAddr(rInstance);
  
  return (pContext->_get_N0_f());
}

EXPORT SEXP Bd_set_N0_f(SEXP args)
{
  SEXP rInstance;
  SEXP arg_N0_f;
  
  
  args = CDR(args); rInstance = CAR(args);
  args = CDR(args); arg_N0_f = CAR(args);
  
  ASSERT_TYPE_TAG(rInstance, DBearded2);
  
  DBearded2* pContext = (DBearded2*)R_ExternalPtrAddr(rInstance);
  
  return (pContext->_set_N0_f(arg_N0_f));
}


EXPORT SEXP Bd_get_n0_fb1_pars(SEXP args)
{
  SEXP rInstance;
  args = CDR(args); rInstance = CAR(args);
  
  ASSERT_TYPE_TAG(rInstance, DBearded2);
  
  DBearded2* pContext = (DBearded2*)R_ExternalPtrAddr(rInstance);
  
  return (pContext->_get_n0_fb1_pars());
}

EXPORT SEXP Bd_set_n0_fb1_pars(SEXP args)
{
  SEXP rInstance;
  SEXP arg_n0_fb1_pars;
  
  
  args = CDR(args); rInstance = CAR(args);
  args = CDR(args); arg_n0_fb1_pars = CAR(args);
  
  ASSERT_TYPE_TAG(rInstance, DBearded2);
  
  DBearded2* pContext = (DBearded2*)R_ExternalPtrAddr(rInstance);
  
  return (pContext->_set_n0_fb1_pars(arg_n0_fb1_pars));
}


EXPORT SEXP Bd_get_N0_m(SEXP args)
{
  SEXP rInstance;
  args = CDR(args); rInstance = CAR(args);
  
  ASSERT_TYPE_TAG(rInstance, DBearded2);
  
  DBearded2* pContext = (DBearded2*)R_ExternalPtrAddr(rInstance);
  
  return (pContext->_get_N0_m());
}

EXPORT SEXP Bd_set_N0_m(SEXP args)
{
  SEXP rInstance;
  SEXP arg_N0_m;
  
  
  args = CDR(args); rInstance = CAR(args);
  args = CDR(args); arg_N0_m = CAR(args);
  
  ASSERT_TYPE_TAG(rInstance, DBearded2);
  
  DBearded2* pContext = (DBearded2*)R_ExternalPtrAddr(rInstance);
  
  return (pContext->_set_N0_m(arg_N0_m));
}


EXPORT SEXP Bd_get_n0_mb1_pars(SEXP args)
{
  SEXP rInstance;
  args = CDR(args); rInstance = CAR(args);
  
  ASSERT_TYPE_TAG(rInstance, DBearded2);
  
  DBearded2* pContext = (DBearded2*)R_ExternalPtrAddr(rInstance);
  
  return (pContext->_get_n0_mb1_pars());
}

EXPORT SEXP Bd_set_n0_mb1_pars(SEXP args)
{
  SEXP rInstance;
  SEXP arg_n0_mb1_pars;
  
  
  args = CDR(args); rInstance = CAR(args);
  args = CDR(args); arg_n0_mb1_pars = CAR(args);
  
  ASSERT_TYPE_TAG(rInstance, DBearded2);
  
  DBearded2* pContext = (DBearded2*)R_ExternalPtrAddr(rInstance);
  
  return (pContext->_set_n0_mb1_pars(arg_n0_mb1_pars));
}


EXPORT SEXP Bd_get_n_comps_ytbsm(SEXP args)
{
  SEXP rInstance;
  SEXP sArgList;
  args = CDR(args); rInstance = CAR(args);
  args = CDR(args); sArgList = CAR(args);
  
  ASSERT_TYPE_TAG(rInstance, DBearded2);
  
  DBearded2* pContext = (DBearded2*)R_ExternalPtrAddr(rInstance);
  
  return (pContext->_get_n_comps_ytbsm(sArgList));
}

EXPORT SEXP Bd_set_n_comps_ytbsm(SEXP args)
{
  SEXP rInstance;
  SEXP arg_n_comps_ytbsm;
  SEXP sArgList;
  
  
  args = CDR(args); rInstance = CAR(args);
  args = CDR(args); arg_n_comps_ytbsm = CAR(args);
  args = CDR(args); sArgList = CAR(args);
  
  ASSERT_TYPE_TAG(rInstance, DBearded2);
  
  DBearded2* pContext = (DBearded2*)R_ExternalPtrAddr(rInstance);
  
  return (pContext->_set_n_comps_ytbsm(arg_n_comps_ytbsm, sArgList));
}


EXPORT SEXP Bd_get_nt_n_comps_ytbsm(SEXP args)
{
  SEXP rInstance;
  SEXP sArgList;
  args = CDR(args); rInstance = CAR(args);
  args = CDR(args); sArgList = CAR(args);
  
  ASSERT_TYPE_TAG(rInstance, DBearded2);
  
  DBearded2* pContext = (DBearded2*)R_ExternalPtrAddr(rInstance);
  
  return (pContext->_get_nt_n_comps_ytbsm(sArgList));
}

EXPORT SEXP Bd_set_nt_n_comps_ytbsm(SEXP args)
{
  SEXP rInstance;
  SEXP arg_n_comps_ytbsm;
  SEXP sArgList;
  
  
  args = CDR(args); rInstance = CAR(args);
  args = CDR(args); arg_n_comps_ytbsm = CAR(args);
  args = CDR(args); sArgList = CAR(args);
  
  ASSERT_TYPE_TAG(rInstance, DBearded2);
  
  DBearded2* pContext = (DBearded2*)R_ExternalPtrAddr(rInstance);
  
  return (pContext->_set_nt_n_comps_ytbsm(arg_n_comps_ytbsm, sArgList));
}


EXPORT SEXP Bd_get_n_par(SEXP args)
{
  SEXP rInstance;
  args = CDR(args); rInstance = CAR(args);
  
  ASSERT_TYPE_TAG(rInstance, DBearded2);
  
  DBearded2* pContext = (DBearded2*)R_ExternalPtrAddr(rInstance);
  
  return (pContext->_get_n_par());
}

EXPORT SEXP Bd_set_n_par(SEXP args)
{
  SEXP rInstance;
  SEXP arg_n_par;
  
  
  args = CDR(args); rInstance = CAR(args);
  args = CDR(args); arg_n_par = CAR(args);
  
  ASSERT_TYPE_TAG(rInstance, DBearded2);
  
  DBearded2* pContext = (DBearded2*)R_ExternalPtrAddr(rInstance);
  
  return (pContext->_set_n_par(arg_n_par));
}


EXPORT SEXP Bd_get_n_POP(SEXP args)
{
  SEXP rInstance;
  args = CDR(args); rInstance = CAR(args);
  
  ASSERT_TYPE_TAG(rInstance, DBearded2);
  
  DBearded2* pContext = (DBearded2*)R_ExternalPtrAddr(rInstance);
  
  return (pContext->_get_n_POP());
}

EXPORT SEXP Bd_set_n_POP(SEXP args)
{
  SEXP rInstance;
  SEXP arg_n_POP;
  
  
  args = CDR(args); rInstance = CAR(args);
  args = CDR(args); arg_n_POP = CAR(args);
  
  ASSERT_TYPE_TAG(rInstance, DBearded2);
  
  DBearded2* pContext = (DBearded2*)R_ExternalPtrAddr(rInstance);
  
  return (pContext->_set_n_POP(arg_n_POP));
}


EXPORT SEXP Bd_get_n_samp(SEXP args)
{
  SEXP rInstance;
  args = CDR(args); rInstance = CAR(args);
  
  ASSERT_TYPE_TAG(rInstance, DBearded2);
  
  DBearded2* pContext = (DBearded2*)R_ExternalPtrAddr(rInstance);
  
  return (pContext->_get_n_samp());
}

EXPORT SEXP Bd_set_n_samp(SEXP args)
{
  SEXP rInstance;
  SEXP arg_n_samp;
  
  
  args = CDR(args); rInstance = CAR(args);
  args = CDR(args); arg_n_samp = CAR(args);
  
  ASSERT_TYPE_TAG(rInstance, DBearded2);
  
  DBearded2* pContext = (DBearded2*)R_ExternalPtrAddr(rInstance);
  
  return (pContext->_set_n_samp(arg_n_samp));
}


EXPORT SEXP Bd_get_N_ys(SEXP args)
{
  SEXP rInstance;
  SEXP sArgList;
  args = CDR(args); rInstance = CAR(args);
  args = CDR(args); sArgList = CAR(args);
  
  ASSERT_TYPE_TAG(rInstance, DBearded2);
  
  DBearded2* pContext = (DBearded2*)R_ExternalPtrAddr(rInstance);
  
  return (pContext->_get_N_ys(sArgList));
}

EXPORT SEXP Bd_set_N_ys(SEXP args)
{
  SEXP rInstance;
  SEXP arg_N_ys;
  SEXP sArgList;
  
  
  args = CDR(args); rInstance = CAR(args);
  args = CDR(args); arg_N_ys = CAR(args);
  args = CDR(args); sArgList = CAR(args);
  
  ASSERT_TYPE_TAG(rInstance, DBearded2);
  
  DBearded2* pContext = (DBearded2*)R_ExternalPtrAddr(rInstance);
  
  return (pContext->_set_N_ys(arg_N_ys, sArgList));
}


EXPORT SEXP Bd_get_nt_N_ys(SEXP args)
{
  SEXP rInstance;
  SEXP sArgList;
  args = CDR(args); rInstance = CAR(args);
  args = CDR(args); sArgList = CAR(args);
  
  ASSERT_TYPE_TAG(rInstance, DBearded2);
  
  DBearded2* pContext = (DBearded2*)R_ExternalPtrAddr(rInstance);
  
  return (pContext->_get_nt_N_ys(sArgList));
}

EXPORT SEXP Bd_set_nt_N_ys(SEXP args)
{
  SEXP rInstance;
  SEXP arg_N_ys;
  SEXP sArgList;
  
  
  args = CDR(args); rInstance = CAR(args);
  args = CDR(args); arg_N_ys = CAR(args);
  args = CDR(args); sArgList = CAR(args);
  
  ASSERT_TYPE_TAG(rInstance, DBearded2);
  
  DBearded2* pContext = (DBearded2*)R_ExternalPtrAddr(rInstance);
  
  return (pContext->_set_nt_N_ys(arg_N_ys, sArgList));
}


EXPORT SEXP Bd_get_n_ysb1_pars(SEXP args)
{
  SEXP rInstance;
  SEXP sArgList;
  args = CDR(args); rInstance = CAR(args);
  args = CDR(args); sArgList = CAR(args);
  
  ASSERT_TYPE_TAG(rInstance, DBearded2);
  
  DBearded2* pContext = (DBearded2*)R_ExternalPtrAddr(rInstance);
  
  return (pContext->_get_n_ysb1_pars(sArgList));
}

EXPORT SEXP Bd_set_n_ysb1_pars(SEXP args)
{
  SEXP rInstance;
  SEXP arg_n_ysb1_pars;
  SEXP sArgList;
  
  
  args = CDR(args); rInstance = CAR(args);
  args = CDR(args); arg_n_ysb1_pars = CAR(args);
  args = CDR(args); sArgList = CAR(args);
  
  ASSERT_TYPE_TAG(rInstance, DBearded2);
  
  DBearded2* pContext = (DBearded2*)R_ExternalPtrAddr(rInstance);
  
  return (pContext->_set_n_ysb1_pars(arg_n_ysb1_pars, sArgList));
}


EXPORT SEXP Bd_get_nt_n_ysb1_pars(SEXP args)
{
  SEXP rInstance;
  SEXP sArgList;
  args = CDR(args); rInstance = CAR(args);
  args = CDR(args); sArgList = CAR(args);
  
  ASSERT_TYPE_TAG(rInstance, DBearded2);
  
  DBearded2* pContext = (DBearded2*)R_ExternalPtrAddr(rInstance);
  
  return (pContext->_get_nt_n_ysb1_pars(sArgList));
}

EXPORT SEXP Bd_set_nt_n_ysb1_pars(SEXP args)
{
  SEXP rInstance;
  SEXP arg_n_ysb1_pars;
  SEXP sArgList;
  
  
  args = CDR(args); rInstance = CAR(args);
  args = CDR(args); arg_n_ysb1_pars = CAR(args);
  args = CDR(args); sArgList = CAR(args);
  
  ASSERT_TYPE_TAG(rInstance, DBearded2);
  
  DBearded2* pContext = (DBearded2*)R_ExternalPtrAddr(rInstance);
  
  return (pContext->_set_nt_n_ysb1_pars(arg_n_ysb1_pars, sArgList));
}


EXPORT SEXP Bd_R_next_param(SEXP args)
{
  SEXP rInstance;
  
  
  args = CDR(args); rInstance = CAR(args);
  
  
  ASSERT_TYPE_TAG(rInstance, DBearded2);
  
  DBearded2* pContext = (DBearded2*)R_ExternalPtrAddr(rInstance);
  
  SEXP Result = pContext->R_next_param();
  
  return (Result);
}

EXPORT SEXP Bd_R_nt_next_param(SEXP args)
{
  SEXP rInstance;
  
  
  args = CDR(args); rInstance = CAR(args);
  
  
  ASSERT_TYPE_TAG(rInstance, DBearded2);
  
  DBearded2* pContext = (DBearded2*)R_ExternalPtrAddr(rInstance);
  
  SEXP Result = pContext->R_nt_next_param();
  
  return (Result);
}

EXPORT SEXP Bd_get_nextpari(SEXP args)
{
  SEXP rInstance;
  args = CDR(args); rInstance = CAR(args);
  
  ASSERT_TYPE_TAG(rInstance, DBearded2);
  
  DBearded2* pContext = (DBearded2*)R_ExternalPtrAddr(rInstance);
  
  return (pContext->_get_nextpari());
}

EXPORT SEXP Bd_set_nextpari(SEXP args)
{
  SEXP rInstance;
  SEXP arg_nextpari;
  
  
  args = CDR(args); rInstance = CAR(args);
  args = CDR(args); arg_nextpari = CAR(args);
  
  ASSERT_TYPE_TAG(rInstance, DBearded2);
  
  DBearded2* pContext = (DBearded2*)R_ExternalPtrAddr(rInstance);
  
  return (pContext->_set_nextpari(arg_nextpari));
}


EXPORT SEXP Bd_R_populate(SEXP args)
{
  SEXP rInstance;
  SEXP dummy;
  
  args = CDR(args); rInstance = CAR(args);
  args = CDR(args); dummy = CAR(args);
  
  ASSERT_TYPE_TAG(rInstance, DBearded2);
  
  DBearded2* pContext = (DBearded2*)R_ExternalPtrAddr(rInstance);
  
  SEXP Result = pContext->R_populate(dummy);
  
  return (Result);
}

EXPORT SEXP Bd_R_nt_populate(SEXP args)
{
  SEXP rInstance;
  SEXP dummy;
  
  args = CDR(args); rInstance = CAR(args);
  args = CDR(args); dummy = CAR(args);
  
  ASSERT_TYPE_TAG(rInstance, DBearded2);
  
  DBearded2* pContext = (DBearded2*)R_ExternalPtrAddr(rInstance);
  
  SEXP Result = pContext->R_nt_populate(dummy);
  
  return (Result);
}

EXPORT SEXP Bd_get_Pr_PO_ytbs(SEXP args)
{
  SEXP rInstance;
  SEXP sArgList;
  args = CDR(args); rInstance = CAR(args);
  args = CDR(args); sArgList = CAR(args);
  
  ASSERT_TYPE_TAG(rInstance, DBearded2);
  
  DBearded2* pContext = (DBearded2*)R_ExternalPtrAddr(rInstance);
  
  return (pContext->_get_Pr_PO_ytbs(sArgList));
}

EXPORT SEXP Bd_set_Pr_PO_ytbs(SEXP args)
{
  SEXP rInstance;
  SEXP arg_Pr_PO_ytbs;
  SEXP sArgList;
  
  
  args = CDR(args); rInstance = CAR(args);
  args = CDR(args); arg_Pr_PO_ytbs = CAR(args);
  args = CDR(args); sArgList = CAR(args);
  
  ASSERT_TYPE_TAG(rInstance, DBearded2);
  
  DBearded2* pContext = (DBearded2*)R_ExternalPtrAddr(rInstance);
  
  return (pContext->_set_Pr_PO_ytbs(arg_Pr_PO_ytbs, sArgList));
}


EXPORT SEXP Bd_get_nt_Pr_PO_ytbs(SEXP args)
{
  SEXP rInstance;
  SEXP sArgList;
  args = CDR(args); rInstance = CAR(args);
  args = CDR(args); sArgList = CAR(args);
  
  ASSERT_TYPE_TAG(rInstance, DBearded2);
  
  DBearded2* pContext = (DBearded2*)R_ExternalPtrAddr(rInstance);
  
  return (pContext->_get_nt_Pr_PO_ytbs(sArgList));
}

EXPORT SEXP Bd_set_nt_Pr_PO_ytbs(SEXP args)
{
  SEXP rInstance;
  SEXP arg_Pr_PO_ytbs;
  SEXP sArgList;
  
  
  args = CDR(args); rInstance = CAR(args);
  args = CDR(args); arg_Pr_PO_ytbs = CAR(args);
  args = CDR(args); sArgList = CAR(args);
  
  ASSERT_TYPE_TAG(rInstance, DBearded2);
  
  DBearded2* pContext = (DBearded2*)R_ExternalPtrAddr(rInstance);
  
  return (pContext->_set_nt_Pr_PO_ytbs(arg_Pr_PO_ytbs, sArgList));
}


EXPORT SEXP Bd_get_pr_po_ytbsb1_pars(SEXP args)
{
  SEXP rInstance;
  SEXP sArgList;
  args = CDR(args); rInstance = CAR(args);
  args = CDR(args); sArgList = CAR(args);
  
  ASSERT_TYPE_TAG(rInstance, DBearded2);
  
  DBearded2* pContext = (DBearded2*)R_ExternalPtrAddr(rInstance);
  
  return (pContext->_get_pr_po_ytbsb1_pars(sArgList));
}

EXPORT SEXP Bd_set_pr_po_ytbsb1_pars(SEXP args)
{
  SEXP rInstance;
  SEXP arg_pr_po_ytbsb1_pars;
  SEXP sArgList;
  
  
  args = CDR(args); rInstance = CAR(args);
  args = CDR(args); arg_pr_po_ytbsb1_pars = CAR(args);
  args = CDR(args); sArgList = CAR(args);
  
  ASSERT_TYPE_TAG(rInstance, DBearded2);
  
  DBearded2* pContext = (DBearded2*)R_ExternalPtrAddr(rInstance);
  
  return (pContext->_set_pr_po_ytbsb1_pars(arg_pr_po_ytbsb1_pars, sArgList));
}


EXPORT SEXP Bd_get_nt_pr_po_ytbsb1_pars(SEXP args)
{
  SEXP rInstance;
  SEXP sArgList;
  args = CDR(args); rInstance = CAR(args);
  args = CDR(args); sArgList = CAR(args);
  
  ASSERT_TYPE_TAG(rInstance, DBearded2);
  
  DBearded2* pContext = (DBearded2*)R_ExternalPtrAddr(rInstance);
  
  return (pContext->_get_nt_pr_po_ytbsb1_pars(sArgList));
}

EXPORT SEXP Bd_set_nt_pr_po_ytbsb1_pars(SEXP args)
{
  SEXP rInstance;
  SEXP arg_pr_po_ytbsb1_pars;
  SEXP sArgList;
  
  
  args = CDR(args); rInstance = CAR(args);
  args = CDR(args); arg_pr_po_ytbsb1_pars = CAR(args);
  args = CDR(args); sArgList = CAR(args);
  
  ASSERT_TYPE_TAG(rInstance, DBearded2);
  
  DBearded2* pContext = (DBearded2*)R_ExternalPtrAddr(rInstance);
  
  return (pContext->_set_nt_pr_po_ytbsb1_pars(arg_pr_po_ytbsb1_pars, sArgList));
}


EXPORT SEXP Bd_get_roi(SEXP args)
{
  SEXP rInstance;
  args = CDR(args); rInstance = CAR(args);
  
  ASSERT_TYPE_TAG(rInstance, DBearded2);
  
  DBearded2* pContext = (DBearded2*)R_ExternalPtrAddr(rInstance);
  
  return (pContext->_get_roi());
}

EXPORT SEXP Bd_set_roi(SEXP args)
{
  SEXP rInstance;
  SEXP arg_roi;
  
  
  args = CDR(args); rInstance = CAR(args);
  args = CDR(args); arg_roi = CAR(args);
  
  ASSERT_TYPE_TAG(rInstance, DBearded2);
  
  DBearded2* pContext = (DBearded2*)R_ExternalPtrAddr(rInstance);
  
  return (pContext->_set_roi(arg_roi));
}


EXPORT SEXP Bd_get_roib1_pars(SEXP args)
{
  SEXP rInstance;
  args = CDR(args); rInstance = CAR(args);
  
  ASSERT_TYPE_TAG(rInstance, DBearded2);
  
  DBearded2* pContext = (DBearded2*)R_ExternalPtrAddr(rInstance);
  
  return (pContext->_get_roib1_pars());
}

EXPORT SEXP Bd_set_roib1_pars(SEXP args)
{
  SEXP rInstance;
  SEXP arg_roib1_pars;
  
  
  args = CDR(args); rInstance = CAR(args);
  args = CDR(args); arg_roib1_pars = CAR(args);
  
  ASSERT_TYPE_TAG(rInstance, DBearded2);
  
  DBearded2* pContext = (DBearded2*)R_ExternalPtrAddr(rInstance);
  
  return (pContext->_set_roib1_pars(arg_roib1_pars));
}


EXPORT SEXP Bd_get_sex(SEXP args)
{
  SEXP rInstance;
  SEXP sArgList;
  args = CDR(args); rInstance = CAR(args);
  args = CDR(args); sArgList = CAR(args);
  
  ASSERT_TYPE_TAG(rInstance, DBearded2);
  
  DBearded2* pContext = (DBearded2*)R_ExternalPtrAddr(rInstance);
  
  return (pContext->_get_sex(sArgList));
}

EXPORT SEXP Bd_set_sex(SEXP args)
{
  SEXP rInstance;
  SEXP arg_sex;
  SEXP sArgList;
  
  
  args = CDR(args); rInstance = CAR(args);
  args = CDR(args); arg_sex = CAR(args);
  args = CDR(args); sArgList = CAR(args);
  
  ASSERT_TYPE_TAG(rInstance, DBearded2);
  
  DBearded2* pContext = (DBearded2*)R_ExternalPtrAddr(rInstance);
  
  return (pContext->_set_sex(arg_sex, sArgList));
}


EXPORT SEXP Bd_get_nt_sex(SEXP args)
{
  SEXP rInstance;
  SEXP sArgList;
  args = CDR(args); rInstance = CAR(args);
  args = CDR(args); sArgList = CAR(args);
  
  ASSERT_TYPE_TAG(rInstance, DBearded2);
  
  DBearded2* pContext = (DBearded2*)R_ExternalPtrAddr(rInstance);
  
  return (pContext->_get_nt_sex(sArgList));
}

EXPORT SEXP Bd_set_nt_sex(SEXP args)
{
  SEXP rInstance;
  SEXP arg_sex;
  SEXP sArgList;
  
  
  args = CDR(args); rInstance = CAR(args);
  args = CDR(args); arg_sex = CAR(args);
  args = CDR(args); sArgList = CAR(args);
  
  ASSERT_TYPE_TAG(rInstance, DBearded2);
  
  DBearded2* pContext = (DBearded2*)R_ExternalPtrAddr(rInstance);
  
  return (pContext->_set_nt_sex(arg_sex, sArgList));
}


EXPORT SEXP Bd_get_sqrt_Pr_PO_ytbs(SEXP args)
{
  SEXP rInstance;
  SEXP sArgList;
  args = CDR(args); rInstance = CAR(args);
  args = CDR(args); sArgList = CAR(args);
  
  ASSERT_TYPE_TAG(rInstance, DBearded2);
  
  DBearded2* pContext = (DBearded2*)R_ExternalPtrAddr(rInstance);
  
  return (pContext->_get_sqrt_Pr_PO_ytbs(sArgList));
}

EXPORT SEXP Bd_set_sqrt_Pr_PO_ytbs(SEXP args)
{
  SEXP rInstance;
  SEXP arg_sqrt_Pr_PO_ytbs;
  SEXP sArgList;
  
  
  args = CDR(args); rInstance = CAR(args);
  args = CDR(args); arg_sqrt_Pr_PO_ytbs = CAR(args);
  args = CDR(args); sArgList = CAR(args);
  
  ASSERT_TYPE_TAG(rInstance, DBearded2);
  
  DBearded2* pContext = (DBearded2*)R_ExternalPtrAddr(rInstance);
  
  return (pContext->_set_sqrt_Pr_PO_ytbs(arg_sqrt_Pr_PO_ytbs, sArgList));
}


EXPORT SEXP Bd_get_nt_sqrt_Pr_PO_ytbs(SEXP args)
{
  SEXP rInstance;
  SEXP sArgList;
  args = CDR(args); rInstance = CAR(args);
  args = CDR(args); sArgList = CAR(args);
  
  ASSERT_TYPE_TAG(rInstance, DBearded2);
  
  DBearded2* pContext = (DBearded2*)R_ExternalPtrAddr(rInstance);
  
  return (pContext->_get_nt_sqrt_Pr_PO_ytbs(sArgList));
}

EXPORT SEXP Bd_set_nt_sqrt_Pr_PO_ytbs(SEXP args)
{
  SEXP rInstance;
  SEXP arg_sqrt_Pr_PO_ytbs;
  SEXP sArgList;
  
  
  args = CDR(args); rInstance = CAR(args);
  args = CDR(args); arg_sqrt_Pr_PO_ytbs = CAR(args);
  args = CDR(args); sArgList = CAR(args);
  
  ASSERT_TYPE_TAG(rInstance, DBearded2);
  
  DBearded2* pContext = (DBearded2*)R_ExternalPtrAddr(rInstance);
  
  return (pContext->_set_nt_sqrt_Pr_PO_ytbs(arg_sqrt_Pr_PO_ytbs, sArgList));
}


EXPORT SEXP Bd_R_sqrt_probs(SEXP args)
{
  SEXP rInstance;
  SEXP pars;
  
  args = CDR(args); rInstance = CAR(args);
  args = CDR(args); pars = CAR(args);
  
  ASSERT_TYPE_TAG(rInstance, DBearded2);
  
  DBearded2* pContext = (DBearded2*)R_ExternalPtrAddr(rInstance);
  
  SEXP Result = pContext->R_sqrt_probs(pars);
  
  return (Result);
}

EXPORT SEXP Bd_R_nt_sqrt_probs(SEXP args)
{
  SEXP rInstance;
  SEXP pars;
  
  args = CDR(args); rInstance = CAR(args);
  args = CDR(args); pars = CAR(args);
  
  ASSERT_TYPE_TAG(rInstance, DBearded2);
  
  DBearded2* pContext = (DBearded2*)R_ExternalPtrAddr(rInstance);
  
  SEXP Result = pContext->R_nt_sqrt_probs(pars);
  
  return (Result);
}

EXPORT SEXP Bd_get_tcap(SEXP args)
{
  SEXP rInstance;
  SEXP sArgList;
  args = CDR(args); rInstance = CAR(args);
  args = CDR(args); sArgList = CAR(args);
  
  ASSERT_TYPE_TAG(rInstance, DBearded2);
  
  DBearded2* pContext = (DBearded2*)R_ExternalPtrAddr(rInstance);
  
  return (pContext->_get_tcap(sArgList));
}

EXPORT SEXP Bd_set_tcap(SEXP args)
{
  SEXP rInstance;
  SEXP arg_tcap;
  SEXP sArgList;
  
  
  args = CDR(args); rInstance = CAR(args);
  args = CDR(args); arg_tcap = CAR(args);
  args = CDR(args); sArgList = CAR(args);
  
  ASSERT_TYPE_TAG(rInstance, DBearded2);
  
  DBearded2* pContext = (DBearded2*)R_ExternalPtrAddr(rInstance);
  
  return (pContext->_set_tcap(arg_tcap, sArgList));
}


EXPORT SEXP Bd_get_nt_tcap(SEXP args)
{
  SEXP rInstance;
  SEXP sArgList;
  args = CDR(args); rInstance = CAR(args);
  args = CDR(args); sArgList = CAR(args);
  
  ASSERT_TYPE_TAG(rInstance, DBearded2);
  
  DBearded2* pContext = (DBearded2*)R_ExternalPtrAddr(rInstance);
  
  return (pContext->_get_nt_tcap(sArgList));
}

EXPORT SEXP Bd_set_nt_tcap(SEXP args)
{
  SEXP rInstance;
  SEXP arg_tcap;
  SEXP sArgList;
  
  
  args = CDR(args); rInstance = CAR(args);
  args = CDR(args); arg_tcap = CAR(args);
  args = CDR(args); sArgList = CAR(args);
  
  ASSERT_TYPE_TAG(rInstance, DBearded2);
  
  DBearded2* pContext = (DBearded2*)R_ExternalPtrAddr(rInstance);
  
  return (pContext->_set_nt_tcap(arg_tcap, sArgList));
}


EXPORT SEXP Bd_get_temp_pars(SEXP args)
{
  SEXP rInstance;
  SEXP sArgList;
  args = CDR(args); rInstance = CAR(args);
  args = CDR(args); sArgList = CAR(args);
  
  ASSERT_TYPE_TAG(rInstance, DBearded2);
  
  DBearded2* pContext = (DBearded2*)R_ExternalPtrAddr(rInstance);
  
  return (pContext->_get_temp_pars(sArgList));
}

EXPORT SEXP Bd_set_temp_pars(SEXP args)
{
  SEXP rInstance;
  SEXP arg_temp_pars;
  SEXP sArgList;
  
  
  args = CDR(args); rInstance = CAR(args);
  args = CDR(args); arg_temp_pars = CAR(args);
  args = CDR(args); sArgList = CAR(args);
  
  ASSERT_TYPE_TAG(rInstance, DBearded2);
  
  DBearded2* pContext = (DBearded2*)R_ExternalPtrAddr(rInstance);
  
  return (pContext->_set_temp_pars(arg_temp_pars, sArgList));
}


EXPORT SEXP Bd_get_nt_temp_pars(SEXP args)
{
  SEXP rInstance;
  SEXP sArgList;
  args = CDR(args); rInstance = CAR(args);
  args = CDR(args); sArgList = CAR(args);
  
  ASSERT_TYPE_TAG(rInstance, DBearded2);
  
  DBearded2* pContext = (DBearded2*)R_ExternalPtrAddr(rInstance);
  
  return (pContext->_get_nt_temp_pars(sArgList));
}

EXPORT SEXP Bd_set_nt_temp_pars(SEXP args)
{
  SEXP rInstance;
  SEXP arg_temp_pars;
  SEXP sArgList;
  
  
  args = CDR(args); rInstance = CAR(args);
  args = CDR(args); arg_temp_pars = CAR(args);
  args = CDR(args); sArgList = CAR(args);
  
  ASSERT_TYPE_TAG(rInstance, DBearded2);
  
  DBearded2* pContext = (DBearded2*)R_ExternalPtrAddr(rInstance);
  
  return (pContext->_set_nt_temp_pars(arg_temp_pars, sArgList));
}


EXPORT SEXP Bd_get_temp_parsb1_pars(SEXP args)
{
  SEXP rInstance;
  SEXP sArgList;
  args = CDR(args); rInstance = CAR(args);
  args = CDR(args); sArgList = CAR(args);
  
  ASSERT_TYPE_TAG(rInstance, DBearded2);
  
  DBearded2* pContext = (DBearded2*)R_ExternalPtrAddr(rInstance);
  
  return (pContext->_get_temp_parsb1_pars(sArgList));
}

EXPORT SEXP Bd_set_temp_parsb1_pars(SEXP args)
{
  SEXP rInstance;
  SEXP arg_temp_parsb1_pars;
  SEXP sArgList;
  
  
  args = CDR(args); rInstance = CAR(args);
  args = CDR(args); arg_temp_parsb1_pars = CAR(args);
  args = CDR(args); sArgList = CAR(args);
  
  ASSERT_TYPE_TAG(rInstance, DBearded2);
  
  DBearded2* pContext = (DBearded2*)R_ExternalPtrAddr(rInstance);
  
  return (pContext->_set_temp_parsb1_pars(arg_temp_parsb1_pars, sArgList));
}


EXPORT SEXP Bd_get_nt_temp_parsb1_pars(SEXP args)
{
  SEXP rInstance;
  SEXP sArgList;
  args = CDR(args); rInstance = CAR(args);
  args = CDR(args); sArgList = CAR(args);
  
  ASSERT_TYPE_TAG(rInstance, DBearded2);
  
  DBearded2* pContext = (DBearded2*)R_ExternalPtrAddr(rInstance);
  
  return (pContext->_get_nt_temp_parsb1_pars(sArgList));
}

EXPORT SEXP Bd_set_nt_temp_parsb1_pars(SEXP args)
{
  SEXP rInstance;
  SEXP arg_temp_parsb1_pars;
  SEXP sArgList;
  
  
  args = CDR(args); rInstance = CAR(args);
  args = CDR(args); arg_temp_parsb1_pars = CAR(args);
  args = CDR(args); sArgList = CAR(args);
  
  ASSERT_TYPE_TAG(rInstance, DBearded2);
  
  DBearded2* pContext = (DBearded2*)R_ExternalPtrAddr(rInstance);
  
  return (pContext->_set_nt_temp_parsb1_pars(arg_temp_parsb1_pars, sArgList));
}


EXPORT SEXP Bd_R_unpack(SEXP args)
{
  SEXP rInstance;
  SEXP pars;
  
  args = CDR(args); rInstance = CAR(args);
  args = CDR(args); pars = CAR(args);
  
  ASSERT_TYPE_TAG(rInstance, DBearded2);
  
  DBearded2* pContext = (DBearded2*)R_ExternalPtrAddr(rInstance);
  
  SEXP Result = pContext->R_unpack(pars);
  
  return (Result);
}

EXPORT SEXP Bd_R_nt_unpack(SEXP args)
{
  SEXP rInstance;
  SEXP pars;
  
  args = CDR(args); rInstance = CAR(args);
  args = CDR(args); pars = CAR(args);
  
  ASSERT_TYPE_TAG(rInstance, DBearded2);
  
  DBearded2* pContext = (DBearded2*)R_ExternalPtrAddr(rInstance);
  
  SEXP Result = pContext->R_nt_unpack(pars);
  
  return (Result);
}

EXPORT SEXP Bd_get_ymat_atmost(SEXP args)
{
  SEXP rInstance;
  SEXP sArgList;
  args = CDR(args); rInstance = CAR(args);
  args = CDR(args); sArgList = CAR(args);
  
  ASSERT_TYPE_TAG(rInstance, DBearded2);
  
  DBearded2* pContext = (DBearded2*)R_ExternalPtrAddr(rInstance);
  
  return (pContext->_get_ymat_atmost(sArgList));
}

EXPORT SEXP Bd_set_ymat_atmost(SEXP args)
{
  SEXP rInstance;
  SEXP arg_ymat_atmost;
  SEXP sArgList;
  
  
  args = CDR(args); rInstance = CAR(args);
  args = CDR(args); arg_ymat_atmost = CAR(args);
  args = CDR(args); sArgList = CAR(args);
  
  ASSERT_TYPE_TAG(rInstance, DBearded2);
  
  DBearded2* pContext = (DBearded2*)R_ExternalPtrAddr(rInstance);
  
  return (pContext->_set_ymat_atmost(arg_ymat_atmost, sArgList));
}


EXPORT SEXP Bd_get_nt_ymat_atmost(SEXP args)
{
  SEXP rInstance;
  SEXP sArgList;
  args = CDR(args); rInstance = CAR(args);
  args = CDR(args); sArgList = CAR(args);
  
  ASSERT_TYPE_TAG(rInstance, DBearded2);
  
  DBearded2* pContext = (DBearded2*)R_ExternalPtrAddr(rInstance);
  
  return (pContext->_get_nt_ymat_atmost(sArgList));
}

EXPORT SEXP Bd_set_nt_ymat_atmost(SEXP args)
{
  SEXP rInstance;
  SEXP arg_ymat_atmost;
  SEXP sArgList;
  
  
  args = CDR(args); rInstance = CAR(args);
  args = CDR(args); arg_ymat_atmost = CAR(args);
  args = CDR(args); sArgList = CAR(args);
  
  ASSERT_TYPE_TAG(rInstance, DBearded2);
  
  DBearded2* pContext = (DBearded2*)R_ExternalPtrAddr(rInstance);
  
  return (pContext->_set_nt_ymat_atmost(arg_ymat_atmost, sArgList));
}

