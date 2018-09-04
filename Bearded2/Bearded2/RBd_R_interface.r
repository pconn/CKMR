require(offarray)

RBd.destroy <- function(Context)
{
  return (.External('_RBd.destroy', Context))
}

RBd.create <- function(first_y, first_y_sample, last_y, n_par, n_samp, n_POP, amat, tcap, a, sex, isamp_POP, jsamp_POP)
{
  return (.External('_RBd.create', as.integer(first_y), as.integer(first_y_sample), as.integer(last_y), as.integer(n_par), as.integer(n_samp), as.integer(n_POP), as.integer(amat), as.integer(tcap), as.integer(a), as.integer(sex), as.integer(isamp_POP), as.integer(jsamp_POP)))
}

