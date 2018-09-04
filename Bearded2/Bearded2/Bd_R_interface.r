require(offarray)

Bd.destroy <- function(Context)
{
  return (.External('_Bd.destroy', Context))
}

Bd.create <- function(first_y, first_y_sample, last_y, n_par, n_samp, n_POP, amat, tcap, a, sex, isamp_POP, jsamp_POP)
{
  return (.External('_Bd.create', as.integer(first_y), as.integer(first_y_sample), as.integer(last_y), as.integer(n_par), as.integer(n_samp), as.integer(n_POP), as.integer(amat), as.integer(tcap), as.integer(a), as.integer(sex), as.integer(isamp_POP), as.integer(jsamp_POP)))
}

Bd.get.a <- function(Context, ...)
{
  return (.External('_Bd.get.a', Context, list(...)))
}

Bd.set.a <- function(Context, Arg, ...)
{
  return (.External('_Bd.set.a', Context, as.integer(Arg), list(...)))
}

Bd.get.nt.a <- function(Context, ...)
{
  return (.External('_Bd.get.nt.a', Context, list(...)))
}

Bd.set.nt.a <- function(Context, Arg, ...)
{
  return (.External('_Bd.set.nt.a', Context, as.integer(Arg), list(...)))
}

Bd.get.amat <- function(Context)
{
  return (.External('_Bd.get.amat', Context))
}

Bd.set.amat <- function(Context, Arg)
{
  return (.External('_Bd.set.amat', Context, as.integer(Arg)))
}

Bd.get.by <- function(Context, ...)
{
  return (.External('_Bd.get.by', Context, list(...)))
}

Bd.set.by <- function(Context, Arg, ...)
{
  return (.External('_Bd.set.by', Context, as.integer(Arg), list(...)))
}

Bd.get.nt.by <- function(Context, ...)
{
  return (.External('_Bd.get.nt.by', Context, list(...)))
}

Bd.set.nt.by <- function(Context, Arg, ...)
{
  return (.External('_Bd.set.nt.by', Context, as.integer(Arg), list(...)))
}

Bd.calc_probs <- function(Context, dummy)
{
  return (.External('_Bd.calc_probs', Context, dummy))
}

Bd.nt.calc_probs <- function(Context, dummy)
{
  return (.External('_Bd.nt.calc_probs', Context, dummy))
}

Bd.get.first_y <- function(Context)
{
  return (.External('_Bd.get.first_y', Context))
}

Bd.set.first_y <- function(Context, Arg)
{
  return (.External('_Bd.set.first_y', Context, as.integer(Arg)))
}

Bd.get.first_y_sample <- function(Context)
{
  return (.External('_Bd.get.first_y_sample', Context))
}

Bd.set.first_y_sample <- function(Context, Arg)
{
  return (.External('_Bd.set.first_y_sample', Context, as.integer(Arg)))
}

Bd.get.inv_totfec_ys <- function(Context, ...)
{
  return (.External('_Bd.get.inv_totfec_ys', Context, list(...)))
}

Bd.set.inv_totfec_ys <- function(Context, Arg, ...)
{
  return (.External('_Bd.set.inv_totfec_ys', Context, as.double(Arg), list(...)))
}

Bd.get.nt.inv_totfec_ys <- function(Context, ...)
{
  return (.External('_Bd.get.nt.inv_totfec_ys', Context, list(...)))
}

Bd.set.nt.inv_totfec_ys <- function(Context, Arg, ...)
{
  return (.External('_Bd.set.nt.inv_totfec_ys', Context, as.double(Arg), list(...)))
}

Bd.get.inv_totfec_ysb1_pars <- function(Context, ...)
{
  return (.External('_Bd.get.inv_totfec_ysb1_pars', Context, list(...)))
}

Bd.set.inv_totfec_ysb1_pars <- function(Context, Arg, ...)
{
  return (.External('_Bd.set.inv_totfec_ysb1_pars', Context, as.double(Arg), list(...)))
}

Bd.get.nt.inv_totfec_ysb1_pars <- function(Context, ...)
{
  return (.External('_Bd.get.nt.inv_totfec_ysb1_pars', Context, list(...)))
}

Bd.set.nt.inv_totfec_ysb1_pars <- function(Context, Arg, ...)
{
  return (.External('_Bd.set.nt.inv_totfec_ysb1_pars', Context, as.double(Arg), list(...)))
}

Bd.get.isamp_POP <- function(Context, ...)
{
  return (.External('_Bd.get.isamp_POP', Context, list(...)))
}

Bd.set.isamp_POP <- function(Context, Arg, ...)
{
  return (.External('_Bd.set.isamp_POP', Context, as.integer(Arg), list(...)))
}

Bd.get.nt.isamp_POP <- function(Context, ...)
{
  return (.External('_Bd.get.nt.isamp_POP', Context, list(...)))
}

Bd.set.nt.isamp_POP <- function(Context, Arg, ...)
{
  return (.External('_Bd.set.nt.isamp_POP', Context, as.integer(Arg), list(...)))
}

Bd.get.jsamp_POP <- function(Context, ...)
{
  return (.External('_Bd.get.jsamp_POP', Context, list(...)))
}

Bd.set.jsamp_POP <- function(Context, Arg, ...)
{
  return (.External('_Bd.set.jsamp_POP', Context, as.integer(Arg), list(...)))
}

Bd.get.nt.jsamp_POP <- function(Context, ...)
{
  return (.External('_Bd.get.nt.jsamp_POP', Context, list(...)))
}

Bd.set.nt.jsamp_POP <- function(Context, Arg, ...)
{
  return (.External('_Bd.set.nt.jsamp_POP', Context, as.integer(Arg), list(...)))
}

Bd.get.last_y <- function(Context)
{
  return (.External('_Bd.get.last_y', Context))
}

Bd.set.last_y <- function(Context, Arg)
{
  return (.External('_Bd.set.last_y', Context, as.integer(Arg)))
}

Bd.lglk <- function(Context, pars)
{
  return (.External('_Bd.lglk', Context, pars))
}

Bd.nt.lglk <- function(Context, pars)
{
  return (.External('_Bd.nt.lglk', Context, pars))
}

Bd.LGLK_BPARS <- function(Context, pars, parsb1_pars, lglkb1_pars)
{
  return (.External('_Bd.LGLK_BPARS', Context, pars, parsb1_pars, lglkb1_pars))
}

Bd.nt.LGLK_BPARS <- function(Context, pars, parsb1_pars, lglkb1_pars)
{
  return (.External('_Bd.nt.LGLK_BPARS', Context, pars, parsb1_pars, lglkb1_pars))
}

Bd.make_data_summaries <- function(Context)
{
  return (.External('_Bd.make_data_summaries', Context))
}

Bd.nt.make_data_summaries <- function(Context)
{
  return (.External('_Bd.nt.make_data_summaries', Context))
}

Bd.get.N0_f <- function(Context)
{
  return (.External('_Bd.get.N0_f', Context))
}

Bd.set.N0_f <- function(Context, Arg)
{
  return (.External('_Bd.set.N0_f', Context, as.double(Arg)))
}

Bd.get.n0_fb1_pars <- function(Context)
{
  return (.External('_Bd.get.n0_fb1_pars', Context))
}

Bd.set.n0_fb1_pars <- function(Context, Arg)
{
  return (.External('_Bd.set.n0_fb1_pars', Context, as.double(Arg)))
}

Bd.get.N0_m <- function(Context)
{
  return (.External('_Bd.get.N0_m', Context))
}

Bd.set.N0_m <- function(Context, Arg)
{
  return (.External('_Bd.set.N0_m', Context, as.double(Arg)))
}

Bd.get.n0_mb1_pars <- function(Context)
{
  return (.External('_Bd.get.n0_mb1_pars', Context))
}

Bd.set.n0_mb1_pars <- function(Context, Arg)
{
  return (.External('_Bd.set.n0_mb1_pars', Context, as.double(Arg)))
}

Bd.get.n_comps_ytbsm <- function(Context, ...)
{
  return (.External('_Bd.get.n_comps_ytbsm', Context, list(...)))
}

Bd.set.n_comps_ytbsm <- function(Context, Arg, ...)
{
  return (.External('_Bd.set.n_comps_ytbsm', Context, as.integer(Arg), list(...)))
}

Bd.get.nt.n_comps_ytbsm <- function(Context, ...)
{
  return (.External('_Bd.get.nt.n_comps_ytbsm', Context, list(...)))
}

Bd.set.nt.n_comps_ytbsm <- function(Context, Arg, ...)
{
  return (.External('_Bd.set.nt.n_comps_ytbsm', Context, as.integer(Arg), list(...)))
}

Bd.get.n_par <- function(Context)
{
  return (.External('_Bd.get.n_par', Context))
}

Bd.set.n_par <- function(Context, Arg)
{
  return (.External('_Bd.set.n_par', Context, as.integer(Arg)))
}

Bd.get.n_POP <- function(Context)
{
  return (.External('_Bd.get.n_POP', Context))
}

Bd.set.n_POP <- function(Context, Arg)
{
  return (.External('_Bd.set.n_POP', Context, as.integer(Arg)))
}

Bd.get.n_samp <- function(Context)
{
  return (.External('_Bd.get.n_samp', Context))
}

Bd.set.n_samp <- function(Context, Arg)
{
  return (.External('_Bd.set.n_samp', Context, as.integer(Arg)))
}

Bd.get.N_ys <- function(Context, ...)
{
  return (.External('_Bd.get.N_ys', Context, list(...)))
}

Bd.set.N_ys <- function(Context, Arg, ...)
{
  return (.External('_Bd.set.N_ys', Context, as.double(Arg), list(...)))
}

Bd.get.nt.N_ys <- function(Context, ...)
{
  return (.External('_Bd.get.nt.N_ys', Context, list(...)))
}

Bd.set.nt.N_ys <- function(Context, Arg, ...)
{
  return (.External('_Bd.set.nt.N_ys', Context, as.double(Arg), list(...)))
}

Bd.get.n_ysb1_pars <- function(Context, ...)
{
  return (.External('_Bd.get.n_ysb1_pars', Context, list(...)))
}

Bd.set.n_ysb1_pars <- function(Context, Arg, ...)
{
  return (.External('_Bd.set.n_ysb1_pars', Context, as.double(Arg), list(...)))
}

Bd.get.nt.n_ysb1_pars <- function(Context, ...)
{
  return (.External('_Bd.get.nt.n_ysb1_pars', Context, list(...)))
}

Bd.set.nt.n_ysb1_pars <- function(Context, Arg, ...)
{
  return (.External('_Bd.set.nt.n_ysb1_pars', Context, as.double(Arg), list(...)))
}

Bd.next_param <- function(Context)
{
  return (.External('_Bd.next_param', Context))
}

Bd.nt.next_param <- function(Context)
{
  return (.External('_Bd.nt.next_param', Context))
}

Bd.get.nextpari <- function(Context)
{
  return (.External('_Bd.get.nextpari', Context))
}

Bd.set.nextpari <- function(Context, Arg)
{
  return (.External('_Bd.set.nextpari', Context, as.integer(Arg)))
}

Bd.populate <- function(Context, dummy)
{
  return (.External('_Bd.populate', Context, dummy))
}

Bd.nt.populate <- function(Context, dummy)
{
  return (.External('_Bd.nt.populate', Context, dummy))
}

Bd.get.Pr_PO_ytbs <- function(Context, ...)
{
  return (.External('_Bd.get.Pr_PO_ytbs', Context, list(...)))
}

Bd.set.Pr_PO_ytbs <- function(Context, Arg, ...)
{
  return (.External('_Bd.set.Pr_PO_ytbs', Context, as.double(Arg), list(...)))
}

Bd.get.nt.Pr_PO_ytbs <- function(Context, ...)
{
  return (.External('_Bd.get.nt.Pr_PO_ytbs', Context, list(...)))
}

Bd.set.nt.Pr_PO_ytbs <- function(Context, Arg, ...)
{
  return (.External('_Bd.set.nt.Pr_PO_ytbs', Context, as.double(Arg), list(...)))
}

Bd.get.pr_po_ytbsb1_pars <- function(Context, ...)
{
  return (.External('_Bd.get.pr_po_ytbsb1_pars', Context, list(...)))
}

Bd.set.pr_po_ytbsb1_pars <- function(Context, Arg, ...)
{
  return (.External('_Bd.set.pr_po_ytbsb1_pars', Context, as.double(Arg), list(...)))
}

Bd.get.nt.pr_po_ytbsb1_pars <- function(Context, ...)
{
  return (.External('_Bd.get.nt.pr_po_ytbsb1_pars', Context, list(...)))
}

Bd.set.nt.pr_po_ytbsb1_pars <- function(Context, Arg, ...)
{
  return (.External('_Bd.set.nt.pr_po_ytbsb1_pars', Context, as.double(Arg), list(...)))
}

Bd.get.roi <- function(Context)
{
  return (.External('_Bd.get.roi', Context))
}

Bd.set.roi <- function(Context, Arg)
{
  return (.External('_Bd.set.roi', Context, as.double(Arg)))
}

Bd.get.roib1_pars <- function(Context)
{
  return (.External('_Bd.get.roib1_pars', Context))
}

Bd.set.roib1_pars <- function(Context, Arg)
{
  return (.External('_Bd.set.roib1_pars', Context, as.double(Arg)))
}

Bd.get.sex <- function(Context, ...)
{
  return (.External('_Bd.get.sex', Context, list(...)))
}

Bd.set.sex <- function(Context, Arg, ...)
{
  return (.External('_Bd.set.sex', Context, as.integer(Arg), list(...)))
}

Bd.get.nt.sex <- function(Context, ...)
{
  return (.External('_Bd.get.nt.sex', Context, list(...)))
}

Bd.set.nt.sex <- function(Context, Arg, ...)
{
  return (.External('_Bd.set.nt.sex', Context, as.integer(Arg), list(...)))
}

Bd.get.sqrt_Pr_PO_ytbs <- function(Context, ...)
{
  return (.External('_Bd.get.sqrt_Pr_PO_ytbs', Context, list(...)))
}

Bd.set.sqrt_Pr_PO_ytbs <- function(Context, Arg, ...)
{
  return (.External('_Bd.set.sqrt_Pr_PO_ytbs', Context, as.double(Arg), list(...)))
}

Bd.get.nt.sqrt_Pr_PO_ytbs <- function(Context, ...)
{
  return (.External('_Bd.get.nt.sqrt_Pr_PO_ytbs', Context, list(...)))
}

Bd.set.nt.sqrt_Pr_PO_ytbs <- function(Context, Arg, ...)
{
  return (.External('_Bd.set.nt.sqrt_Pr_PO_ytbs', Context, as.double(Arg), list(...)))
}

Bd.sqrt_probs <- function(Context, pars)
{
  return (.External('_Bd.sqrt_probs', Context, pars))
}

Bd.nt.sqrt_probs <- function(Context, pars)
{
  return (.External('_Bd.nt.sqrt_probs', Context, pars))
}

Bd.get.tcap <- function(Context, ...)
{
  return (.External('_Bd.get.tcap', Context, list(...)))
}

Bd.set.tcap <- function(Context, Arg, ...)
{
  return (.External('_Bd.set.tcap', Context, as.integer(Arg), list(...)))
}

Bd.get.nt.tcap <- function(Context, ...)
{
  return (.External('_Bd.get.nt.tcap', Context, list(...)))
}

Bd.set.nt.tcap <- function(Context, Arg, ...)
{
  return (.External('_Bd.set.nt.tcap', Context, as.integer(Arg), list(...)))
}

Bd.get.temp_pars <- function(Context, ...)
{
  return (.External('_Bd.get.temp_pars', Context, list(...)))
}

Bd.set.temp_pars <- function(Context, Arg, ...)
{
  return (.External('_Bd.set.temp_pars', Context, as.double(Arg), list(...)))
}

Bd.get.nt.temp_pars <- function(Context, ...)
{
  return (.External('_Bd.get.nt.temp_pars', Context, list(...)))
}

Bd.set.nt.temp_pars <- function(Context, Arg, ...)
{
  return (.External('_Bd.set.nt.temp_pars', Context, as.double(Arg), list(...)))
}

Bd.get.temp_parsb1_pars <- function(Context, ...)
{
  return (.External('_Bd.get.temp_parsb1_pars', Context, list(...)))
}

Bd.set.temp_parsb1_pars <- function(Context, Arg, ...)
{
  return (.External('_Bd.set.temp_parsb1_pars', Context, as.double(Arg), list(...)))
}

Bd.get.nt.temp_parsb1_pars <- function(Context, ...)
{
  return (.External('_Bd.get.nt.temp_parsb1_pars', Context, list(...)))
}

Bd.set.nt.temp_parsb1_pars <- function(Context, Arg, ...)
{
  return (.External('_Bd.set.nt.temp_parsb1_pars', Context, as.double(Arg), list(...)))
}

Bd.unpack <- function(Context, pars)
{
  return (.External('_Bd.unpack', Context, pars))
}

Bd.nt.unpack <- function(Context, pars)
{
  return (.External('_Bd.nt.unpack', Context, pars))
}

Bd.get.ymat_atmost <- function(Context, ...)
{
  return (.External('_Bd.get.ymat_atmost', Context, list(...)))
}

Bd.set.ymat_atmost <- function(Context, Arg, ...)
{
  return (.External('_Bd.set.ymat_atmost', Context, as.integer(Arg), list(...)))
}

Bd.get.nt.ymat_atmost <- function(Context, ...)
{
  return (.External('_Bd.get.nt.ymat_atmost', Context, list(...)))
}

Bd.set.nt.ymat_atmost <- function(Context, Arg, ...)
{
  return (.External('_Bd.set.nt.ymat_atmost', Context, as.integer(Arg), list(...)))
}

