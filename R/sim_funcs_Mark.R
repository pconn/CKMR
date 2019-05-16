sample_seal_sim <- function( bs, first_y, last_y, samp_size, print.=TRUE) {
  # Two-sex version
  most_bs <- bs %where% (BY>0) # founders are born in year "-1"--- zap them
  
  # most_bs <- most_bs %where% (SEX=='F') # *** FEMALES ONLY *** !!!
  
  ysamp <- first_y:last_y
  
  # I *think* this uses the "right" intercept etc:
  if( print.) {
    print( summary( glm( c( fmatat[ first_y:last_y]) ~ I( 0:(last_y-first_y)), family=poisson( link=log))))
    scatn( 'Mean adult females: %5.2f', mean( fmatat[ first_y:last_y]))
  }
  
  if( length( samp_size)==1) {
    samp_size <- rep( samp_size, length( ysamp))
  }
  samp_size <- offarray( samp_size, first=first_y, last=last_y)
  n_samps <- sum( samp_size)
  
  # "Empty" data.frame of correct size
  samps <- most_bs[ rep( 1, n_samps),]
  
  
  last_samp_row <- 0
  for( iy in ysamp) {
    die_now <- which( most_bs$DY == iy)
    samp_now <- sample( die_now, samp_size[ iy], replace=FALSE)
    
    new_samp_rows <- last_samp_row + (1:samp_size[iy])
    samps[ new_samp_rows,] <- most_bs[ samp_now,]
    last_samp_row <- tail( new_samp_rows, 1)
  }
  
  mum_rows <- match( samps$ID, samps$MUM, 0) # NB one mum can have several offspring ...
  mumids <- samps$ID[ mum_rows>0]            # but these are unique; only the first offo of each mum
  
  is_off <- samps$MUM %in% mumids # ... but each offo in a MOP has to have one of those mums
  
  isamp_MOP <- which( is_off) # isamp is always the offspring
  jsamp_MOP <- match( samps$MUM[ isamp_MOP], samps$ID) # jsamp is always the parent
  
  dad_rows <- match( samps$ID, samps$DAD, 0) # NB one mum can have several offspring ...
  dadids <- samps$ID[ dad_rows>0]            # but these are unique; only the first offo of each mum
  
  is_off <- samps$DAD %in% dadids # ... but each offo in a MOP has to have one of those mums
  
  isamp_FOP <- which( is_off) # isamp is always the offspring
  jsamp_FOP <- match( samps$DAD[ isamp_FOP], samps$ID) # jsamp is always the parent
  
  isamp_POP <- c( isamp_MOP, isamp_FOP)
  jsamp_POP <- c( jsamp_MOP, jsamp_FOP)
  
  samps <- samps[ cq( ID, SEX, DY, DA)]
  # samps$DY is "tcap"
  # samps$DA is "a"
  return( returnList( samps, isamp_POP, jsamp_POP))
}

sample_seal_sim2 <- function( bs, first_y, last_y, samp_size, strata_probs = NULL,print.=TRUE) {
  ## Two-sex version
  ## POPs, FSPs, mat & pat HSPs
  ## See "return" at the end for outputs
  ## if print.==TRUE, show simple summaries (ie demographic truth)
  ## EG: set.seed( 99); test <- sample_seal_sim( bs2, first_y=31, last_y=50, samp_size=100)
  ## 14 Mar 2019: now includes strata specific sampling probs (optional)
  
  most_bs <- bs %where% (BY>0) # founders are born in year "-1"--- zap them
  if(is.null(strata_probs))strata_probs = rep(1,max(bs$STOCK))
  # most_bs <- most_bs %where% (SEX=='F') # *** FEMALES ONLY *** !!!
  
  ysamp <- first_y:last_y
  
  # I *think* this uses the "right" intercept etc:
  #if( print.) {
  #  print( summary( glm( c( fmatat[ first_y:last_y]) ~ I( 0:(last_y-first_y)), family=poisson( link=log))))
  #  scatn( 'Mean adult females: %5.2f', mean( fmatat[ first_y:last_y]))
  #}
  
  if( length( samp_size)==1) {
    samp_size <- rep( samp_size, length( ysamp))
  }
  samp_size <- offarray( samp_size, first=first_y, last=last_y)
  n_samps <- sum( samp_size)
  
  # "Empty" data.frame of correct size
  samps <- most_bs[ rep( 1, n_samps),]
  
  
  last_samp_row <- 0
  for( iy in ysamp) {
    die_now <- which( most_bs$DY == iy)
    samp_now <- sample( die_now, samp_size[ iy],prob=strata_probs[most_bs[die_now,"STOCK"]], replace=FALSE)
    
    new_samp_rows <- last_samp_row + (1:samp_size[iy])
    samps[ new_samp_rows,] <- most_bs[ samp_now,]
    last_samp_row <- tail( new_samp_rows, 1)
  }
  
  #alternate for testing below
  #mum_rows = which(samps$ID %in% samps$MUM)  #these rows are the mothers
  #isamp_MOP = which(samps$MUM %in% samps$ID[mum_rows])  #can be > # mothers since mother can produce >1 o
  #jsamp_MOP = rep(0,length(isamp_MOP))
  #for(i in 1:length(isamp_MOP))jsamp_MOP[i]=which(samps$ID==samps[isamp_MOP[i],"MUM"])
  
  
  # could do this:
  # mumids <- with( samps, ID %that.are.in% MUM) # or use base::intersect() if you care nothing for clarity
  
  mum_rows <- match( samps$ID, samps$MUM, 0) # NB one mum can have several offspring ...
  mumids <- samps$ID[ mum_rows>0]            # but these are unique; only the first offo of each mum
  
  is_off <- samps$MUM %in% mumids # ... but each offo in a MOP has to have one of those mums
  
  isamp_MOP <- which( is_off) # isamp is always the offspring
  jsamp_MOP <- match( samps$MUM[ isamp_MOP], samps$ID) # jsamp is always the parent
  
  dad_rows <- match( samps$ID, samps$DAD, 0) # NB one mum can have several offspring ...
  dadids <- samps$ID[ dad_rows>0]            # but these are unique; only the first offo of each mum
  
  is_off <- samps$DAD %in% dadids # ... but each offo in a MOP has to have one of those mums
  
  isamp_FOP <- which( is_off) # isamp is always the offspring
  jsamp_FOP <- match( samps$DAD[ isamp_FOP], samps$ID) # jsamp is always the parent
  
  isamp_POP <- c( isamp_MOP, isamp_FOP)
  jsamp_POP <- c( jsamp_MOP, jsamp_FOP)
  
  #### Sibs: clusters can occur. If eg 4 animals have same MUM, that generates 6 MHSPs. I don't see a "neat"
  # ... way to vectorize that; since there won't be that many sib-pairs, just loop over relevant parents
  
  # FSPs
  mapa <- with( samps,  MUM %&% '&' %&% DAD)
  FSPars <- unique( mapa[ duplicated( mapa)])
  
  # How many overall...
  tabbo <- tabulate( table( mapa %that.are.in% FSPars)) # tabbo[1] = #FSPars occuring once (zero), [2] = #FSPars of just one FSP, etc
  nx <- seq_along( tabbo)
  n_FSP <- tabbo %**% ( nx * (nx-1) / 2)
  
  isamp_FSP <- jsamp_FSP <- integer( n_FSP)
  ii <- 0
  for( iFSPar in FSPars) {
    whicho <- which( mapa==iFSPar)
    eg <- expand.grid( i=whicho, j=whicho) %where% (i < j)
    isamp_FSP[ ii + (1 %upto% nrow( eg))] <- eg$i
    jsamp_FSP[ ii + (1 %upto% nrow( eg))] <- eg$j
    ii <- ii + nrow( eg)
  }
  FSP_samp_combo <- sprintf( '%s&%s', isamp_FSP, jsamp_FSP) # used to check HSPs later
  
  isamp_HSP <- jsamp_HSP <- list( MUM=integer(), DAD=integer())
  
  for( sharpar in cq( MUM, DAD)) {
    HSPars <- unique( samps[[ sharpar]] %such.that% duplicated(.))
    tabbo <- tabulate( table( samps[[ sharpar]] %that.are.in% HSPars))
    nx <- seq_along( tabbo)
    n_HSP <- tabbo %**% ( nx * (nx-1) / 2)
    
    isamp <- jsamp <- integer( n_HSP)
    ii <- 0
    for( iHSPar in HSPars) {
      whicho <- which( samps[[ sharpar]]==iHSPar)
      eg <- expand.grid( i=whicho, j=whicho) %where% (i < j)
      isamp[ ii + (1 %upto% nrow( eg))] <- eg$i
      jsamp[ ii + (1 %upto% nrow( eg))] <- eg$j
      ii <- ii + nrow( eg)
    }
    
    # Eliminate FSPs:
    is_FSP <- sprintf( '%s&%s', isamp, jsamp) %in% FSP_samp_combo
    isamp <- isamp[ !is_FSP]
    jsamp <- jsamp[ !is_FSP]
    
    isamp_HSP[[ sharpar]] <- isamp
    jsamp_HSP[[ sharpar]] <- jsamp
    
    # Full realism would blur this by adding mtDNA and not recording definite MHSP/PHSP
  }
  
  isamp_MHSP <- isamp_HSP$MUM
  jsamp_MHSP <- jsamp_HSP$MUM
  isamp_PHSP <- isamp_HSP$DAD
  jsamp_PHSP <- jsamp_HSP$DAD
  
  
  # Could also do GGPs; NFN
  
  
  samps <- samps[ cq( ID, SEX, DY, DA, STOCK)]
  # samps$DY is "tcap"
  # samps$DA is "a"
  return( returnList(
    samps,
    isamp_POP, jsamp_POP, # ie rows in 'samps'
    isamp_FSP, jsamp_FSP,
    isamp_MHSP, jsamp_MHSP,
    isamp_PHSP, jsamp_PHSP
  ))
}

read_seal_sim <- function( filename=NULL, all_bs=NULL) {
  library( mvbutils)
  library( offarray)
  library( atease)
  
  if( is.null( all_bs)) {
    all_bs <- read.csv( filename, stringsAsFactors=FALSE)
  } else if( all_bs %is.not.a% 'data.frame') {
    # R is pretty crap with this; eg apply() is useless
    listo <- vector( 'list', ncol( all_bs))
    all_bs[ all_bs=='alive'] <- 'NA' # simplifies matters...
    for( i in 1:ncol( all_bs)) {
      listo[[i]] <- type.convert( all_bs[,i], as.is=TRUE)
    }
    all_bs <- data.frame( listo, stringsAsFactors=FALSE)
  }
  names( all_bs) <- cq( ID, SEX, DAD, MUM, BY, DY, STOCK, DA)
  # DA is Death-Age; BY is Birth-Year; DY is Death-Year
  
  # Format of that particularl file is in-principle problematic
  # ... because a Founder that does not die will never have its age recorded !
  # Fudge is OK here
  
  #all_bs <- within( all_bs, {
  all_bs$DY <- as.integer( all_bs$DY) # convert "alive" to NA
  all_bs$BY[ all_bs$BY < 1] <- NA
  all_bs$BY <- ifelse( is.na( all_bs$BY), all_bs$DY - all_bs$DA + 1, all_bs$BY) # should get all of them...
    
    # DY2: DY if known, or "well into the future" if still alive at the end
  all_bs$DY2 <- ifelse( !is.na( all_bs$DY),
                        all_bs$DY,
                   max( all_bs$DY, na.rm=TRUE) + 10*max( all_bs$DA, na.rm=TRUE)) # IE in the future
    
    mumab <- all_bs$BY - all_bs$BY[ match( all_bs$MUM, all_bs$ID, NA)] # 6+, or NA
    mumdy <- all_bs$DY[ match( all_bs$MUM, all_bs$ID, NA)]
  #})
  
  
  AMAT <- min( mumab, na.rm=TRUE) # deduce...
  
  ########### Summaries of "truth"
  
  # In *THIS* dataset, you are *NOT* allowed to breed successfully even if you die that year...
  # ... hence ">=" next
  all_bs <- within( all_bs, {
    MATY <- ifelse( DY2 > BY + AMAT, BY+AMAT, NA)
  })
  
  nogaps <- function( ints, limits=range( ints, na.rm=TRUE)) {
    ## For use inside arg of call to table, eg table( LENGTH=nogaps( LENGTH), ...)
    ## or table( nogaps( LENGTH, 140:170))
    ## Ensures all integers in sequence are mentioned, even if no cases
    ## Doesn't change arg unless needed
    ## Values outside 'limits' go to NA
    ## EG
    ## nogaps( 1:2) # 1:2
    ## nogaps( c( 1, 1, 3, NA))
    # [1] 1    1    3    <NA>
    # Levels: 1 2 3
    
    limits <- range( limits, na.rm=TRUE)
    rseq <- seq( from=limits[1], to=limits[2])
    if( !all( rseq %in% unique( ints))) {
      ints <- factor( ints, levels=as.character( rseq))
    }
    return( ints)
  }
  
  
  # Count the mature females
  first_y <- min( all_bs$DY, na.rm=TRUE)
  last_y <- max( all_bs$BY)
  fmat_bs <- all_bs %where% ( (SEX=='F') & !is.na( MATY))
  fmat_bs <- within( fmat_bs, {
    MATY <- pmax( 1, pmin( MATY, last_y+1))
    GONE <- pmin( DY2+1, last_y+1)   #do we need +1 here anymore since can't breed in same year as dead?
  })
  
  ftab <- with( fmat_bs, table(
    nogaps( MATY, c( first_y, last_y)),
    GONE=nogaps( GONE, c( first_y, last_y+1)))) # MATY * GONE "matrix"
  fmatby <- cumsum( rowSums( ftab))
  fdeadby <- cumsum( colSums( ftab))
  fmatat <- fmatby - fdeadby[ names( fmatby)]
  
  
  fmatat <- offarray( fmatat, first=first_y, last=last_y)
  
  all_bs@file <- filename
  all_bs@fmatat <- fmatat
  return( all_bs)
}

fit_bd2_sim<-function(Cenv,sim_data,par_start){
  
  # R code to generate the objects that C expects to find
  #should include
  
  # int first_y;
  # int last_y;
  # int n_par;
  # int n_samp;  // individuals genotyped
  # int n_POP;   // pairs actually found
  # int amat;    // age-at-maturity; assumed 100% thereafter
  # ARRAY_1I tcap/* n_samp */;     // year of capture/sampling
  # ARRAY_1I a/* n_samp */;     // age at capture
  # ARRAY_1I isamp_POP/* n_POP */;   // sample-index of first animal in this POP
  # ARRAY_1I jsamp_POP/* n_POP */;   // ditto for second
  #sim_data <- Out
  first_y <- 1
  first_y_sample <- min(sim_data$samps$DY)
  last_y <- max(sim_data$samps$DY)
  n_par <- 3
  n_samp <- nrow(sim_data$samps)
  n_POP <- length(sim_data$isamp_POP)
  amat <- 6  #definitely need to generalize this; age at maturity is age at maturity here (note it was amat+1 for sims)
  tcap <- sim_data$samps$DY
  a <- sim_data$samps$DA
  sex <- rep(0,n_samp)
  sex[sim_data$samps$SEX =="M"] <- 1
  isamp_POP <- sim_data$isamp_POP
  jsamp_POP <- sim_data$jsamp_POP
  
  ck <- Cenv$create()  #R objects that match C code must be defined above
  
  Cenv$make_data_summaries( ck) # classic pattern for calls to C code-- ck will be 1st arg
  
  
  # much much later
  res1 <- Cenv$lglk( ck, par_start)
  grad1 <- Cenv$Dlglk(ck,par_start)
  
  fitme <- nlminb( par_start, NEG( Cenv$lglk), NEG( Cenv$Dlglk), Context = ck, control=list( trace=6))
  H <- numderiv( Cenv$Dlglk, fitme$par, Context = ck)
  
  stuff <- list( lglk = Cenv$lglk( ck, fitme$par),par=fitme$par,Sigma=-solve(H)) # also ensures all internal stuff is set right
  return(stuff)
}