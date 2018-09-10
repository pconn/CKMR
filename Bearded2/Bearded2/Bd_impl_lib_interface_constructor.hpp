
EXPORT void Bd_destroy_handler(SEXP rInstance)
{
  ASSERT_TYPE_TAG(rInstance, DBearded2);
  
  DBearded2* pContext = (DBearded2*)R_ExternalPtrAddr(rInstance);
  
  if (pContext != 0)
  {
    delete pContext;
  }
  
  R_ClearExternalPtr(rInstance);
}

EXPORT SEXP Bd_destroy(SEXP args)
{
  SEXP rInstance;
  args = CDR(args); rInstance = CAR(args);
  Bd_destroy_handler(rInstance);
  
  SEXP Result = allocVector(INTSXP, 1);
  
  PROTECT(Result);
  INTEGER(Result)[0] = 0;
  UNPROTECT(1);
  
  return(Result);
}

EXPORT SEXP Bd_create(SEXP args)
{
  SEXP Result = {0};
  DBearded2* pContext = 0;
  
  SEXP arg_first_y;
  SEXP arg_first_y_sample;
  SEXP arg_last_y;
  SEXP arg_n_par;
  SEXP arg_n_samp;
  SEXP arg_n_POP;
  SEXP arg_n_HS;
  SEXP arg_amat;
  SEXP arg_tcap;
  SEXP arg_a;
  SEXP arg_sex;
  SEXP arg_isamp_POP;
  SEXP arg_jsamp_POP;
  SEXP arg_isamp_HS;
  SEXP arg_jsamp_HS;
  SEXP arg_sex_HS;
  
  args = CDR(args); arg_first_y = CAR(args);
  args = CDR(args); arg_first_y_sample = CAR(args);
  args = CDR(args); arg_last_y = CAR(args);
  args = CDR(args); arg_n_par = CAR(args);
  args = CDR(args); arg_n_samp = CAR(args);
  args = CDR(args); arg_n_POP = CAR(args);
  args = CDR(args); arg_n_HS = CAR(args);
  args = CDR(args); arg_amat = CAR(args);
  args = CDR(args); arg_tcap = CAR(args);
  args = CDR(args); arg_a = CAR(args);
  args = CDR(args); arg_sex = CAR(args);
  args = CDR(args); arg_isamp_POP = CAR(args);
  args = CDR(args); arg_jsamp_POP = CAR(args);
  args = CDR(args); arg_isamp_HS = CAR(args);
  args = CDR(args); arg_jsamp_HS = CAR(args);
  args = CDR(args); arg_sex_HS = CAR(args);
  
  R_CheckArgument("arg_first_y", "INTSXP", INTSXP, arg_first_y, __FILE__, __LINE__);
  
  R_CheckArgument("arg_first_y_sample", "INTSXP", INTSXP, arg_first_y_sample, __FILE__, __LINE__);
  
  R_CheckArgument("arg_last_y", "INTSXP", INTSXP, arg_last_y, __FILE__, __LINE__);
  
  R_CheckArgument("arg_n_par", "INTSXP", INTSXP, arg_n_par, __FILE__, __LINE__);
  
  R_CheckArgument("arg_n_samp", "INTSXP", INTSXP, arg_n_samp, __FILE__, __LINE__);
  
  R_CheckArgument("arg_n_POP", "INTSXP", INTSXP, arg_n_POP, __FILE__, __LINE__);
  
  R_CheckArgument("arg_n_HS", "INTSXP", INTSXP, arg_n_HS, __FILE__, __LINE__);
  
  R_CheckArgument("arg_amat", "INTSXP", INTSXP, arg_amat, __FILE__, __LINE__);
  
  R_CheckArgument("arg_tcap", "INTSXP", INTSXP, arg_tcap, __FILE__, __LINE__, 1, 1, INTEGER(arg_n_samp)[0]);
  
  R_CheckArgument("arg_a", "INTSXP", INTSXP, arg_a, __FILE__, __LINE__, 1, 1, INTEGER(arg_n_samp)[0]);
  
  R_CheckArgument("arg_sex", "INTSXP", INTSXP, arg_sex, __FILE__, __LINE__, 1, 1, INTEGER(arg_n_samp)[0]);
  
  R_CheckArgument("arg_isamp_POP", "INTSXP", INTSXP, arg_isamp_POP, __FILE__, __LINE__, 1, 1, INTEGER(arg_n_POP)[0]);
  
  R_CheckArgument("arg_jsamp_POP", "INTSXP", INTSXP, arg_jsamp_POP, __FILE__, __LINE__, 1, 1, INTEGER(arg_n_POP)[0]);
  
  R_CheckArgument("arg_isamp_HS", "INTSXP", INTSXP, arg_isamp_HS, __FILE__, __LINE__, 1, 1, INTEGER(arg_n_HS)[0]);
  
  R_CheckArgument("arg_jsamp_HS", "INTSXP", INTSXP, arg_jsamp_HS, __FILE__, __LINE__, 1, 1, INTEGER(arg_n_HS)[0]);
  
  R_CheckArgument("arg_sex_HS", "INTSXP", INTSXP, arg_sex_HS, __FILE__, __LINE__, 1, 1, INTEGER(arg_n_HS)[0]);
  
  pContext = new DBearded2(
      INTEGER(arg_first_y)[0], 
      INTEGER(arg_first_y_sample)[0], 
      INTEGER(arg_last_y)[0], 
      INTEGER(arg_n_par)[0], 
      INTEGER(arg_n_samp)[0], 
      INTEGER(arg_n_POP)[0], 
      INTEGER(arg_n_HS)[0], 
      INTEGER(arg_amat)[0], 
      INTEGER(arg_tcap), 
      INTEGER(arg_a), 
      INTEGER(arg_sex), 
      INTEGER(arg_isamp_POP), 
      INTEGER(arg_jsamp_POP), 
      INTEGER(arg_isamp_HS), 
      INTEGER(arg_jsamp_HS), 
      INTEGER(arg_sex_HS));
  
  if (pContext != 0)
  {
    MAKE_R_EXTERNAL_PTR(Result, pContext, Bd_destroy_handler, DBearded2);
  }
  else
  {
    Rf_error("ERROR: Bd_create() failed");
    
    SEXP Result = allocVector(INTSXP, 1);
    
    PROTECT(Result);
    INTEGER(Result)[0] = 0;
    UNPROTECT(1);
  }
  
  return Result;
}
