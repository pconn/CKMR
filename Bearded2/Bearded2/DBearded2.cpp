//  ----------------------------------------------------------------------------
//  ADT generated file implementing class DBearded2
//  ----------------------------------------------------------------------------

#include "Bearded2.hpp"



#include "DBearded2.hpp"


DBearded2::DBearded2(int arg_first_y, int arg_first_y_sample, int arg_last_y, int arg_n_par, int arg_n_samp, int arg_n_POP, int arg_amat, const ARRAY_1I arg_tcap, const ARRAY_1I arg_a, const ARRAY_1I arg_sex, const ARRAY_1I arg_isamp_POP, const ARRAY_1I arg_jsamp_POP)
 : Bearded2(arg_first_y,arg_first_y_sample,arg_last_y,arg_n_par,arg_n_samp,arg_n_POP,arg_amat,arg_tcap,arg_a,arg_sex,arg_isamp_POP,arg_jsamp_POP)
{
  create(inv_totfec_ysb1_pars,inv_totfec_ys);
  n0_fb1_pars = 0;
  n0_mb1_pars = 0;
  create(n_ysb1_pars,N_ys);
  create(pr_po_ytbsb1_pars,Pr_PO_ytbs);
  roib1_pars = 0;
  create(temp_parsb1_pars,temp_pars);
  createStack(i4stack_2_1);
  i4stack_2_1i = 0;
  createStack(r4stack_2_1);
  r4stack_2_1i = 0;
  createStack(i4stack_3_1);
  i4stack_3_1i = 0;
  createStack(i4stack_4_1);
  i4stack_4_1i = 0;
  createStack(r4stack_4_1);
  r4stack_4_1i = 0;
  createStack(i4stack_5_1);
  i4stack_5_1i = 0;
  createStack(r8stack_5_1);
  r8stack_5_1i = 0;
}



DBearded2::DBearded2(const DBearded2& rCopy)
 : Bearded2(rCopy)
{
  create(inv_totfec_ysb1_pars,inv_totfec_ys);
  n0_fb1_pars = 0;
  n0_mb1_pars = 0;
  create(n_ysb1_pars,N_ys);
  create(pr_po_ytbsb1_pars,Pr_PO_ytbs);
  roib1_pars = 0;
  create(temp_parsb1_pars,temp_pars);
  createStack(i4stack_2_1);
  i4stack_2_1i = 0;
  createStack(r4stack_2_1);
  r4stack_2_1i = 0;
  createStack(i4stack_3_1);
  i4stack_3_1i = 0;
  createStack(i4stack_4_1);
  i4stack_4_1i = 0;
  createStack(r4stack_4_1);
  r4stack_4_1i = 0;
  createStack(i4stack_5_1);
  i4stack_5_1i = 0;
  createStack(r8stack_5_1);
  r8stack_5_1i = 0;
}



DBearded2::~DBearded2()
{
  destroy(inv_totfec_ysb1_pars);
  destroy(n_ysb1_pars);
  destroy(pr_po_ytbsb1_pars);
  destroy(temp_parsb1_pars);
  destroy(i4stack_2_1);
  destroy(r4stack_2_1);
  destroy(i4stack_3_1);
  destroy(i4stack_4_1);
  destroy(r4stack_4_1);
  destroy(i4stack_5_1);
  destroy(r8stack_5_1);
}


//   Hide the next bit from  ADT; for one thing, strings aren't understood...
//   but there never any reason to AD this, so don't
//   unpack
//   Helper for unpack

double DBearded2::NEXT_PARAM_CB()
{
  double val;
  double ret_NEXT_PARAM_CB;
  val = temp_pars[nextpari];
  nextpari = nextpari + 1;
  ret_NEXT_PARAM_CB = val;
  return (ret_NEXT_PARAM_CB);
}


//   Differentiation of bearded2__lglk in reverse (adjoint) mode:
//    gradient     of useful results: bearded2__lglk
//    with respect to varying inputs: pars
//    RW status of diff variables: roi:(loc) inv_totfec_ys:(loc)
//                 n_ys:(loc) temp_pars:(loc) n0_f:(loc) pr_po_ytbs:(loc)
//                 n0_m:(loc) bearded2__lglk:in-killed pars:out
//  isex
//   oby
//   pcapt
//   pmaty
//   calc_probs
//   ----------------------------------------------------------------------------
//   Log-likelihood

void DBearded2::LGLK_BPARS(const ARRAY_1D pars/* n_par */, ARRAY_1D parsb1_pars/* n_par */, double& lglkb1_pars)
{
  int ad_count;
  int ad_count0;
  int ad_count1;
  int ad_count2;
  int ad_count3;
  int ad_count4;
  int ad_count5;
  int ad_count6;
  double arg1;
  double arg1b1_pars;
  int i;
  int i0;
  int i1;
  int i2;
  int i3;
  int i4;
  int i5;
  int i6;
  int isex;
  int ix_0___;
  int ix_1___;
  int ix_2___;
  int ix_3___;
  int oby;
  int pby;
  int pcapt;
  double result1b1_pars;
  double tot_lglkb1_pars;
  
  for (ix_0___ = 1;ix_0___ <= (1 + n_par - 1); ++ix_0___)
  {
    r4stack_2_1i = r4stack_2_1i + 1;
    
    if (r4stack_2_1i > stackSizeInt(r4stack_2_1))
    {
      growStack(r4stack_2_1,r4stack_2_1i);
    }
    
    r4stack_2_1[r4stack_2_1i] = temp_pars[ix_0___];
  }
  
  UNPACK_CB(pars);
  
  for (ix_0___ = first_y;ix_0___ <= (first_y + (last_y - first_y + 1) - 1); ++ix_0___)
  {
    for (ix_1___ = 0;ix_1___ <= (0 + 2 - 1); ++ix_1___)
    {
      r4stack_2_1i = r4stack_2_1i + 1;
      
      if (r4stack_2_1i > stackSizeInt(r4stack_2_1))
      {
        growStack(r4stack_2_1,r4stack_2_1i);
      }
      
      r4stack_2_1[r4stack_2_1i] = N_ys[ix_0___][ix_1___];
    }
  }
  
  populate(0);
  calc_probs(0);
  pby = first_y;
  ad_count2 = 0;
  
  while ((pby <= last_y))
  {
    pcapt = first_y;
    ad_count1 = 0;
    
    while ((pcapt <= last_y))
    {
      oby = first_y;
      ad_count0 = 0;
      
      while ((oby <= last_y))
      {
        isex = 0;
        ad_count = 0;
        
        while ((isex <= 1))
        {
          i4stack_2_1i = i4stack_2_1i + 1;
          
          if (i4stack_2_1i > stackSizeInt(i4stack_2_1))
          {
            growStack(i4stack_2_1,i4stack_2_1i);
          }
          
          i4stack_2_1[i4stack_2_1i] = isex;
          isex = isex + 1;
          ad_count = ad_count + 1;
        }
        
        i4stack_2_1i = i4stack_2_1i + 1;
        
        if (i4stack_2_1i > stackSizeInt(i4stack_2_1))
        {
          growStack(i4stack_2_1,i4stack_2_1i);
        }
        
        i4stack_2_1[i4stack_2_1i] = ad_count;
        i4stack_2_1i = i4stack_2_1i + 1;
        
        if (i4stack_2_1i > stackSizeInt(i4stack_2_1))
        {
          growStack(i4stack_2_1,i4stack_2_1i);
        }
        
        i4stack_2_1[i4stack_2_1i] = oby;
        oby = oby + 1;
        ad_count0 = ad_count0 + 1;
      }
      
      i4stack_2_1i = i4stack_2_1i + 1;
      
      if (i4stack_2_1i > stackSizeInt(i4stack_2_1))
      {
        growStack(i4stack_2_1,i4stack_2_1i);
      }
      
      i4stack_2_1[i4stack_2_1i] = ad_count0;
      i4stack_2_1i = i4stack_2_1i + 1;
      
      if (i4stack_2_1i > stackSizeInt(i4stack_2_1))
      {
        growStack(i4stack_2_1,i4stack_2_1i);
      }
      
      i4stack_2_1[i4stack_2_1i] = pcapt;
      pcapt = pcapt + 1;
      ad_count1 = ad_count1 + 1;
    }
    
    i4stack_2_1i = i4stack_2_1i + 1;
    
    if (i4stack_2_1i > stackSizeInt(i4stack_2_1))
    {
      growStack(i4stack_2_1,i4stack_2_1i);
    }
    
    i4stack_2_1[i4stack_2_1i] = ad_count1;
    i4stack_2_1i = i4stack_2_1i + 1;
    
    if (i4stack_2_1i > stackSizeInt(i4stack_2_1))
    {
      growStack(i4stack_2_1,i4stack_2_1i);
    }
    
    i4stack_2_1[i4stack_2_1i] = pby;
    pby = pby + 1;
    ad_count2 = ad_count2 + 1;
  }
  
  i4stack_2_1i = i4stack_2_1i + 1;
  
  if (i4stack_2_1i > stackSizeInt(i4stack_2_1))
  {
    growStack(i4stack_2_1,i4stack_2_1i);
  }
  
  i4stack_2_1[i4stack_2_1i] = ad_count2;
  //  isex
  //   oby
  //   pcapt
  //   pmaty
  pby = first_y;
  ad_count6 = 0;
  
  while ((pby <= last_y))
  {
    pcapt = first_y;
    ad_count5 = 0;
    
    while ((pcapt <= last_y))
    {
      oby = first_y;
      ad_count4 = 0;
      
      while ((oby <= last_y))
      {
        isex = 0;
        ad_count3 = 0;
        
        while ((isex <= 1))
        {
          i4stack_2_1i = i4stack_2_1i + 1;
          
          if (i4stack_2_1i > stackSizeInt(i4stack_2_1))
          {
            growStack(i4stack_2_1,i4stack_2_1i);
          }
          
          i4stack_2_1[i4stack_2_1i] = isex;
          isex = isex + 1;
          ad_count3 = ad_count3 + 1;
        }
        
        i4stack_2_1i = i4stack_2_1i + 1;
        
        if (i4stack_2_1i > stackSizeInt(i4stack_2_1))
        {
          growStack(i4stack_2_1,i4stack_2_1i);
        }
        
        i4stack_2_1[i4stack_2_1i] = ad_count3;
        i4stack_2_1i = i4stack_2_1i + 1;
        
        if (i4stack_2_1i > stackSizeInt(i4stack_2_1))
        {
          growStack(i4stack_2_1,i4stack_2_1i);
        }
        
        i4stack_2_1[i4stack_2_1i] = oby;
        oby = oby + 1;
        ad_count4 = ad_count4 + 1;
      }
      
      i4stack_2_1i = i4stack_2_1i + 1;
      
      if (i4stack_2_1i > stackSizeInt(i4stack_2_1))
      {
        growStack(i4stack_2_1,i4stack_2_1i);
      }
      
      i4stack_2_1[i4stack_2_1i] = ad_count4;
      i4stack_2_1i = i4stack_2_1i + 1;
      
      if (i4stack_2_1i > stackSizeInt(i4stack_2_1))
      {
        growStack(i4stack_2_1,i4stack_2_1i);
      }
      
      i4stack_2_1[i4stack_2_1i] = pcapt;
      pcapt = pcapt + 1;
      ad_count5 = ad_count5 + 1;
    }
    
    i4stack_2_1i = i4stack_2_1i + 1;
    
    if (i4stack_2_1i > stackSizeInt(i4stack_2_1))
    {
      growStack(i4stack_2_1,i4stack_2_1i);
    }
    
    i4stack_2_1[i4stack_2_1i] = ad_count5;
    i4stack_2_1i = i4stack_2_1i + 1;
    
    if (i4stack_2_1i > stackSizeInt(i4stack_2_1))
    {
      growStack(i4stack_2_1,i4stack_2_1i);
    }
    
    i4stack_2_1[i4stack_2_1i] = pby;
    pby = pby + 1;
    ad_count6 = ad_count6 + 1;
  }
  
  i4stack_2_1i = i4stack_2_1i + 1;
  
  if (i4stack_2_1i > stackSizeInt(i4stack_2_1))
  {
    growStack(i4stack_2_1,i4stack_2_1i);
  }
  
  i4stack_2_1[i4stack_2_1i] = ad_count6;
  tot_lglkb1_pars = lglkb1_pars;
  
  for (ix_3___ = 0;ix_3___ <= 1; ++ix_3___)
  {
    for (ix_2___ = first_y;ix_2___ <= last_y; ++ix_2___)
    {
      for (ix_1___ = first_y;ix_1___ <= last_y; ++ix_1___)
      {
        for (ix_0___ = first_y;ix_0___ <= last_y; ++ix_0___)
        {
          pr_po_ytbsb1_pars[ix_0___][ix_1___][ix_2___][ix_3___] = 0.0;
        }
      }
    }
  }
  
  ad_count6 = i4stack_2_1[i4stack_2_1i];
  i4stack_2_1i = i4stack_2_1i - 1;
  
  for (i6 = 1;i6 <= ad_count6; ++i6)
  {
    pby = i4stack_2_1[i4stack_2_1i];
    i4stack_2_1i = i4stack_2_1i - 1;
    ad_count5 = i4stack_2_1[i4stack_2_1i];
    i4stack_2_1i = i4stack_2_1i - 1;
    
    for (i5 = 1;i5 <= ad_count5; ++i5)
    {
      pcapt = i4stack_2_1[i4stack_2_1i];
      i4stack_2_1i = i4stack_2_1i - 1;
      ad_count4 = i4stack_2_1[i4stack_2_1i];
      i4stack_2_1i = i4stack_2_1i - 1;
      
      for (i4 = 1;i4 <= ad_count4; ++i4)
      {
        oby = i4stack_2_1[i4stack_2_1i];
        i4stack_2_1i = i4stack_2_1i - 1;
        ad_count3 = i4stack_2_1[i4stack_2_1i];
        i4stack_2_1i = i4stack_2_1i - 1;
        
        for (i3 = 1;i3 <= ad_count3; ++i3)
        {
          isex = i4stack_2_1[i4stack_2_1i];
          i4stack_2_1i = i4stack_2_1i - 1;
          result1b1_pars = tot_lglkb1_pars;
          N_LOG_P_BPARS(n_comps_ytbsm[pby][pcapt][oby][isex][1],Pr_PO_ytbs[pby][pcapt][oby][isex],pr_po_ytbsb1_pars[pby][pcapt][oby][isex],result1b1_pars);
        }
      }
    }
  }
  
  ad_count2 = i4stack_2_1[i4stack_2_1i];
  i4stack_2_1i = i4stack_2_1i - 1;
  
  for (i2 = 1;i2 <= ad_count2; ++i2)
  {
    pby = i4stack_2_1[i4stack_2_1i];
    i4stack_2_1i = i4stack_2_1i - 1;
    ad_count1 = i4stack_2_1[i4stack_2_1i];
    i4stack_2_1i = i4stack_2_1i - 1;
    
    for (i1 = 1;i1 <= ad_count1; ++i1)
    {
      pcapt = i4stack_2_1[i4stack_2_1i];
      i4stack_2_1i = i4stack_2_1i - 1;
      ad_count0 = i4stack_2_1[i4stack_2_1i];
      i4stack_2_1i = i4stack_2_1i - 1;
      
      for (i0 = 1;i0 <= ad_count0; ++i0)
      {
        oby = i4stack_2_1[i4stack_2_1i];
        i4stack_2_1i = i4stack_2_1i - 1;
        ad_count = i4stack_2_1[i4stack_2_1i];
        i4stack_2_1i = i4stack_2_1i - 1;
        
        for (i = 1;i <= ad_count; ++i)
        {
          isex = i4stack_2_1[i4stack_2_1i];
          i4stack_2_1i = i4stack_2_1i - 1;
          result1b1_pars = tot_lglkb1_pars;
          arg1 = 1 - Pr_PO_ytbs[pby][pcapt][oby][isex];
          arg1b1_pars = 0.0;
          N_LOG_P_BPARS(n_comps_ytbsm[pby][pcapt][oby][isex][0],arg1,arg1b1_pars,result1b1_pars);
          pr_po_ytbsb1_pars[pby][pcapt][oby][isex] = pr_po_ytbsb1_pars[pby][pcapt][oby][isex] - arg1b1_pars;
        }
      }
    }
  }
  
  CALC_PROBS_BPARS(0);
  
  for (ix_0___ = (first_y + (last_y - first_y + 1) - 1);ix_0___ >= first_y; --ix_0___)
  {
    for (ix_1___ = (0 + 2 - 1);ix_1___ >= 0; --ix_1___)
    {
      N_ys[ix_0___][ix_1___] = r4stack_2_1[r4stack_2_1i];
      r4stack_2_1i = r4stack_2_1i - 1;
    }
  }
  
  POPULATE_BPARS(0);
  
  for (ix_0___ = (1 + n_par - 1);ix_0___ >= 1; --ix_0___)
  {
    temp_pars[ix_0___] = r4stack_2_1[r4stack_2_1i];
    r4stack_2_1i = r4stack_2_1i - 1;
  }
  
  UNPACK_BPARS(pars,parsb1_pars);
}


//   Differentiation of bearded2__calc_probs in reverse (adjoint) mode:
//    gradient     of useful results: pr_po_ytbs
//    with respect to varying inputs: inv_totfec_ys
//  ----------------------------------------------------------------------------
//  isex
//  y
//   populate
//   ---------------------------------------------------------------------------
//   All CKMR probs

void DBearded2::CALC_PROBS_BPARS(int dummy)
{
  int ad_count;
  int ad_count0;
  int ad_count1;
  int ad_count2;
  int i;
  int i0;
  int i1;
  int i2;
  int isex;
  int ix_0___;
  int ix_1___;
  int oby;
  int pby;
  int pcapt;
  int pmaty;
  int result1;
  int result2;
  int result3;
  int result4;
  result1 = 0;
  result2 = 0;
  result3 = 0;
  result4 = 0;
  pby = first_y;
  ad_count2 = 0;
  
  while ((pby <= last_y))
  {
    pcapt = first_y_sample;
    ad_count1 = 0;
    
    while ((pcapt <= last_y))
    {
      oby = first_y;
      ad_count0 = 0;
      
      while ((oby <= last_y))
      {
        isex = 0;
        ad_count = 0;
        
        while ((isex <= 1))
        {
          pmaty = pby + amat;
          i4stack_3_1i = i4stack_3_1i + 1;
          
          if (i4stack_3_1i > stackSizeInt(i4stack_3_1))
          {
            growStack(i4stack_3_1,i4stack_3_1i);
          }
          
          i4stack_3_1[i4stack_3_1i] = result1;
          result1 = one_if((pmaty <= oby));
          i4stack_3_1i = i4stack_3_1i + 1;
          
          if (i4stack_3_1i > stackSizeInt(i4stack_3_1))
          {
            growStack(i4stack_3_1,i4stack_3_1i);
          }
          
          i4stack_3_1[i4stack_3_1i] = result2;
          result2 = one_if((pcapt > oby));
          i4stack_3_1i = i4stack_3_1i + 1;
          
          if (i4stack_3_1i > stackSizeInt(i4stack_3_1))
          {
            growStack(i4stack_3_1,i4stack_3_1i);
          }
          
          i4stack_3_1[i4stack_3_1i] = result3;
          result3 = one_if((pcapt - pby <= 38));
          i4stack_3_1i = i4stack_3_1i + 1;
          
          if (i4stack_3_1i > stackSizeInt(i4stack_3_1))
          {
            growStack(i4stack_3_1,i4stack_3_1i);
          }
          
          i4stack_3_1[i4stack_3_1i] = result4;
          result4 = one_if((pby - oby <= 38));
          i4stack_3_1i = i4stack_3_1i + 1;
          
          if (i4stack_3_1i > stackSizeInt(i4stack_3_1))
          {
            growStack(i4stack_3_1,i4stack_3_1i);
          }
          
          i4stack_3_1[i4stack_3_1i] = isex;
          isex = isex + 1;
          ad_count = ad_count + 1;
        }
        
        i4stack_3_1i = i4stack_3_1i + 1;
        
        if (i4stack_3_1i > stackSizeInt(i4stack_3_1))
        {
          growStack(i4stack_3_1,i4stack_3_1i);
        }
        
        i4stack_3_1[i4stack_3_1i] = ad_count;
        i4stack_3_1i = i4stack_3_1i + 1;
        
        if (i4stack_3_1i > stackSizeInt(i4stack_3_1))
        {
          growStack(i4stack_3_1,i4stack_3_1i);
        }
        
        i4stack_3_1[i4stack_3_1i] = oby;
        oby = oby + 1;
        ad_count0 = ad_count0 + 1;
      }
      
      i4stack_3_1i = i4stack_3_1i + 1;
      
      if (i4stack_3_1i > stackSizeInt(i4stack_3_1))
      {
        growStack(i4stack_3_1,i4stack_3_1i);
      }
      
      i4stack_3_1[i4stack_3_1i] = ad_count0;
      i4stack_3_1i = i4stack_3_1i + 1;
      
      if (i4stack_3_1i > stackSizeInt(i4stack_3_1))
      {
        growStack(i4stack_3_1,i4stack_3_1i);
      }
      
      i4stack_3_1[i4stack_3_1i] = pcapt;
      pcapt = pcapt + 1;
      ad_count1 = ad_count1 + 1;
    }
    
    i4stack_3_1i = i4stack_3_1i + 1;
    
    if (i4stack_3_1i > stackSizeInt(i4stack_3_1))
    {
      growStack(i4stack_3_1,i4stack_3_1i);
    }
    
    i4stack_3_1[i4stack_3_1i] = ad_count1;
    i4stack_3_1i = i4stack_3_1i + 1;
    
    if (i4stack_3_1i > stackSizeInt(i4stack_3_1))
    {
      growStack(i4stack_3_1,i4stack_3_1i);
    }
    
    i4stack_3_1[i4stack_3_1i] = pby;
    pby = pby + 1;
    ad_count2 = ad_count2 + 1;
  }
  
  for (ix_1___ = 0;ix_1___ <= 1; ++ix_1___)
  {
    for (ix_0___ = first_y;ix_0___ <= last_y; ++ix_0___)
    {
      inv_totfec_ysb1_pars[ix_0___][ix_1___] = 0.0;
    }
  }
  
  for (i2 = 1;i2 <= ad_count2; ++i2)
  {
    pby = i4stack_3_1[i4stack_3_1i];
    i4stack_3_1i = i4stack_3_1i - 1;
    ad_count1 = i4stack_3_1[i4stack_3_1i];
    i4stack_3_1i = i4stack_3_1i - 1;
    
    for (i1 = 1;i1 <= ad_count1; ++i1)
    {
      pcapt = i4stack_3_1[i4stack_3_1i];
      i4stack_3_1i = i4stack_3_1i - 1;
      ad_count0 = i4stack_3_1[i4stack_3_1i];
      i4stack_3_1i = i4stack_3_1i - 1;
      
      for (i0 = 1;i0 <= ad_count0; ++i0)
      {
        oby = i4stack_3_1[i4stack_3_1i];
        i4stack_3_1i = i4stack_3_1i - 1;
        ad_count = i4stack_3_1[i4stack_3_1i];
        i4stack_3_1i = i4stack_3_1i - 1;
        
        for (i = 1;i <= ad_count; ++i)
        {
          isex = i4stack_3_1[i4stack_3_1i];
          i4stack_3_1i = i4stack_3_1i - 1;
          inv_totfec_ysb1_pars[oby][isex] = inv_totfec_ysb1_pars[oby][isex] + result3 * result4 * result1 * result2 * pr_po_ytbsb1_pars[pby][pcapt][oby][isex];
          pr_po_ytbsb1_pars[pby][pcapt][oby][isex] = 0.0;
          result4 = i4stack_3_1[i4stack_3_1i];
          i4stack_3_1i = i4stack_3_1i - 1;
          result3 = i4stack_3_1[i4stack_3_1i];
          i4stack_3_1i = i4stack_3_1i - 1;
          result2 = i4stack_3_1[i4stack_3_1i];
          i4stack_3_1i = i4stack_3_1i - 1;
          pmaty = pby + amat;
          result1 = i4stack_3_1[i4stack_3_1i];
          i4stack_3_1i = i4stack_3_1i - 1;
        }
      }
    }
  }
}


//   Differentiation of bearded2__populate in reverse (adjoint) mode:
//    gradient     of useful results: inv_totfec_ys
//    with respect to varying inputs: roi n0_f n0_m
//   next_param
//   ---------------------------------------------------------------------------
//   Fill in pop dyn from parameters. Age-structured version is more interesting

void DBearded2::POPULATE_BPARS(int dummy)
{
  int ad_count;
  int ad_count0;
  int ad_count1;
  int ad_count2;
  int i;
  int i0;
  int i1;
  int i2;
  int isex;
  int ix_0___;
  int ix_1___;
  int y;
  N_ys[first_y][0] = N0_f;
  N_ys[first_y][1] = N0_m;
  y = first_y + 1;
  ad_count0 = 0;
  
  while ((y <= last_y))
  {
    isex = 0;
    ad_count = 0;
    
    while ((isex <= 1))
    {
      r4stack_4_1i = r4stack_4_1i + 1;
      
      if (r4stack_4_1i > stackSizeInt(r4stack_4_1))
      {
        growStack(r4stack_4_1,r4stack_4_1i);
      }
      
      r4stack_4_1[r4stack_4_1i] = N_ys[y][isex];
      N_ys[y][isex] = N_ys[y - 1][isex] * roi;
      i4stack_4_1i = i4stack_4_1i + 1;
      
      if (i4stack_4_1i > stackSizeInt(i4stack_4_1))
      {
        growStack(i4stack_4_1,i4stack_4_1i);
      }
      
      i4stack_4_1[i4stack_4_1i] = isex;
      isex = isex + 1;
      ad_count = ad_count + 1;
    }
    
    i4stack_4_1i = i4stack_4_1i + 1;
    
    if (i4stack_4_1i > stackSizeInt(i4stack_4_1))
    {
      growStack(i4stack_4_1,i4stack_4_1i);
    }
    
    i4stack_4_1[i4stack_4_1i] = ad_count;
    i4stack_4_1i = i4stack_4_1i + 1;
    
    if (i4stack_4_1i > stackSizeInt(i4stack_4_1))
    {
      growStack(i4stack_4_1,i4stack_4_1i);
    }
    
    i4stack_4_1[i4stack_4_1i] = y;
    y = y + 1;
    ad_count0 = ad_count0 + 1;
  }
  
  i4stack_4_1i = i4stack_4_1i + 1;
  
  if (i4stack_4_1i > stackSizeInt(i4stack_4_1))
  {
    growStack(i4stack_4_1,i4stack_4_1i);
  }
  
  i4stack_4_1[i4stack_4_1i] = ad_count0;
  //  isex
  //  y
  //   Might as well do Total Reprod Output here in populate(), though...
  //   could also do in calc_probs. Actually we just need the inverse
  y = first_y;
  ad_count2 = 0;
  
  while ((y <= last_y))
  {
    isex = 0;
    ad_count1 = 0;
    
    while ((isex <= 1))
    {
      i4stack_4_1i = i4stack_4_1i + 1;
      
      if (i4stack_4_1i > stackSizeInt(i4stack_4_1))
      {
        growStack(i4stack_4_1,i4stack_4_1i);
      }
      
      i4stack_4_1[i4stack_4_1i] = isex;
      isex = isex + 1;
      ad_count1 = ad_count1 + 1;
    }
    
    i4stack_4_1i = i4stack_4_1i + 1;
    
    if (i4stack_4_1i > stackSizeInt(i4stack_4_1))
    {
      growStack(i4stack_4_1,i4stack_4_1i);
    }
    
    i4stack_4_1[i4stack_4_1i] = ad_count1;
    i4stack_4_1i = i4stack_4_1i + 1;
    
    if (i4stack_4_1i > stackSizeInt(i4stack_4_1))
    {
      growStack(i4stack_4_1,i4stack_4_1i);
    }
    
    i4stack_4_1[i4stack_4_1i] = y;
    y = y + 1;
    ad_count2 = ad_count2 + 1;
  }
  
  for (ix_1___ = 0;ix_1___ <= 1; ++ix_1___)
  {
    for (ix_0___ = first_y;ix_0___ <= last_y; ++ix_0___)
    {
      n_ysb1_pars[ix_0___][ix_1___] = 0.0;
    }
  }
  
  for (i2 = 1;i2 <= ad_count2; ++i2)
  {
    y = i4stack_4_1[i4stack_4_1i];
    i4stack_4_1i = i4stack_4_1i - 1;
    ad_count1 = i4stack_4_1[i4stack_4_1i];
    i4stack_4_1i = i4stack_4_1i - 1;
    
    for (i1 = 1;i1 <= ad_count1; ++i1)
    {
      isex = i4stack_4_1[i4stack_4_1i];
      i4stack_4_1i = i4stack_4_1i - 1;
      n_ysb1_pars[y][isex] = n_ysb1_pars[y][isex] - inv_totfec_ysb1_pars[y][isex] / pow(N_ys[y][isex],2);
      inv_totfec_ysb1_pars[y][isex] = 0.0;
    }
  }
  
  roib1_pars = 0.0;
  ad_count0 = i4stack_4_1[i4stack_4_1i];
  i4stack_4_1i = i4stack_4_1i - 1;
  
  for (i0 = 1;i0 <= ad_count0; ++i0)
  {
    y = i4stack_4_1[i4stack_4_1i];
    i4stack_4_1i = i4stack_4_1i - 1;
    ad_count = i4stack_4_1[i4stack_4_1i];
    i4stack_4_1i = i4stack_4_1i - 1;
    
    for (i = 1;i <= ad_count; ++i)
    {
      isex = i4stack_4_1[i4stack_4_1i];
      i4stack_4_1i = i4stack_4_1i - 1;
      N_ys[y][isex] = r4stack_4_1[r4stack_4_1i];
      r4stack_4_1i = r4stack_4_1i - 1;
      n_ysb1_pars[y - 1][isex] = n_ysb1_pars[y - 1][isex] + roi * n_ysb1_pars[y][isex];
      roib1_pars = roib1_pars + N_ys[y - 1][isex] * n_ysb1_pars[y][isex];
      n_ysb1_pars[y][isex] = 0.0;
    }
  }
  
  n0_mb1_pars = n_ysb1_pars[first_y][1];
  n_ysb1_pars[first_y][1] = 0.0;
  n0_fb1_pars = n_ysb1_pars[first_y][0];
}


//   Differentiation of bearded2__unpack in reverse (adjoint) mode:
//    gradient     of useful results: roi n0_f n0_m
//    with respect to varying inputs: pars
//   i_POP
//   ... NB I don't mind using if's in the constructor, since it's only run once
//   ... in lglk code, one_if() is faster
//   make_data_summaries
//   ----------------------------------------------------------------------------
//   Unpack R parameter-vector into meaningful pop dyn params

void DBearded2::UNPACK_BPARS(const ARRAY_1D pars/* n_par */, ARRAY_1D parsb1_pars/* n_par */)
{
  int ad_count;
  int i;
  int i0;
  int ix_0___;
  double result1;
  double result1b1_pars;
  //   Surely there is a copy-style function in ADT/C ? No doc of it tho
  //   ADT Pascal has one
  i = 1;
  ad_count = 0;
  
  while ((i <= n_par))
  {
    temp_pars[i] = pars[i];
    i4stack_5_1i = i4stack_5_1i + 1;
    
    if (i4stack_5_1i > stackSizeInt(i4stack_5_1))
    {
      growStack(i4stack_5_1,i4stack_5_1i);
    }
    
    i4stack_5_1[i4stack_5_1i] = i;
    i = i + 1;
    ad_count = ad_count + 1;
  }
  
  i4stack_5_1i = i4stack_5_1i + 1;
  
  if (i4stack_5_1i > stackSizeInt(i4stack_5_1))
  {
    growStack(i4stack_5_1,i4stack_5_1i);
  }
  
  i4stack_5_1[i4stack_5_1i] = ad_count;
  nextpari = 1;
  i4stack_5_1i = i4stack_5_1i + 1;
  
  if (i4stack_5_1i > stackSizeInt(i4stack_5_1))
  {
    growStack(i4stack_5_1,i4stack_5_1i);
  }
  
  i4stack_5_1[i4stack_5_1i] = nextpari;
  result1 = NEXT_PARAM_CB();
  i4stack_5_1i = i4stack_5_1i + 1;
  
  if (i4stack_5_1i > stackSizeInt(i4stack_5_1))
  {
    growStack(i4stack_5_1,i4stack_5_1i);
  }
  
  i4stack_5_1[i4stack_5_1i] = nextpari;
  r8stack_5_1i = r8stack_5_1i + 1;
  
  if (r8stack_5_1i > stackSizeInt(r8stack_5_1))
  {
    growStack(r8stack_5_1,r8stack_5_1i);
  }
  
  r8stack_5_1[r8stack_5_1i] = result1;
  result1 = NEXT_PARAM_CB();
  i4stack_5_1i = i4stack_5_1i + 1;
  
  if (i4stack_5_1i > stackSizeInt(i4stack_5_1))
  {
    growStack(i4stack_5_1,i4stack_5_1i);
  }
  
  i4stack_5_1[i4stack_5_1i] = nextpari;
  r8stack_5_1i = r8stack_5_1i + 1;
  
  if (r8stack_5_1i > stackSizeInt(r8stack_5_1))
  {
    growStack(r8stack_5_1,r8stack_5_1i);
  }
  
  r8stack_5_1[r8stack_5_1i] = result1;
  result1 = NEXT_PARAM_CB();
  result1b1_pars = exp(result1) * n0_mb1_pars;
  result1 = r8stack_5_1[r8stack_5_1i];
  r8stack_5_1i = r8stack_5_1i - 1;
  nextpari = i4stack_5_1[i4stack_5_1i];
  i4stack_5_1i = i4stack_5_1i - 1;
  
  for (ix_0___ = 1;ix_0___ <= n_par; ++ix_0___)
  {
    temp_parsb1_pars[ix_0___] = 0.0;
  }
  
  NEXT_PARAM_BPARS(result1b1_pars);
  result1b1_pars = exp(result1) * n0_fb1_pars;
  result1 = r8stack_5_1[r8stack_5_1i];
  r8stack_5_1i = r8stack_5_1i - 1;
  nextpari = i4stack_5_1[i4stack_5_1i];
  i4stack_5_1i = i4stack_5_1i - 1;
  NEXT_PARAM_BPARS(result1b1_pars);
  result1b1_pars = exp(result1) * roib1_pars;
  nextpari = i4stack_5_1[i4stack_5_1i];
  i4stack_5_1i = i4stack_5_1i - 1;
  NEXT_PARAM_BPARS(result1b1_pars);
  
  for (ix_0___ = 1;ix_0___ <= n_par; ++ix_0___)
  {
    parsb1_pars[ix_0___] = 0.0;
  }
  
  ad_count = i4stack_5_1[i4stack_5_1i];
  i4stack_5_1i = i4stack_5_1i - 1;
  
  for (i0 = 1;i0 <= ad_count; ++i0)
  {
    i = i4stack_5_1[i4stack_5_1i];
    i4stack_5_1i = i4stack_5_1i - 1;
    parsb1_pars[i] = parsb1_pars[i] + temp_parsb1_pars[i];
    temp_parsb1_pars[i] = 0.0;
  }
}


//   Differentiation of bearded2__next_param in reverse (adjoint) mode:
//    gradient     of useful results: temp_pars bearded2__next_param
//    with respect to varying inputs: temp_pars
//   Hide the next bit from  ADT; for one thing, strings aren't understood...
//   but there never any reason to AD this, so don't
//   unpack
//   Helper for unpack

void DBearded2::NEXT_PARAM_BPARS(double& next_paramb1_pars)
{
  double valb1_pars;
  valb1_pars = next_paramb1_pars;
  temp_parsb1_pars[nextpari] = temp_parsb1_pars[nextpari] + valb1_pars;
}


//   i_POP
//   ... NB I don't mind using if's in the constructor, since it's only run once
//   ... in lglk code, one_if() is faster
//   make_data_summaries
//   ----------------------------------------------------------------------------
//   Unpack R parameter-vector into meaningful pop dyn params

void DBearded2::UNPACK_CB(const ARRAY_1D pars/* n_par */)
{
  int i;
  double result1;
  //   Surely there is a copy-style function in ADT/C ? No doc of it tho
  //   ADT Pascal has one
  i = 1;
  
  while ((i <= n_par))
  {
    temp_pars[i] = pars[i];
    i = i + 1;
  }
  
  nextpari = 1;
  result1 = NEXT_PARAM_CB();
  roi = exp(result1);
  result1 = NEXT_PARAM_CB();
  N0_f = exp(result1);
  result1 = NEXT_PARAM_CB();
  N0_m = exp(result1);
}


//   Differentiation of n_log_p in reverse (adjoint) mode:
//    gradient     of useful results: p n_log_p
//    with respect to varying inputs: p
//   ----------------------------------------------------------------------------
//   Support routine; this and dr_n_log_p should be part of ADT maths lib, with black-box too

void DBearded2::N_LOG_P_BPARS(int n, double p, double& pb1_pars, double& n_log_pb1_pars)
{
  int result1;
  result1 = one_if((p == 0));
  pb1_pars = pb1_pars + n * n_log_pb1_pars / (result1 + p);
}




#include "Bd_impl_lib_interface_methods.hpp"
#include "Bd_impl_lib_interface_globals.hpp"
#include "Bd_impl_lib_interface_constructor.hpp"


