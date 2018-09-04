! ----------------------------------------------------------------------------
MODULE DIFFSIZES
  INTEGER , parameter :: nbdirsmax = 25
ENDMODULE
! ----------------------------------------------------------------------------
! Including stdlib.f
! ----------------------------------------------------------------------------
! ----------------------------------------------------------------------------
! Standard definitions of needed functions
! ----------------------------------------------------------------------------
SUBROUTINE CheckSizeInteger1(a,i)

  INTEGER :: i
  INTEGER :: a(:)
  
ENDSUBROUTINE 

! ----------------------------------------------------------------------------
SUBROUTINE CheckSizeInteger4(a,i)

  INTEGER :: i
  INTEGER :: a(:)
  
ENDSUBROUTINE 

! ----------------------------------------------------------------------------
SUBROUTINE CheckSizeInteger8(a,i)

  INTEGER :: i
  INTEGER :: a(:)
  
ENDSUBROUTINE 

! ----------------------------------------------------------------------------
SUBROUTINE CheckSizeReal4(a,i)

  INTEGER :: i
  REAL :: a(:)
  
ENDSUBROUTINE 

! ----------------------------------------------------------------------------
SUBROUTINE CheckSizeReal8(a,i)

  INTEGER :: i
  REAL :: a(:)
  
ENDSUBROUTINE 

! ----------------------------------------------------------------------------
SUBROUTINE CheckSizeReal16(a,i)

  INTEGER :: i
  REAL :: a(:)
  
ENDSUBROUTINE 

! ----------------------------------------------------------------------------
INTEGER FUNCTION one_if(a)

  LOGICAL :: a
  
  IF (A) THEN
  
    one_if = 1
    
  ELSE 
  
    one_if = 0
    
  ENDIF 
  
  
ENDFUNCTION 


! ----------------------------------------------------------------------------
MODULE COMMON
  
  INTEGER, PARAMETER :: dim_stack
  
  INTEGER a(n_samp )
  INTEGER amat
  INTEGER by(n_samp )
  INTEGER first_y
  INTEGER first_y_sample
  REAL inv_totfec_ys(first_y:last_y,0:1 )
  INTEGER isamp_POP(n_POP )
  INTEGER jsamp_POP(n_POP )
  INTEGER last_y
  REAL(8) N0_f
  REAL(8) N0_m
  INTEGER n_comps_ytbsm(first_y:last_y,first_y:last_y,first_y:last_y,0:&
  &1,0:1 )
  INTEGER n_par
  INTEGER n_POP
  INTEGER n_samp
  REAL N_ys(first_y:last_y,0:1 )
  INTEGER nextpari
  REAL Pr_PO_ytbs(first_y:last_y,first_y:last_y,first_y:last_y,0:1 )
  REAL(8) roi
  INTEGER sex(n_samp )
  REAL sqrt_Pr_PO_ytbs(first_y:last_y,first_y:last_y,first_y:last_y,0:1&
  & )
  INTEGER tcap(n_samp )
  REAL temp_pars(n_par )
  INTEGER ymat_atmost(n_samp )
  
END

! ----------------------------------------------------------------------------


! isex
! y
!  populate
!  ---------------------------------------------------------------------------
!  All CKMR probs

SUBROUTINE Bearded2__calc_probs(dummy)
INTEGER , INTENT (IN) :: dummy 

USE COMMON

  INTEGER pby, pdy, pcapt, pmaty, isex, oby
  Pr_PO_ytbs = 0
  pby = first_y
  DO WHILE(pby .LE. last_y)
  
    pcapt = first_y_sample
    DO WHILE(pcapt .LE. last_y)
    
      oby = first_y
      DO WHILE(oby .LE. last_y)
      
        isex = 0
        DO WHILE(isex .LE. 1)
        
          pmaty = pby + amat
          Pr_PO_ytbs(pby,pcapt,oby,isex) = one_if(pmaty .LE. oby) * one&
          &_if(pcapt .GT. oby) * one_if((pcapt - pby) .LE. 38) * one_if&
          &((pby - oby) .LE. 38) * inv_totfec_ys(oby,isex)
        
        isex = isex + 1
        END DO 
        
      
      oby = oby + 1
      END DO 
      
    
    pcapt = pcapt + 1
    END DO 
    
  
  pby = pby + 1
  END DO 
  
END 


! isex
!  oby
!  pcapt
!  pmaty
!  calc_probs
!  ----------------------------------------------------------------------------
!  Log-likelihood

REAL(8) FUNCTION Bearded2__lglk(pars)
REAL , INTENT (IN) :: pars(n_par ) 

USE COMMON

  INTEGER pby, pcapt, oby, isex
  REAL(8) tot_lglk
  ! //
  CALL Bearded2__unpack(pars)
  !  dummy arg
  CALL Bearded2__populate(0)
  CALL Bearded2__calc_probs(0)
  tot_lglk = 0
  pby = first_y
  DO WHILE(pby .LE. last_y)
  
    pcapt = first_y
    DO WHILE(pcapt .LE. last_y)
    
      oby = first_y
      DO WHILE(oby .LE. last_y)
      
        isex = 0
        DO WHILE(isex .LE. 1)
        !  Poisson approximation: fine if N is fairly big
        ! 
        !         				  tot_lglk +=
        !         					-n_comps_ytb[pmaty][pcapt][oby] *
        !         					Pr_PO_ytb[pmaty][pcapt][oby]
        !         					+ n_log_p(
        !         						n_PO_ytb[pmaty][pcapt][oby],
        !         						n_comps_ytb[pmaty][pcapt][oby] *
        !         						Pr_PO_ytb[pmaty][pcapt][oby]
        !         					);
        !         				  
        
          tot_lglk = tot_lglk + (n_log_p(n_comps_ytbsm(pby,pcapt,oby,is&
          &ex,0),1 - Pr_PO_ytbs(pby,pcapt,oby,isex)))
        
        isex = isex + 1
        END DO 
        
      
      oby = oby + 1
      END DO 
      
    
    pcapt = pcapt + 1
    END DO 
    
  
  pby = pby + 1
  END DO 
  
  ! isex
  !  oby
  !  pcapt
  !  pmaty
  pby = first_y
  DO WHILE(pby .LE. last_y)
  
    pcapt = first_y
    DO WHILE(pcapt .LE. last_y)
    
      oby = first_y
      DO WHILE(oby .LE. last_y)
      
        isex = 0
        DO WHILE(isex .LE. 1)
        
          tot_lglk = tot_lglk + (n_log_p(n_comps_ytbsm(pby,pcapt,oby,is&
          &ex,1),Pr_PO_ytbs(pby,pcapt,oby,isex)))
        
        isex = isex + 1
        END DO 
        
      
      oby = oby + 1
      END DO 
      
    
    pcapt = pcapt + 1
    END DO 
    
  
  pby = pby + 1
  END DO 
  
  !  isex
  !  oby
  !  pcapt
  !  pmaty
  !  Binomial version could be:
  !  tot_lglk += n_log_p( n_PO_ytb[ pmaty][ pcapt][ oby],
  !       Pr_PO_ytb[ pmaty][ pcapt][ oby]) +
  !     n_log_p( n_comps_ytb[ pmaty][ pcapt][ oby] - n_PO_ytb[ pmaty][ pcapt][ oby],
  !       1-Pr_PO_ytb[ pmaty][ pcapt][ oby]);
  !  Bin version *without* n_log_p needs if-statements to avoid log(0)
  !  and should use log1p( -Pr_PO_ytb[ pmaty][ pcapt][ oby])
  !  otherwise you can get rounding problems when N is large.
  !  You have been warned !
  IF (tot_lglk .NE. tot_lglk) THEN 
  
    isex = 2
  END IF 
  
  Bearded2__lglk = (tot_lglk)
  RETURN 
END 


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

SUBROUTINE Bearded2__make_data_summaries()

USE COMMON

  INTEGER i_samp, j_samp, this_by, this_oby, this_capt, this_pby, this_&
  &maty, this_sex, i_POP
  !  compute birth years for each sampled animal
  i_samp = 1
  DO WHILE(i_samp .LE. n_samp)
  
    this_by = tcap(i_samp) - a(i_samp)
    by(i_samp) = this_by
    !  For i_samp as possible parent, need year of maturity...
    !  or, if that's < first_y, just use first_y...
    ! note: we'll need to avoid doing comparisons where parent and offspring are both "born" in first_y
    ymat_atmost(i_samp) = MAX(first_y,this_by + amat)
  
  i_samp = i_samp + 1
  END DO 
  
  !  i_samp
  
  n_comps_ytbsm = 0
  i_samp = 1
  DO WHILE(i_samp .LT. n_samp)
  
    j_samp = i_samp + 1
    DO WHILE(j_samp .LE. n_samp)
    !  In this case, exclude comps where adult caught in year of juve birth...
    !  depends on biol & sampling
    !  First case: i is P, j is O
    
      this_oby = by(j_samp)
      this_pby = by(i_samp)
      this_capt = tcap(i_samp)
      this_maty = ymat_atmost(i_samp)
      this_sex = sex(i_samp)
      !  exclude born-in-year-of-cap - this will also remove case where offspring born <= year 1
      IF ((this_oby .GE. this_maty) .AND. (this_maty .LE. last_y) .AND.&
      & (this_oby .LT. this_capt) .AND. (this_oby .NE. this_capt)) THEN&
      & 
      
        n_comps_ytbsm(this_pby,this_capt,this_oby,this_sex,0) = n_comps&
        &_ytbsm(this_pby,this_capt,this_oby,this_sex,0) + (1)
      END IF 
      
      !  Second case: i is O, j is P
      this_oby = by(i_samp)
      this_pby = by(j_samp)
      this_capt = tcap(j_samp)
      this_maty = ymat_atmost(j_samp)
      this_sex = sex(j_samp)
      !  exclude born-in-year-of-cap - this will also remove case where offspring born <= year 1
      IF ((this_oby .GE. this_maty) .AND. (this_maty .LE. last_y) .AND.&
      & (this_oby .LT. this_capt) .AND. (this_oby .NE. this_capt)) THEN&
      & 
      
        n_comps_ytbsm(this_pby,this_capt,this_oby,this_sex,0) = n_comps&
        &_ytbsm(this_pby,this_capt,this_oby,this_sex,0) + (1)
      END IF 
      
    
    j_samp = j_samp + 1
    END DO 
    
  
  i_samp = i_samp + 1
  END DO 
  
  !  jsamp
  !  isamp
  i_POP = 1
  DO WHILE(i_POP .LT. n_POP)
  
    i_samp = isamp_POP(i_POP)
    j_samp = jsamp_POP(i_POP)
    !  First case: i is P, j is O
    this_oby = by(j_samp)
    this_pby = by(i_samp)
    this_capt = tcap(i_samp)
    this_maty = ymat_atmost(i_samp)
    this_sex = sex(i_samp)
    !  exclude born-in-year-of-cap - this will also remove case where offspring born <= year 1
    IF ((this_oby .GE. this_maty) .AND. (this_maty .LE. last_y) .AND. (&
    &this_oby .LT. this_capt) .AND. (this_oby .NE. this_capt)) THEN 
    ! have to take away from negative comparisons 
    
      n_comps_ytbsm(this_pby,this_capt,this_oby,this_sex,0) = n_comps_y&
      &tbsm(this_pby,this_capt,this_oby,this_sex,0) - (1)
      n_comps_ytbsm(this_pby,this_capt,this_oby,this_sex,1) = n_comps_y&
      &tbsm(this_pby,this_capt,this_oby,this_sex,1) + (1)
    END IF 
    
    !  Second case: i is O, j is P
    this_oby = by(i_samp)
    this_pby = by(j_samp)
    this_capt = tcap(j_samp)
    this_maty = ymat_atmost(j_samp)
    this_sex = sex(j_samp)
    !  exclude born-in-year-of-cap - this will also remove case where offspring born <= year 1
    IF ((this_oby .GE. this_maty) .AND. (this_maty .LE. last_y) .AND. (&
    &this_oby .LT. this_capt) .AND. (this_oby .NE. this_capt)) THEN 
    ! have to take away from negative comparisons 
    
      n_comps_ytbsm(this_pby,this_capt,this_oby,this_sex,0) = n_comps_y&
      &tbsm(this_pby,this_capt,this_oby,this_sex,0) - (1)
      n_comps_ytbsm(this_pby,this_capt,this_oby,this_sex,1) = n_comps_y&
      &tbsm(this_pby,this_capt,this_oby,this_sex,1) + (1)
    END IF 
    
  
  i_POP = i_POP + 1
  END DO 
  
END 


!  Hide the next bit from  ADT; for one thing, strings aren't understood...
!  but there never any reason to AD this, so don't
!  unpack
!  Helper for unpack

REAL(8) FUNCTION Bearded2__next_param()

USE COMMON

  REAL(8) val
  ! //
  val = temp_pars(nextpari)
  nextpari = nextpari + (1)
  Bearded2__next_param = (val)
  RETURN 
END 


!  next_param
!  ---------------------------------------------------------------------------
!  Fill in pop dyn from parameters. Age-structured version is more interesting

SUBROUTINE Bearded2__populate(dummy)
INTEGER , INTENT (IN) :: dummy 

USE COMMON

  INTEGER y, isex
  N_ys(first_y,0) = N0_f
  N_ys(first_y,1) = N0_m
  y = first_y + 1
  DO WHILE(y .LE. last_y)
  
    isex = 0
    DO WHILE(isex .LE. 1)
    
      N_ys(y,isex) = N_ys(y - 1,isex) * roi
    
    isex = isex + 1
    END DO 
    
  
  y = y + 1
  END DO 
  
  ! isex
  ! y
  !  Might as well do Total Reprod Output here in populate(), though...
  !  could also do in calc_probs. Actually we just need the inverse
  y = first_y
  DO WHILE(y .LE. last_y)
  
    isex = 0
    DO WHILE(isex .LE. 1)
    
      inv_totfec_ys(y,isex) = 1.0 / N_ys(y,isex)
    
    isex = isex + 1
    END DO 
    
  
  y = y + 1
  END DO 
  
END 


!  lglk
!  ----------------------------------------------------------------------------
!  sqrt of all CKMR probs--- needed iff DESIGNcopy

SUBROUTINE Bearded2__sqrt_probs(pars)
REAL , INTENT (IN) :: pars(n_par ) 

USE COMMON

  INTEGER pby, pcapt, oby, isex
  ! //
  CALL Bearded2__unpack(pars)
  !  dummy arg; ADT bug
  CALL Bearded2__populate(0)
  CALL Bearded2__calc_probs(0)
  sqrt_Pr_PO_ytbs = 0
  pby = first_y
  DO WHILE(pby .LE. last_y)
  
    pcapt = first_y
    DO WHILE(pcapt .LE. last_y)
    
      oby = first_y
      DO WHILE(oby .LE. last_y)
      
        isex = 0
        DO WHILE(isex .LE. 1)
        
          sqrt_Pr_PO_ytbs(pby,pcapt,oby,isex) = SQRT(Pr_PO_ytbs(pby,pca&
          &pt,oby,isex))
        
        isex = isex + 1
        END DO 
        
      
      oby = oby + 1
      END DO 
      
    
    pcapt = pcapt + 1
    END DO 
    
  
  pby = pby + 1
  END DO 
  
END 


!  i_POP
!  ... NB I don't mind using if's in the constructor, since it's only run once
!  ... in lglk code, one_if() is faster
!  make_data_summaries
!  ----------------------------------------------------------------------------
!  Unpack R parameter-vector into meaningful pop dyn params

SUBROUTINE Bearded2__unpack(pars)
REAL , INTENT (IN) :: pars(n_par) 

USE COMMON

  INTEGER i
  !  Surely there is a copy-style function in ADT/C ? No doc of it tho
  !  ADT Pascal has one
  i = 1
  DO WHILE(i .LE. n_par)
  
    temp_pars(i) = pars(i)
  
  i = i + 1
  END DO 
  
  nextpari = 1
  roi = EXP(Bearded2__next_param())
  N0_f = EXP(Bearded2__next_param())
  N0_m = EXP(Bearded2__next_param())
END 


!  ----------------------------------------------------------------------------
!  Support routine; this and dr_n_log_p should be part of ADT maths lib, with black-box too

REAL(8) FUNCTION n_log_p(n, p)
INTEGER , INTENT (IN) :: n 
REAL(8) , INTENT (IN) :: p 

USE COMMON

  n_log_p = (n * LOG(p + one_if(p .EQ. 0)))
  RETURN 
END 
