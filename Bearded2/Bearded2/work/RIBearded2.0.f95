MODULE COMMON

  INTEGER , PARAMETER :: dim_stack
  INTEGER :: a(n_samp)
  INTEGER :: amat
  INTEGER :: by(n_samp)
  INTEGER :: first_y
  INTEGER :: first_y_sample
  REAL :: inv_totfec_ys(first_y:last_y,0:1)
  INTEGER :: isamp_HS(n_HS)
  INTEGER :: isamp_POP(n_POP)
  INTEGER :: jsamp_HS(n_HS)
  INTEGER :: jsamp_POP(n_POP)
  INTEGER :: last_y
  REAL :: N0_f
  REAL :: N0_m
  INTEGER :: n_comps_ytbsm(first_y:last_y,first_y:last_y,first_y:last_y&
  &,0:1,0:1)
  INTEGER :: n_HS
  INTEGER :: n_hs_comps_yy(first_y:last_y,first_y:last_y)
  INTEGER :: n_hs_match_yys(first_y:last_y,first_y:last_y,0:1)
  INTEGER :: n_par
  INTEGER :: n_POP
  INTEGER :: n_samp
  REAL :: N_ys(first_y:last_y,0:1)
  INTEGER :: nextpari
  REAL :: Pr_HS_ybbs(first_y:last_y,first_y:last_y,first_y:last_y,0:1)
  REAL :: Pr_PO_ytbs(first_y:last_y,first_y:last_y,first_y:last_y,0:1)
  REAL :: roi
  REAL :: S_yij(first_y:last_y,first_y:last_y,first_y:last_y)
  INTEGER :: sex(n_samp)
  INTEGER :: sex_HS(n_HS)
  REAL :: sqrt_Pr_PO_ytbs(first_y:last_y,first_y:last_y,first_y:last_y,&
  &0:1)
  REAL :: surv
  INTEGER :: tcap(n_samp)
  REAL :: temp_pars(n_par)
  INTEGER :: ymat_atmost(n_samp)
  REAL :: inv_totfec_ysb1_pars(first_y:last_y,0:1)
  REAL :: n0_fb1_pars
  REAL :: n0_mb1_pars
  REAL :: n_ysb1_pars(first_y:last_y,0:1)
  REAL :: pr_hs_ybbsb1_pars(first_y:last_y,first_y:last_y,first_y:last_&
  &y,0:1)
  REAL :: pr_po_ytbsb1_pars(first_y:last_y,first_y:last_y,first_y:last_&
  &y,0:1)
  REAL :: roib1_pars
  REAL :: s_yijb1_pars(first_y:last_y,first_y:last_y,first_y:last_y)
  REAL :: survb1_pars
  REAL :: temp_parsb1_pars(n_par)
  INTEGER :: i4stack_2_1i
  INTEGER :: i4stack_2_1(dim_stack)
  INTEGER :: r4stack_2_1i
  REAL :: r4stack_2_1(dim_stack)
  INTEGER :: i4stack_3_1i
  INTEGER :: i4stack_3_1(dim_stack)
  INTEGER :: i4stack_4_1i
  INTEGER :: i4stack_4_1(dim_stack)
  INTEGER :: r4stack_4_1i
  REAL :: r4stack_4_1(dim_stack)
  INTEGER :: i4stack_5_1i
  INTEGER :: i4stack_5_1(dim_stack)
  INTEGER :: r8stack_5_1i
  REAL :: r8stack_5_1(dim_stack)
  
ENDMODULE 

! ----------------------------------------------------------------------------
INTEGER FUNCTION RBearded2one_if(a)

  LOGICAL :: a
  
  IF (A) THEN
  
    one_if = 1
    
  ELSE 
  
    one_if = 0
    
  ENDIF 
  
  
ENDFUNCTION 

!  calc_probs
!  ----------------------------------------------------------------------------
!  Log-likelihood
REAL FUNCTION RBearded2__lglk(pars)

  REAL , INTENT (IN):: pars(n_par)
  USE COMMON
  INTEGER :: pby,pcapt,isex,oby,oby2,tmp_pby
  REAL :: tot_lglk
  ! //
  CALL RBearded2__unpack(pars)
  !  dummy arg
  CALL RBearded2__populate(0)
  CALL RBearded2__calc_probs(0)
  tot_lglk = 0
  ! ////  PO Pairs  ////// 
  isex = 0
  
  DO WHILE (isex.LE.1)
    pby = first_y
    
    DO WHILE (pby.LE.last_y)
      pcapt = first_y
      
      DO WHILE (pcapt.LE.last_y)
        oby = first_y
        
        DO WHILE (oby.LE.last_y)
          tot_lglk = tot_lglk + (n_log_p(n_comps_ytbsm(pby,pcapt,oby,is&
          &ex,0),1.0 - Pr_PO_ytbs(pby,pcapt,oby,isex)) + n_log_p(n_comp&
          &s_ytbsm(pby,pcapt,oby,isex,1),Pr_PO_ytbs(pby,pcapt,oby,isex)&
          &))
          oby = oby + 1
        ENDDO 
        
        pcapt = pcapt + 1
      ENDDO 
      
      pby = pby + 1
    ENDDO 
    
    isex = isex + 1
  ENDDO 
  
  ! oby
  !  pcapt
  !  pmaty
  !  isex
  ! ////   Half Sibs  //////
  isex = 0
  
  DO WHILE (isex.LE.1)
    ! for (pby = first_y; pby <= last_y; pby++) {  //we'll skip parent birth year since we'll be assuming constant survival of matures for now 
    ! pmaty = pby + amat;
    ! we need to give a parents birth year such that they will be mature 
    oby = first_y + 8
    
    DO WHILE (oby.LE.last_y)
      tmp_pby = oby - 7
      oby2 = oby + 1
      
      DO WHILE (oby2.LE.last_y)
        tot_lglk = tot_lglk + (n_log_p(n_hs_comps_yy(oby,oby2),1.0 - Pr&
        &_HS_ybbs(tmp_pby,oby,oby2,isex)) + n_log_p(n_hs_match_yys(oby,&
        &oby2,isex),Pr_HS_ybbs(tmp_pby,oby,oby2,isex)))
        oby2 = oby2 + 1
      ENDDO 
      
      oby = oby + 1
    ENDDO 
    
    isex = isex + 1
  ENDDO 
  
  ! }
  !  Bin version *without* n_log_p needs if-statements to avoid log(0)
  !  and should use log1p( -Pr_PO_ytb[ pmaty][ pcapt][ oby])
  !  otherwise you can get rounding problems when N is large.
  !  You have been warned !
  ! for debugging to see what's going on w/ tot_lglk=NA 
  
  IF (tot_lglk.NE.tot_lglk) THEN
  
    isex = 2
    
  ENDIF 
  
  RBearded2__lglk = (tot_lglk)
  RETURN 
  
ENDFUNCTION 

! b_mort = exp(next_param());
! c_mort = exp(next_param());
! d_mort = exp(next_param());
!  Hide the next bit from  ADT; for one thing, strings aren't understood...
!  but there never any reason to AD this, so don't
!  unpack
!  Helper for unpack
REAL FUNCTION RBearded2__next_param()

  USE COMMON
  REAL :: val
  ! //
  val = temp_pars(nextpari)
  nextpari = nextpari + (1)
  RBearded2__next_param = (val)
  RETURN 
  
ENDFUNCTION 

!  ----------------------------------------------------------------------------
!  Support routine; this and dr_n_log_p should be part of ADT maths lib, with black-box too
REAL FUNCTION RBearded2n_log_p(n,p)

  INTEGER , INTENT (IN):: n
  REAL , INTENT (IN):: p
  USE COMMON
  n_log_p = (n * LOG(p + one_if(p.EQ.0)))
  RETURN 
  
ENDFUNCTION 

! b_mort = exp(next_param());
! c_mort = exp(next_param());
! d_mort = exp(next_param());
!  Hide the next bit from  ADT; for one thing, strings aren't understood...
!  but there never any reason to AD this, so don't
!  unpack
!  Helper for unpack
REAL FUNCTION RBearded2__NEXT_PARAM_CB()

  USE COMMON
  IMPLICIT NONE
  REAL :: val
  ! //
  val = temp_pars(nextpari)
  nextpari = nextpari + 1
  RBearded2__NEXT_PARAM_CB = val
  RETURN 
  
ENDFUNCTION RBearded2__NEXT_PARAM_CB

! ----------------------------------------------------------------------------
! Including stdlib.f
! ----------------------------------------------------------------------------
! ----------------------------------------------------------------------------
! Standard definitions of needed functions
! ----------------------------------------------------------------------------
SUBROUTINE RBearded2CheckSizeInteger1(a,i)

  INTEGER :: i
  INTEGER :: a(:)
  
ENDSUBROUTINE 

! ----------------------------------------------------------------------------
SUBROUTINE RBearded2CheckSizeInteger4(a,i)

  INTEGER :: i
  INTEGER :: a(:)
  
ENDSUBROUTINE 

! ----------------------------------------------------------------------------
SUBROUTINE RBearded2CheckSizeInteger8(a,i)

  INTEGER :: i
  INTEGER :: a(:)
  
ENDSUBROUTINE 

! ----------------------------------------------------------------------------
SUBROUTINE RBearded2CheckSizeReal4(a,i)

  INTEGER :: i
  REAL :: a(:)
  
ENDSUBROUTINE 

! ----------------------------------------------------------------------------
SUBROUTINE RBearded2CheckSizeReal8(a,i)

  INTEGER :: i
  REAL :: a(:)
  
ENDSUBROUTINE 

! ----------------------------------------------------------------------------
SUBROUTINE RBearded2CheckSizeReal16(a,i)

  INTEGER :: i
  REAL :: a(:)
  
ENDSUBROUTINE 

! ----------------------------------------------------------------------------
!  populate
!  ---------------------------------------------------------------------------
!  All CKMR probs
SUBROUTINE RBearded2__calc_probs(dummy)

  INTEGER , INTENT (IN):: dummy
  USE COMMON
  INTEGER :: pby,pcapt,pmaty,isex,oby,oby2
  Pr_PO_ytbs = 0
  pby = first_y
  
  DO WHILE (pby.LE.last_y)
    pmaty = pby + amat
    pcapt = first_y_sample
    
    DO WHILE (pcapt.LE.last_y)
      oby = first_y
      
      DO WHILE (oby.LE.last_y)
        isex = 0
        
        DO WHILE (isex.LE.1)
          Pr_PO_ytbs(pby,pcapt,oby,isex) = one_if(pmaty.LE.oby) * one_i&
          &f(pcapt.GT.oby) * one_if((pcapt - pby).LE.38) * one_if((pby &
          &- oby).LE.38) * inv_totfec_ys(oby,isex)
          isex = isex + 1
        ENDDO 
        
        oby = oby + 1
      ENDDO 
      
      pcapt = pcapt + 1
    ENDDO 
    
    pby = pby + 1
  ENDDO 
  
  Pr_HS_ybbs = 0
  isex = 0
  
  DO WHILE (isex.LE.1)
    pby = first_y
    
    DO WHILE (pby.LE.last_y)
      pmaty = pby + amat
      oby = first_y
      
      DO WHILE (oby.LE.last_y)
        oby2 = oby + 1
        
        DO WHILE (oby2.LE.last_y)
          Pr_HS_ybbs(pby,oby,oby2,isex) = one_if(pmaty.LE.oby) * inv_to&
          &tfec_ys(oby2,isex) * S_yij(pby,oby,oby2)
          oby2 = oby2 + 1
        ENDDO 
        
        oby = oby + 1
      ENDDO 
      
      pby = pby + 1
    ENDDO 
    
    isex = isex + 1
  ENDDO 
  
  
ENDSUBROUTINE 

!  include-files below are auto-generated by ADT based on the dot-hpp
!  Next line may bomb if no constructor-locals (used to; maybe fixed now)
!  Always need these two
!  Now you can do some calculations to work out further array dims...
!  that depend on stuff just passed in. Then:
!  eg  #include "Bd_constructor_arrays_phase_2.hpp"
!  etc. Might as well pass in all scalars during PHASE 1 though
!  NB PHASES are defined in the dot-hpp
!  Could do data-summary calcs here
!  but NB *no* bounds-checks inside the constructor (for good reason)
!  so I've put them into a separate function
!  Hmmm, should check: ?arrays that need to be precalced...
!  before array_plans_init
!  make_data_summaries(); Has to be called OUTSIDE the constructor at present... ADT / ViStu thing
!  constructor
SUBROUTINE RBearded2__make_data_summaries()

  USE COMMON
  INTEGER :: i_samp,j_samp,this_by,this_oby,this_capt,this_pby,this_mat&
  &y,this_sex,i_POP,i_HS
  !  compute birth years for each sampled animal
  i_samp = 1
  
  DO WHILE (i_samp.LE.n_samp)
    this_by = tcap(i_samp) - a(i_samp)
    by(i_samp) = this_by
    !  For i_samp as possible parent, need year of maturity...
    !  or, if that's < first_y, just use first_y...
    ! note: we'll need to avoid doing comparisons where parent and offspring are both "born" in first_y
    ymat_atmost(i_samp) = MAX(first_y,this_by + amat)
    i_samp = i_samp + 1
  ENDDO 
  
  !  i_samp
  n_comps_ytbsm = 0
  i_samp = 1
  
  DO WHILE (i_samp.LT.n_samp)
    j_samp = i_samp + 1
    
    DO WHILE (j_samp.LE.n_samp)
      ! /////   PARENT OFFSPRING /////
      !  In this case, exclude comps where adult caught in year of juve birth...
      !  depends on biol & sampling
      !  First case: i is P, j is O
      this_oby = by(j_samp)
      this_pby = by(i_samp)
      this_capt = tcap(i_samp)
      this_maty = ymat_atmost(i_samp)
      this_sex = sex(i_samp)
      !  exclude born-in-year-of-cap - this will also remove case where offspring born <= year 1
      
      IF ((this_oby.GE.this_maty).AND.(this_maty.LE.last_y).AND.(this_o&
      &by.LT.this_capt).AND.(this_oby.NE.this_capt)) THEN
      
        n_comps_ytbsm(this_pby,this_capt,this_oby,this_sex,0) = n_comps&
        &_ytbsm(this_pby,this_capt,this_oby,this_sex,0) + (1)
        
      ENDIF 
      
      !  Second case: i is O, j is P
      this_oby = by(i_samp)
      this_pby = by(j_samp)
      this_capt = tcap(j_samp)
      this_maty = ymat_atmost(j_samp)
      this_sex = sex(j_samp)
      !  exclude born-in-year-of-cap - this will also remove case where offspring born <= year 1
      
      IF ((this_oby.GE.this_maty).AND.(this_maty.LE.last_y).AND.(this_o&
      &by.LT.this_capt).AND.(this_oby.NE.this_capt)) THEN
      
        n_comps_ytbsm(this_pby,this_capt,this_oby,this_sex,0) = n_comps&
        &_ytbsm(this_pby,this_capt,this_oby,this_sex,0) + (1)
        
      ENDIF 
      
      ! //    HALF SIB   /////
      ! don't make comparison of individuals caught in same year
      
      IF (by(i_samp).NE.by(j_samp)) THEN
      
        
        IF (by(i_samp).LT.by(j_samp)) THEN
        
          n_hs_comps_yy(by(i_samp),by(j_samp)) = n_hs_comps_yy(by(i_sam&
          &p),by(j_samp)) + (1)
          
        ELSE 
        
          n_hs_comps_yy(by(j_samp),by(i_samp)) = n_hs_comps_yy(by(j_sam&
          &p),by(i_samp)) + (1)
          
        ENDIF 
        
        
      ENDIF 
      
      j_samp = j_samp + 1
    ENDDO 
    
    i_samp = i_samp + 1
  ENDDO 
  
  !  jsamp
  !  isamp
  i_POP = 1
  
  DO WHILE (i_POP.LT.n_POP)
    i_samp = isamp_POP(i_POP)
    j_samp = jsamp_POP(i_POP)
    !  First case: i is P, j is O
    this_oby = by(j_samp)
    this_pby = by(i_samp)
    this_capt = tcap(i_samp)
    this_maty = ymat_atmost(i_samp)
    this_sex = sex(i_samp)
    !  exclude born-in-year-of-cap - this will also remove case where offspring born <= year 1
    
    IF ((this_oby.GE.this_maty).AND.(this_maty.LE.last_y).AND.(this_oby&
    &.LT.this_capt).AND.(this_oby.NE.this_capt)) THEN
    
      n_comps_ytbsm(this_pby,this_capt,this_oby,this_sex,0) = n_comps_y&
      &tbsm(this_pby,this_capt,this_oby,this_sex,0) - (1)
      n_comps_ytbsm(this_pby,this_capt,this_oby,this_sex,1) = n_comps_y&
      &tbsm(this_pby,this_capt,this_oby,this_sex,1) + (1)
      
    ! have to take away from negative comparisons 
    ENDIF 
    
    !  Second case: i is O, j is P
    this_oby = by(i_samp)
    this_pby = by(j_samp)
    this_capt = tcap(j_samp)
    this_maty = ymat_atmost(j_samp)
    this_sex = sex(j_samp)
    !  exclude born-in-year-of-cap - this will also remove case where offspring born <= year 1
    
    IF ((this_oby.GE.this_maty).AND.(this_maty.LE.last_y).AND.(this_oby&
    &.LT.this_capt).AND.(this_oby.NE.this_capt)) THEN
    
      n_comps_ytbsm(this_pby,this_capt,this_oby,this_sex,0) = n_comps_y&
      &tbsm(this_pby,this_capt,this_oby,this_sex,0) - (1)
      n_comps_ytbsm(this_pby,this_capt,this_oby,this_sex,1) = n_comps_y&
      &tbsm(this_pby,this_capt,this_oby,this_sex,1) + (1)
      
    ! have to take away from negative comparisons 
    ENDIF 
    
    i_POP = i_POP + 1
  ENDDO 
  
  !  i_POP
  i_HS = 1
  
  DO WHILE (i_HS.LT.n_HS)
    i_samp = isamp_HS(i_HS)
    j_samp = jsamp_HS(i_HS)
    
    IF (by(i_samp).NE.by(j_samp)) THEN
    
      
      IF (by(i_samp).LT.by(j_samp)) THEN
      
        n_hs_match_yys(by(i_samp),by(j_samp),sex_HS(i_HS)) = n_hs_match&
        &_yys(by(i_samp),by(j_samp),sex_HS(i_HS)) + (1)
        n_hs_comps_yy(by(i_samp),by(j_samp)) = n_hs_comps_yy(by(i_samp)&
        &,by(j_samp)) - (1)
        
      ELSE 
      
        n_hs_match_yys(by(j_samp),by(i_samp),sex_HS(i_HS)) = n_hs_match&
        &_yys(by(j_samp),by(i_samp),sex_HS(i_HS)) + (1)
        n_hs_comps_yy(by(j_samp),by(i_samp)) = n_hs_comps_yy(by(j_samp)&
        &,by(i_samp)) - (1)
        
      ENDIF 
      
      
    ENDIF 
    
    i_HS = i_HS + 1
  ENDDO 
  
  
ENDSUBROUTINE 

!  next_param
!  ---------------------------------------------------------------------------
!  Fill in pop dyn from parameters. Age-structured version is more interesting
SUBROUTINE RBearded2__populate(dummy)

  INTEGER , INTENT (IN):: dummy
  USE COMMON
  INTEGER :: y,isex,i,j,iage
  N_ys(first_y,0) = N0_f
  N_ys(first_y,1) = N0_m
  y = first_y + 1
  
  DO WHILE (y.LE.last_y)
    isex = 0
    
    DO WHILE (isex.LE.1)
      N_ys(y,isex) = N_ys(y - 1,isex) * roi
      isex = isex + 1
    ENDDO 
    
    y = y + 1
  ENDDO 
  
  ! isex
  ! y
  !  Might as well do Total Reprod Output here in populate(), though...
  !  could also do in calc_probs. Actually we just need the inverse
  y = first_y
  
  DO WHILE (y.LE.last_y)
    isex = 0
    
    DO WHILE (isex.LE.1)
      inv_totfec_ys(y,isex) = 1.0 / (surv * N_ys(y,isex))
      isex = isex + 1
    ENDDO 
    
    y = y + 1
  ENDDO 
  
  S_yij = 0
  !  Fill survival matrix
  i = first_y
  
  DO WHILE (i.LE.last_y)
    ! implies no matches if half sibs born in same year
    j = i + 1
    
    DO WHILE (j.LE.last_y)
      iage = j - i
      y = first_y
      
      DO WHILE (y.LE.last_y)
        ! S_yij[y][i][j] = exp(-pow(b_mort*iage, c_mort) - pow(b_mort*iage, 1.0 / c_mort) - d_mort * iage); //could be more efficient if just defined as a vector and filled here
        S_yij(y,i,j) = ((surv)**(iage))
        y = y + 1
      ENDDO 
      
      j = j + 1
    ENDDO 
    
    i = i + 1
  ENDDO 
  
  
ENDSUBROUTINE 

!  lglk
!  ----------------------------------------------------------------------------
!  sqrt of all CKMR probs--- needed iff DESIGNcopy
SUBROUTINE RBearded2__sqrt_probs(pars)

  REAL , INTENT (IN):: pars(n_par)
  USE COMMON
  INTEGER :: pby,pcapt,oby,isex
  ! //
  CALL RBearded2__unpack(pars)
  !  dummy arg; ADT bug
  CALL RBearded2__populate(0)
  CALL RBearded2__calc_probs(0)
  sqrt_Pr_PO_ytbs = 0
  pby = first_y
  
  DO WHILE (pby.LE.last_y)
    pcapt = first_y
    
    DO WHILE (pcapt.LE.last_y)
      oby = first_y
      
      DO WHILE (oby.LE.last_y)
        isex = 0
        
        DO WHILE (isex.LE.1)
          sqrt_Pr_PO_ytbs(pby,pcapt,oby,isex) = SQRT(Pr_PO_ytbs(pby,pca&
          &pt,oby,isex))
          isex = isex + 1
        ENDDO 
        
        oby = oby + 1
      ENDDO 
      
      pcapt = pcapt + 1
    ENDDO 
    
    pby = pby + 1
  ENDDO 
  
  
ENDSUBROUTINE 

!  i_HS
!  ... NB I don't mind using if's in the constructor, since it's only run once
!  ... in lglk code, one_if() is faster
!  make_data_summaries
!  ----------------------------------------------------------------------------
!  Unpack R parameter-vector into meaningful pop dyn params
SUBROUTINE RBearded2__unpack(pars)

  REAL , INTENT (IN):: pars(n_par)
  USE COMMON
  INTEGER :: i
  !  Surely there is a copy-style function in ADT/C ? No doc of it tho
  !  ADT Pascal has one
  i = 1
  
  DO WHILE (i.LE.n_par)
    temp_pars(i) = pars(i)
    i = i + 1
  ENDDO 
  
  nextpari = 1
  roi = EXP(RBearded2__next_param())
  N0_f = EXP(RBearded2__next_param())
  N0_m = EXP(RBearded2__next_param())
  surv = 1.0 / (1.0 + EXP(-RBearded2__next_param()))
  
ENDSUBROUTINE 

!  Differentiation of bearded2__lglk in reverse (adjoint) mode:
!   gradient     of useful results: bearded2__lglk
!   with respect to varying inputs: pars
!   RW status of diff variables: roi:(loc) s_yij:(loc) inv_totfec_ys:(loc)
!                pr_hs_ybbs:(loc) surv:(loc) n_ys:(loc) temp_pars:(loc)
!                n0_f:(loc) pr_po_ytbs:(loc) n0_m:(loc) bearded2__lglk:in-killed
!                pars:out
!  calc_probs
!  ----------------------------------------------------------------------------
!  Log-likelihood
SUBROUTINE RBearded2__LGLK_BPARS(pars,parsb1_pars,lglkb1_pars)

  IMPLICIT NONE
  REAL , INTENT (IN):: pars(n_par)
  REAL :: parsb1_pars(n_par)
  USE COMMON
  INTEGER :: pby,pcapt,isex,oby,oby2,tmp_pby
  REAL :: tot_lglkb1_pars
  REAL :: arg1
  REAL :: arg1b1_pars
  REAL :: result1b1_pars
  REAL :: result2b1_pars
  INTEGER :: ad_count
  INTEGER :: i
  INTEGER :: ad_count0
  INTEGER :: i0
  INTEGER :: ad_count1
  INTEGER :: i1
  INTEGER :: ad_count2
  INTEGER :: i2
  INTEGER :: ad_count3
  INTEGER :: i3
  INTEGER :: ad_count4
  INTEGER :: i4
  INTEGER :: ad_count5
  INTEGER :: i5
  REAL :: lglkb1_pars
  INTEGER :: ix_0___
  INTEGER :: ix_1___
  tmp_pby = 0
  
  DO ix_0___ = 1,(1 + n_par - 1)
    r4stack_2_1i = r4stack_2_1i + 1
    r4stack_2_1(r4stack_2_1i) = temp_pars(ix_0___)
  ENDDO 
  
  CALL RBearded2__UNPACK_CB(pars)
  
  DO ix_0___ = first_y,(first_y + (last_y - first_y + 1) - 1)
    
    DO ix_1___ = 0,(0 + 2 - 1)
      r4stack_2_1i = r4stack_2_1i + 1
      r4stack_2_1(r4stack_2_1i) = n_ys(ix_0___,ix_1___)
    ENDDO 
    
  ENDDO 
  
  CALL RBearded2__POPULATE(0)
  CALL RBearded2__CALC_PROBS(0)
  ! ////  PO Pairs  ////// 
  isex = 0
  ad_count2 = 0
  
  DO WHILE (isex.LE.1)
    pby = first_y
    ad_count1 = 0
    
    DO WHILE (pby.LE.last_y)
      pcapt = first_y
      ad_count0 = 0
      
      DO WHILE (pcapt.LE.last_y)
        oby = first_y
        ad_count = 0
        
        DO WHILE (oby.LE.last_y)
          i4stack_2_1i = i4stack_2_1i + 1
          i4stack_2_1(i4stack_2_1i) = oby
          oby = oby + 1
          ad_count = ad_count + 1
        ENDDO 
        
        i4stack_2_1i = i4stack_2_1i + 1
        i4stack_2_1(i4stack_2_1i) = ad_count
        i4stack_2_1i = i4stack_2_1i + 1
        i4stack_2_1(i4stack_2_1i) = pcapt
        pcapt = pcapt + 1
        ad_count0 = ad_count0 + 1
      ENDDO 
      
      i4stack_2_1i = i4stack_2_1i + 1
      i4stack_2_1(i4stack_2_1i) = ad_count0
      i4stack_2_1i = i4stack_2_1i + 1
      i4stack_2_1(i4stack_2_1i) = pby
      pby = pby + 1
      ad_count1 = ad_count1 + 1
    ENDDO 
    
    i4stack_2_1i = i4stack_2_1i + 1
    i4stack_2_1(i4stack_2_1i) = ad_count1
    i4stack_2_1i = i4stack_2_1i + 1
    i4stack_2_1(i4stack_2_1i) = isex
    isex = isex + 1
    ad_count2 = ad_count2 + 1
  ENDDO 
  
  i4stack_2_1i = i4stack_2_1i + 1
  i4stack_2_1(i4stack_2_1i) = ad_count2
  ! oby
  !  pcapt
  !  pmaty
  !  isex
  ! ////   Half Sibs  //////
  isex = 0
  ad_count5 = 0
  
  DO WHILE (isex.LE.1)
    ! for (pby = first_y; pby <= last_y; pby++) {  //we'll skip parent birth year since we'll be assuming constant survival of mature
    !s for now 
    ! pmaty = pby + amat;
    ! we need to give a parents birth year such that they will be mature 
    oby = first_y + 8
    ad_count4 = 0
    
    DO WHILE (oby.LE.last_y)
      i4stack_2_1i = i4stack_2_1i + 1
      i4stack_2_1(i4stack_2_1i) = tmp_pby
      tmp_pby = oby - 7
      oby2 = oby + 1
      ad_count3 = 0
      
      DO WHILE (oby2.LE.last_y)
        i4stack_2_1i = i4stack_2_1i + 1
        i4stack_2_1(i4stack_2_1i) = oby2
        oby2 = oby2 + 1
        ad_count3 = ad_count3 + 1
      ENDDO 
      
      i4stack_2_1i = i4stack_2_1i + 1
      i4stack_2_1(i4stack_2_1i) = ad_count3
      i4stack_2_1i = i4stack_2_1i + 1
      i4stack_2_1(i4stack_2_1i) = oby
      oby = oby + 1
      ad_count4 = ad_count4 + 1
    ENDDO 
    
    i4stack_2_1i = i4stack_2_1i + 1
    i4stack_2_1(i4stack_2_1i) = ad_count4
    i4stack_2_1i = i4stack_2_1i + 1
    i4stack_2_1(i4stack_2_1i) = isex
    isex = isex + 1
    ad_count5 = ad_count5 + 1
  ENDDO 
  
  i4stack_2_1i = i4stack_2_1i + 1
  i4stack_2_1(i4stack_2_1i) = ad_count5
  tot_lglkb1_pars = lglkb1_pars
  pr_hs_ybbsb1_pars = 0.0
  ad_count5 = i4stack_2_1(i4stack_2_1i)
  i4stack_2_1i = i4stack_2_1i - 1
  
  DO i5 = 1,ad_count5
    isex = i4stack_2_1(i4stack_2_1i)
    i4stack_2_1i = i4stack_2_1i - 1
    ad_count4 = i4stack_2_1(i4stack_2_1i)
    i4stack_2_1i = i4stack_2_1i - 1
    
    DO i4 = 1,ad_count4
      oby = i4stack_2_1(i4stack_2_1i)
      i4stack_2_1i = i4stack_2_1i - 1
      ad_count3 = i4stack_2_1(i4stack_2_1i)
      i4stack_2_1i = i4stack_2_1i - 1
      
      DO i3 = 1,ad_count3
        oby2 = i4stack_2_1(i4stack_2_1i)
        i4stack_2_1i = i4stack_2_1i - 1
        result1b1_pars = tot_lglkb1_pars
        result2b1_pars = tot_lglkb1_pars
        CALL N_LOG_P_BPARS(n_hs_match_yys(oby,oby2,isex),pr_hs_ybbs(tmp&
        &_pby,oby,oby2,isex),pr_hs_ybbsb1_pars(tmp_pby,oby,oby2,isex),r&
        &esult2b1_pars)
        arg1 = 1.0 - pr_hs_ybbs(tmp_pby,oby,oby2,isex)
        arg1b1_pars = 0.0
        CALL N_LOG_P_BPARS(n_hs_comps_yy(oby,oby2),arg1,arg1b1_pars,res&
        &ult1b1_pars)
        pr_hs_ybbsb1_pars(tmp_pby,oby,oby2,isex) = pr_hs_ybbsb1_pars(tm&
        &p_pby,oby,oby2,isex) - arg1b1_pars
      ENDDO 
      
      tmp_pby = i4stack_2_1(i4stack_2_1i)
      i4stack_2_1i = i4stack_2_1i - 1
    ENDDO 
    
  ENDDO 
  
  pr_po_ytbsb1_pars = 0.0
  ad_count2 = i4stack_2_1(i4stack_2_1i)
  i4stack_2_1i = i4stack_2_1i - 1
  
  DO i2 = 1,ad_count2
    isex = i4stack_2_1(i4stack_2_1i)
    i4stack_2_1i = i4stack_2_1i - 1
    ad_count1 = i4stack_2_1(i4stack_2_1i)
    i4stack_2_1i = i4stack_2_1i - 1
    
    DO i1 = 1,ad_count1
      pby = i4stack_2_1(i4stack_2_1i)
      i4stack_2_1i = i4stack_2_1i - 1
      ad_count0 = i4stack_2_1(i4stack_2_1i)
      i4stack_2_1i = i4stack_2_1i - 1
      
      DO i0 = 1,ad_count0
        pcapt = i4stack_2_1(i4stack_2_1i)
        i4stack_2_1i = i4stack_2_1i - 1
        ad_count = i4stack_2_1(i4stack_2_1i)
        i4stack_2_1i = i4stack_2_1i - 1
        
        DO i = 1,ad_count
          oby = i4stack_2_1(i4stack_2_1i)
          i4stack_2_1i = i4stack_2_1i - 1
          result1b1_pars = tot_lglkb1_pars
          result2b1_pars = tot_lglkb1_pars
          CALL N_LOG_P_BPARS(n_comps_ytbsm(pby,pcapt,oby,isex,1),pr_po_&
          &ytbs(pby,pcapt,oby,isex),pr_po_ytbsb1_pars(pby,pcapt,oby,ise&
          &x),result2b1_pars)
          arg1 = 1.0 - pr_po_ytbs(pby,pcapt,oby,isex)
          arg1b1_pars = 0.0
          CALL N_LOG_P_BPARS(n_comps_ytbsm(pby,pcapt,oby,isex,0),arg1,a&
          &rg1b1_pars,result1b1_pars)
          pr_po_ytbsb1_pars(pby,pcapt,oby,isex) = pr_po_ytbsb1_pars(pby&
          &,pcapt,oby,isex) - arg1b1_pars
        ENDDO 
        
      ENDDO 
      
    ENDDO 
    
  ENDDO 
  
  CALL RBearded2__CALC_PROBS_BPARS(0)
  
  DO ix_0___ = (first_y + (last_y - first_y + 1) - 1),first_y,-1
    
    DO ix_1___ = (0 + 2 - 1),0,-1
      n_ys(ix_0___,ix_1___) = r4stack_2_1(r4stack_2_1i)
      r4stack_2_1i = r4stack_2_1i - 1
    ENDDO 
    
  ENDDO 
  
  CALL RBearded2__POPULATE_BPARS(0)
  
  DO ix_0___ = (1 + n_par - 1),1,-1
    temp_pars(ix_0___) = r4stack_2_1(r4stack_2_1i)
    r4stack_2_1i = r4stack_2_1i - 1
  ENDDO 
  
  CALL RBearded2__UNPACK_BPARS(pars,parsb1_pars)
  
ENDSUBROUTINE RBearded2__LGLK_BPARS

!  Differentiation of bearded2__calc_probs in reverse (adjoint) mode:
!   gradient     of useful results: pr_hs_ybbs pr_po_ytbs
!   with respect to varying inputs: s_yij inv_totfec_ys
! ----------------------------------------------------------------------------
!  populate
!  ---------------------------------------------------------------------------
!  All CKMR probs
SUBROUTINE RBearded2__CALC_PROBS_BPARS(dummy)

  IMPLICIT NONE
  INTEGER , INTENT (IN):: dummy
  USE COMMON
  INTEGER :: pby,pcapt,pmaty,isex,oby,oby2
  INTEGER :: result1
  INTEGER :: result2
  INTEGER :: result3
  INTEGER :: result4
  INTEGER :: ad_count
  INTEGER :: i
  INTEGER :: ad_count0
  INTEGER :: i0
  INTEGER :: ad_count1
  INTEGER :: i1
  INTEGER :: ad_count2
  INTEGER :: i2
  INTEGER :: ad_count3
  INTEGER :: i3
  INTEGER :: ad_count4
  INTEGER :: i4
  INTEGER :: ad_count5
  INTEGER :: i5
  INTEGER :: ad_count6
  INTEGER :: i6
  pmaty = 0
  result1 = 0
  result2 = 0
  result3 = 0
  result4 = 0
  pby = first_y
  ad_count2 = 0
  
  DO WHILE (pby.LE.last_y)
    i4stack_3_1i = i4stack_3_1i + 1
    i4stack_3_1(i4stack_3_1i) = pmaty
    pmaty = pby + amat
    pcapt = first_y_sample
    ad_count1 = 0
    
    DO WHILE (pcapt.LE.last_y)
      oby = first_y
      ad_count0 = 0
      
      DO WHILE (oby.LE.last_y)
        isex = 0
        ad_count = 0
        
        DO WHILE (isex.LE.1)
          i4stack_3_1i = i4stack_3_1i + 1
          i4stack_3_1(i4stack_3_1i) = result1
          result1 = ONE_IF(pmaty.LE.oby)
          i4stack_3_1i = i4stack_3_1i + 1
          i4stack_3_1(i4stack_3_1i) = result2
          result2 = ONE_IF(pcapt.GT.oby)
          i4stack_3_1i = i4stack_3_1i + 1
          i4stack_3_1(i4stack_3_1i) = result3
          result3 = ONE_IF(pcapt - pby.LE.38)
          i4stack_3_1i = i4stack_3_1i + 1
          i4stack_3_1(i4stack_3_1i) = result4
          result4 = ONE_IF(pby - oby.LE.38)
          i4stack_3_1i = i4stack_3_1i + 1
          i4stack_3_1(i4stack_3_1i) = isex
          isex = isex + 1
          ad_count = ad_count + 1
        ENDDO 
        
        i4stack_3_1i = i4stack_3_1i + 1
        i4stack_3_1(i4stack_3_1i) = ad_count
        i4stack_3_1i = i4stack_3_1i + 1
        i4stack_3_1(i4stack_3_1i) = oby
        oby = oby + 1
        ad_count0 = ad_count0 + 1
      ENDDO 
      
      i4stack_3_1i = i4stack_3_1i + 1
      i4stack_3_1(i4stack_3_1i) = ad_count0
      i4stack_3_1i = i4stack_3_1i + 1
      i4stack_3_1(i4stack_3_1i) = pcapt
      pcapt = pcapt + 1
      ad_count1 = ad_count1 + 1
    ENDDO 
    
    i4stack_3_1i = i4stack_3_1i + 1
    i4stack_3_1(i4stack_3_1i) = ad_count1
    i4stack_3_1i = i4stack_3_1i + 1
    i4stack_3_1(i4stack_3_1i) = pby
    pby = pby + 1
    ad_count2 = ad_count2 + 1
  ENDDO 
  
  i4stack_3_1i = i4stack_3_1i + 1
  i4stack_3_1(i4stack_3_1i) = ad_count2
  isex = 0
  ad_count6 = 0
  
  DO WHILE (isex.LE.1)
    pby = first_y
    ad_count5 = 0
    
    DO WHILE (pby.LE.last_y)
      i4stack_3_1i = i4stack_3_1i + 1
      i4stack_3_1(i4stack_3_1i) = pmaty
      pmaty = pby + amat
      oby = first_y
      ad_count4 = 0
      
      DO WHILE (oby.LE.last_y)
        oby2 = oby + 1
        ad_count3 = 0
        
        DO WHILE (oby2.LE.last_y)
          i4stack_3_1i = i4stack_3_1i + 1
          i4stack_3_1(i4stack_3_1i) = result1
          result1 = ONE_IF(pmaty.LE.oby)
          i4stack_3_1i = i4stack_3_1i + 1
          i4stack_3_1(i4stack_3_1i) = oby2
          oby2 = oby2 + 1
          ad_count3 = ad_count3 + 1
        ENDDO 
        
        i4stack_3_1i = i4stack_3_1i + 1
        i4stack_3_1(i4stack_3_1i) = ad_count3
        i4stack_3_1i = i4stack_3_1i + 1
        i4stack_3_1(i4stack_3_1i) = oby
        oby = oby + 1
        ad_count4 = ad_count4 + 1
      ENDDO 
      
      i4stack_3_1i = i4stack_3_1i + 1
      i4stack_3_1(i4stack_3_1i) = ad_count4
      i4stack_3_1i = i4stack_3_1i + 1
      i4stack_3_1(i4stack_3_1i) = pby
      pby = pby + 1
      ad_count5 = ad_count5 + 1
    ENDDO 
    
    i4stack_3_1i = i4stack_3_1i + 1
    i4stack_3_1(i4stack_3_1i) = ad_count5
    i4stack_3_1i = i4stack_3_1i + 1
    i4stack_3_1(i4stack_3_1i) = isex
    isex = isex + 1
    ad_count6 = ad_count6 + 1
  ENDDO 
  
  s_yijb1_pars = 0.0
  inv_totfec_ysb1_pars = 0.0
  
  DO i6 = 1,ad_count6
    isex = i4stack_3_1(i4stack_3_1i)
    i4stack_3_1i = i4stack_3_1i - 1
    ad_count5 = i4stack_3_1(i4stack_3_1i)
    i4stack_3_1i = i4stack_3_1i - 1
    
    DO i5 = 1,ad_count5
      pby = i4stack_3_1(i4stack_3_1i)
      i4stack_3_1i = i4stack_3_1i - 1
      ad_count4 = i4stack_3_1(i4stack_3_1i)
      i4stack_3_1i = i4stack_3_1i - 1
      
      DO i4 = 1,ad_count4
        oby = i4stack_3_1(i4stack_3_1i)
        i4stack_3_1i = i4stack_3_1i - 1
        ad_count3 = i4stack_3_1(i4stack_3_1i)
        i4stack_3_1i = i4stack_3_1i - 1
        
        DO i3 = 1,ad_count3
          oby2 = i4stack_3_1(i4stack_3_1i)
          i4stack_3_1i = i4stack_3_1i - 1
          inv_totfec_ysb1_pars(oby2,isex) = inv_totfec_ysb1_pars(oby2,i&
          &sex) + result1 * s_yij(pby,oby,oby2) * pr_hs_ybbsb1_pars(pby&
          &,oby,oby2,isex)
          s_yijb1_pars(pby,oby,oby2) = s_yijb1_pars(pby,oby,oby2) + res&
          &ult1 * inv_totfec_ys(oby2,isex) * pr_hs_ybbsb1_pars(pby,oby,&
          &oby2,isex)
          pr_hs_ybbsb1_pars(pby,oby,oby2,isex) = 0.0
          result1 = i4stack_3_1(i4stack_3_1i)
          i4stack_3_1i = i4stack_3_1i - 1
        ENDDO 
        
      ENDDO 
      
      pmaty = i4stack_3_1(i4stack_3_1i)
      i4stack_3_1i = i4stack_3_1i - 1
    ENDDO 
    
  ENDDO 
  
  ad_count2 = i4stack_3_1(i4stack_3_1i)
  i4stack_3_1i = i4stack_3_1i - 1
  
  DO i2 = 1,ad_count2
    pby = i4stack_3_1(i4stack_3_1i)
    i4stack_3_1i = i4stack_3_1i - 1
    ad_count1 = i4stack_3_1(i4stack_3_1i)
    i4stack_3_1i = i4stack_3_1i - 1
    
    DO i1 = 1,ad_count1
      pcapt = i4stack_3_1(i4stack_3_1i)
      i4stack_3_1i = i4stack_3_1i - 1
      ad_count0 = i4stack_3_1(i4stack_3_1i)
      i4stack_3_1i = i4stack_3_1i - 1
      
      DO i0 = 1,ad_count0
        oby = i4stack_3_1(i4stack_3_1i)
        i4stack_3_1i = i4stack_3_1i - 1
        ad_count = i4stack_3_1(i4stack_3_1i)
        i4stack_3_1i = i4stack_3_1i - 1
        
        DO i = 1,ad_count
          isex = i4stack_3_1(i4stack_3_1i)
          i4stack_3_1i = i4stack_3_1i - 1
          inv_totfec_ysb1_pars(oby,isex) = inv_totfec_ysb1_pars(oby,ise&
          &x) + result3 * result4 * result1 * result2 * pr_po_ytbsb1_pa&
          &rs(pby,pcapt,oby,isex)
          pr_po_ytbsb1_pars(pby,pcapt,oby,isex) = 0.0
          result4 = i4stack_3_1(i4stack_3_1i)
          i4stack_3_1i = i4stack_3_1i - 1
          result3 = i4stack_3_1(i4stack_3_1i)
          i4stack_3_1i = i4stack_3_1i - 1
          result2 = i4stack_3_1(i4stack_3_1i)
          i4stack_3_1i = i4stack_3_1i - 1
          result1 = i4stack_3_1(i4stack_3_1i)
          i4stack_3_1i = i4stack_3_1i - 1
        ENDDO 
        
      ENDDO 
      
    ENDDO 
    
    pmaty = i4stack_3_1(i4stack_3_1i)
    i4stack_3_1i = i4stack_3_1i - 1
  ENDDO 
  
  
ENDSUBROUTINE RBearded2__CALC_PROBS_BPARS

!  Differentiation of bearded2__populate in reverse (adjoint) mode:
!   gradient     of useful results: s_yij inv_totfec_ys
!   with respect to varying inputs: roi surv n0_f n0_m
!  next_param
!  ---------------------------------------------------------------------------
!  Fill in pop dyn from parameters. Age-structured version is more interesting
SUBROUTINE RBearded2__POPULATE_BPARS(dummy)

  IMPLICIT NONE
  INTEGER , INTENT (IN):: dummy
  USE COMMON
  INTEGER :: y,isex,i,j,iage
  REAL :: temp
  REAL :: tempb1_pars
  INTEGER :: ad_count
  INTEGER :: i0
  INTEGER :: ad_count0
  INTEGER :: i1
  INTEGER :: ad_count1
  INTEGER :: i2
  INTEGER :: ad_count2
  INTEGER :: i3
  INTEGER :: ad_count3
  INTEGER :: i4
  INTEGER :: ad_count4
  INTEGER :: i5
  INTEGER :: ad_count5
  INTEGER :: i6
  iage = 0
  n_ys(first_y,0) = n0_f
  n_ys(first_y,1) = n0_m
  y = first_y + 1
  ad_count0 = 0
  
  DO WHILE (y.LE.last_y)
    isex = 0
    ad_count = 0
    
    DO WHILE (isex.LE.1)
      r4stack_4_1i = r4stack_4_1i + 1
      r4stack_4_1(r4stack_4_1i) = n_ys(y,isex)
      n_ys(y,isex) = n_ys(y - 1,isex) * roi
      i4stack_4_1i = i4stack_4_1i + 1
      i4stack_4_1(i4stack_4_1i) = isex
      isex = isex + 1
      ad_count = ad_count + 1
    ENDDO 
    
    i4stack_4_1i = i4stack_4_1i + 1
    i4stack_4_1(i4stack_4_1i) = ad_count
    i4stack_4_1i = i4stack_4_1i + 1
    i4stack_4_1(i4stack_4_1i) = y
    y = y + 1
    ad_count0 = ad_count0 + 1
  ENDDO 
  
  i4stack_4_1i = i4stack_4_1i + 1
  i4stack_4_1(i4stack_4_1i) = ad_count0
  ! isex
  ! y
  !  Might as well do Total Reprod Output here in populate(), though...
  !  could also do in calc_probs. Actually we just need the inverse
  y = first_y
  ad_count2 = 0
  
  DO WHILE (y.LE.last_y)
    isex = 0
    ad_count1 = 0
    
    DO WHILE (isex.LE.1)
      i4stack_4_1i = i4stack_4_1i + 1
      i4stack_4_1(i4stack_4_1i) = isex
      isex = isex + 1
      ad_count1 = ad_count1 + 1
    ENDDO 
    
    i4stack_4_1i = i4stack_4_1i + 1
    i4stack_4_1(i4stack_4_1i) = ad_count1
    i4stack_4_1i = i4stack_4_1i + 1
    i4stack_4_1(i4stack_4_1i) = y
    y = y + 1
    ad_count2 = ad_count2 + 1
  ENDDO 
  
  i4stack_4_1i = i4stack_4_1i + 1
  i4stack_4_1(i4stack_4_1i) = ad_count2
  !  Fill survival matrix
  i = first_y
  ad_count5 = 0
  
  DO WHILE (i.LE.last_y)
    ! implies no matches if half sibs born in same year
    j = i + 1
    ad_count4 = 0
    
    DO WHILE (j.LE.last_y)
      i4stack_4_1i = i4stack_4_1i + 1
      i4stack_4_1(i4stack_4_1i) = iage
      iage = j - i
      y = first_y
      ad_count3 = 0
      
      DO WHILE (y.LE.last_y)
        i4stack_4_1i = i4stack_4_1i + 1
        i4stack_4_1(i4stack_4_1i) = y
        y = y + 1
        ad_count3 = ad_count3 + 1
      ENDDO 
      
      i4stack_4_1i = i4stack_4_1i + 1
      i4stack_4_1(i4stack_4_1i) = ad_count3
      i4stack_4_1i = i4stack_4_1i + 1
      i4stack_4_1(i4stack_4_1i) = j
      j = j + 1
      ad_count4 = ad_count4 + 1
    ENDDO 
    
    i4stack_4_1i = i4stack_4_1i + 1
    i4stack_4_1(i4stack_4_1i) = ad_count4
    i4stack_4_1i = i4stack_4_1i + 1
    i4stack_4_1(i4stack_4_1i) = i
    i = i + 1
    ad_count5 = ad_count5 + 1
  ENDDO 
  
  survb1_pars = 0.0
  
  DO i6 = 1,ad_count5
    i = i4stack_4_1(i4stack_4_1i)
    i4stack_4_1i = i4stack_4_1i - 1
    ad_count4 = i4stack_4_1(i4stack_4_1i)
    i4stack_4_1i = i4stack_4_1i - 1
    
    DO i5 = 1,ad_count4
      j = i4stack_4_1(i4stack_4_1i)
      i4stack_4_1i = i4stack_4_1i - 1
      ad_count3 = i4stack_4_1(i4stack_4_1i)
      i4stack_4_1i = i4stack_4_1i - 1
      
      DO i4 = 1,ad_count3
        y = i4stack_4_1(i4stack_4_1i)
        i4stack_4_1i = i4stack_4_1i - 1
        
        IF (.NOT.(((surv.LE.0.0.AND.(iage.EQ.0.0.OR.iage.NE.INT(iage)))&
        &))) survb1_pars = survb1_pars + iage * surv**(iage - 1) * s_yi&
        &jb1_pars(y,i,j)
        
        s_yijb1_pars(y,i,j) = 0.0
      ENDDO 
      
      iage = i4stack_4_1(i4stack_4_1i)
      i4stack_4_1i = i4stack_4_1i - 1
    ENDDO 
    
  ENDDO 
  
  n_ysb1_pars = 0.0
  ad_count2 = i4stack_4_1(i4stack_4_1i)
  i4stack_4_1i = i4stack_4_1i - 1
  
  DO i3 = 1,ad_count2
    y = i4stack_4_1(i4stack_4_1i)
    i4stack_4_1i = i4stack_4_1i - 1
    ad_count1 = i4stack_4_1(i4stack_4_1i)
    i4stack_4_1i = i4stack_4_1i - 1
    
    DO i2 = 1,ad_count1
      isex = i4stack_4_1(i4stack_4_1i)
      i4stack_4_1i = i4stack_4_1i - 1
      temp = surv * n_ys(y,isex)
      tempb1_pars = -(inv_totfec_ysb1_pars(y,isex) / temp**2)
      survb1_pars = survb1_pars + n_ys(y,isex) * tempb1_pars
      n_ysb1_pars(y,isex) = n_ysb1_pars(y,isex) + surv * tempb1_pars
      inv_totfec_ysb1_pars(y,isex) = 0.0
    ENDDO 
    
  ENDDO 
  
  roib1_pars = 0.0
  ad_count0 = i4stack_4_1(i4stack_4_1i)
  i4stack_4_1i = i4stack_4_1i - 1
  
  DO i1 = 1,ad_count0
    y = i4stack_4_1(i4stack_4_1i)
    i4stack_4_1i = i4stack_4_1i - 1
    ad_count = i4stack_4_1(i4stack_4_1i)
    i4stack_4_1i = i4stack_4_1i - 1
    
    DO i0 = 1,ad_count
      isex = i4stack_4_1(i4stack_4_1i)
      i4stack_4_1i = i4stack_4_1i - 1
      n_ys(y,isex) = r4stack_4_1(r4stack_4_1i)
      r4stack_4_1i = r4stack_4_1i - 1
      n_ysb1_pars(y - 1,isex) = n_ysb1_pars(y - 1,isex) + roi * n_ysb1_&
      &pars(y,isex)
      roib1_pars = roib1_pars + n_ys(y - 1,isex) * n_ysb1_pars(y,isex)
      n_ysb1_pars(y,isex) = 0.0
    ENDDO 
    
  ENDDO 
  
  n0_mb1_pars = n_ysb1_pars(first_y,1)
  n_ysb1_pars(first_y,1) = 0.0
  n0_fb1_pars = n_ysb1_pars(first_y,0)
  
ENDSUBROUTINE RBearded2__POPULATE_BPARS

!  Differentiation of bearded2__unpack in reverse (adjoint) mode:
!   gradient     of useful results: roi surv n0_f n0_m
!   with respect to varying inputs: pars
!  i_HS
!  ... NB I don't mind using if's in the constructor, since it's only run once
!  ... in lglk code, one_if() is faster
!  make_data_summaries
!  ----------------------------------------------------------------------------
!  Unpack R parameter-vector into meaningful pop dyn params
SUBROUTINE RBearded2__UNPACK_BPARS(pars,parsb1_pars)

  IMPLICIT NONE
  REAL , INTENT (IN):: pars(n_par)
  REAL :: parsb1_pars(n_par)
  USE COMMON
  INTEGER :: i
  INTRINSIC EXP
  REAL :: result1
  REAL :: result1b1_pars
  REAL :: temp
  INTEGER :: ad_count
  INTEGER :: i0
  !  Surely there is a copy-style function in ADT/C ? No doc of it tho
  !  ADT Pascal has one
  i = 1
  ad_count = 0
  
  DO WHILE (i.LE.n_par)
    temp_pars(i) = pars(i)
    i4stack_5_1i = i4stack_5_1i + 1
    i4stack_5_1(i4stack_5_1i) = i
    i = i + 1
    ad_count = ad_count + 1
  ENDDO 
  
  i4stack_5_1i = i4stack_5_1i + 1
  i4stack_5_1(i4stack_5_1i) = ad_count
  nextpari = 1
  i4stack_5_1i = i4stack_5_1i + 1
  i4stack_5_1(i4stack_5_1i) = nextpari
  result1 = RBearded2__NEXT_PARAM_CB()
  i4stack_5_1i = i4stack_5_1i + 1
  i4stack_5_1(i4stack_5_1i) = nextpari
  r8stack_5_1i = r8stack_5_1i + 1
  r8stack_5_1(r8stack_5_1i) = result1
  result1 = RBearded2__NEXT_PARAM_CB()
  i4stack_5_1i = i4stack_5_1i + 1
  i4stack_5_1(i4stack_5_1i) = nextpari
  r8stack_5_1i = r8stack_5_1i + 1
  r8stack_5_1(r8stack_5_1i) = result1
  result1 = RBearded2__NEXT_PARAM_CB()
  i4stack_5_1i = i4stack_5_1i + 1
  i4stack_5_1(i4stack_5_1i) = nextpari
  r8stack_5_1i = r8stack_5_1i + 1
  r8stack_5_1(r8stack_5_1i) = result1
  result1 = RBearded2__NEXT_PARAM_CB()
  temp = EXP(-result1) + 1.0
  result1b1_pars = EXP(-result1) * survb1_pars / temp**2
  result1 = r8stack_5_1(r8stack_5_1i)
  r8stack_5_1i = r8stack_5_1i - 1
  nextpari = i4stack_5_1(i4stack_5_1i)
  i4stack_5_1i = i4stack_5_1i - 1
  temp_parsb1_pars = 0.0
  CALL RBearded2__NEXT_PARAM_BPARS(result1b1_pars)
  result1b1_pars = EXP(result1) * n0_mb1_pars
  result1 = r8stack_5_1(r8stack_5_1i)
  r8stack_5_1i = r8stack_5_1i - 1
  nextpari = i4stack_5_1(i4stack_5_1i)
  i4stack_5_1i = i4stack_5_1i - 1
  CALL RBearded2__NEXT_PARAM_BPARS(result1b1_pars)
  result1b1_pars = EXP(result1) * n0_fb1_pars
  result1 = r8stack_5_1(r8stack_5_1i)
  r8stack_5_1i = r8stack_5_1i - 1
  nextpari = i4stack_5_1(i4stack_5_1i)
  i4stack_5_1i = i4stack_5_1i - 1
  CALL RBearded2__NEXT_PARAM_BPARS(result1b1_pars)
  result1b1_pars = EXP(result1) * roib1_pars
  nextpari = i4stack_5_1(i4stack_5_1i)
  i4stack_5_1i = i4stack_5_1i - 1
  CALL RBearded2__NEXT_PARAM_BPARS(result1b1_pars)
  parsb1_pars = 0.0
  ad_count = i4stack_5_1(i4stack_5_1i)
  i4stack_5_1i = i4stack_5_1i - 1
  
  DO i0 = 1,ad_count
    i = i4stack_5_1(i4stack_5_1i)
    i4stack_5_1i = i4stack_5_1i - 1
    parsb1_pars(i) = parsb1_pars(i) + temp_parsb1_pars(i)
    temp_parsb1_pars(i) = 0.0
  ENDDO 
  
  
ENDSUBROUTINE RBearded2__UNPACK_BPARS

!  Differentiation of bearded2__next_param in reverse (adjoint) mode:
!   gradient     of useful results: temp_pars bearded2__next_param
!   with respect to varying inputs: temp_pars
! b_mort = exp(next_param());
! c_mort = exp(next_param());
! d_mort = exp(next_param());
!  Hide the next bit from  ADT; for one thing, strings aren't understood...
!  but there never any reason to AD this, so don't
!  unpack
!  Helper for unpack
SUBROUTINE RBearded2__NEXT_PARAM_BPARS(next_paramb1_pars)

  USE COMMON
  IMPLICIT NONE
  REAL :: valb1_pars
  ! //
  REAL :: next_paramb1_pars
  valb1_pars = next_paramb1_pars
  temp_parsb1_pars(nextpari) = temp_parsb1_pars(nextpari) + valb1_pars
  
ENDSUBROUTINE RBearded2__NEXT_PARAM_BPARS

!  i_HS
!  ... NB I don't mind using if's in the constructor, since it's only run once
!  ... in lglk code, one_if() is faster
!  make_data_summaries
!  ----------------------------------------------------------------------------
!  Unpack R parameter-vector into meaningful pop dyn params
SUBROUTINE RBearded2__UNPACK_CB(pars)

  IMPLICIT NONE
  REAL , INTENT (IN):: pars(n_par)
  USE COMMON
  INTEGER :: i
  INTRINSIC EXP
  REAL :: result1
  !  Surely there is a copy-style function in ADT/C ? No doc of it tho
  !  ADT Pascal has one
  i = 1
  
  DO WHILE (i.LE.n_par)
    temp_pars(i) = pars(i)
    i = i + 1
  ENDDO 
  
  nextpari = 1
  result1 = RBearded2__NEXT_PARAM_CB()
  roi = EXP(result1)
  result1 = RBearded2__NEXT_PARAM_CB()
  n0_f = EXP(result1)
  result1 = RBearded2__NEXT_PARAM_CB()
  n0_m = EXP(result1)
  result1 = RBearded2__NEXT_PARAM_CB()
  surv = 1.0 / (1.0 + EXP(-result1))
  
ENDSUBROUTINE RBearded2__UNPACK_CB

!  Differentiation of n_log_p in reverse (adjoint) mode:
!   gradient     of useful results: p n_log_p
!   with respect to varying inputs: p
!  ----------------------------------------------------------------------------
!  Support routine; this and dr_n_log_p should be part of ADT maths lib, with black-box too
SUBROUTINE RBearded2N_LOG_P_BPARS(n,p,pb1_pars,n_log_pb1_pars)

  IMPLICIT NONE
  INTEGER , INTENT (IN):: n
  REAL , INTENT (IN):: p
  REAL :: pb1_pars
  USE COMMON
  INTRINSIC LOG
  INTEGER :: result1
  REAL :: n_log_pb1_pars
  result1 = ONE_IF(p.EQ.0)
  pb1_pars = pb1_pars + n * n_log_pb1_pars / (result1 + p)
  
ENDSUBROUTINE RBearded2N_LOG_P_BPARS

