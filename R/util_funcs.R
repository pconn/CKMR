numderiv <- function(f,x0,eps=0.0001, TWICE.=TRUE, param.name=NULL, ..., SIMPLIFY=TRUE) {
  if( is.null( param.name))
    ff <- function( x, ...) f( x, ...)
  else
    ff <- function( x, ...) {
      ll <- c( list( x), list( ...))
      names( ll)[1] <- param.name
      do.call( 'f', ll)
    }
  
  f0 <- ff(x0, ...)
  n <- length( x0)
  m <- matrix( 0, length(f0), n)
  for( i in 1:n) {
    this.eps <- eps * if( x0[ i]==0) 1 else x0[ i]
    m[,i] <- ( ff( x0+this.eps * (1:n==i), ...) - f0) / this.eps }
  if( !is.null( dim( f0)))
    dim( m) <- c( dim( f0), n)
  if( TWICE.) {
    mc <- match.call()
    mc$eps <- -eps
    mc$TWICE. <- FALSE
    m <- 0.5*(m + eval( mc, sys.frame( sys.parent())))
  }
  
  if( any( dim( m)==length( m)) && SIMPLIFY)
    m <- c( m) # demote 1D arrays to vectors
  
  return( m)
}

load_ADT_DLL <- function(
  envir= new.env( parent=topenv(), hash=TRUE),
  folder='./glypho_ckmr/Win32/Debug',
  rfolder=NULL){
  dlls <- dir( folder, patt=.Platform$dynlib.ext %&% '$', full.names=TRUE)
  stopifnot( length( dlls) == 1)
  
  loadio <- try( dyn.load( dlls))
  if( loadio %is.a% 'try-error') {
    scatn( "Can't seem to load DLL from file '%s'", dlls)
    stop( "dyn.load failed")
  }
  
  # Boring grubby sh** to find where the R source files (which
  # ... make "headers" for the C funcs) live...
  # Look for .../<folder>/<folder>/...
  if( is.null( rfolder)) {
    pathbits <- strsplit( folder, '/')[[1]]
    rsources <- NULL
    for( i in rev( seq_along( pathbits))) {
      aha <- paste( pathbits[ c( 1 %upto% i, i)], collapse='/')
      if( !dir.exists( aha)) { # nope
        next
      }
      rsources <- dir( aha, patt='_R_interface.r$', full.names=TRUE)
      if( length( rsources)) { # yep
        break
      }
    } # for i
    if( !length( rsources)) {
      scatn( "Can't work out where the <blah>_R_interface.r files live; please set 'rfolder' manually")
      stop( "dyn.load housekeeping failed")
    }
  }
  
  # Create R aliases/headers
  evalq( require <- function( ...) TRUE, envir=envir)
  tryCatch(
    lapply( rsources, source, local=envir),
    finally= rm( require, envir=envir)
  )
  
  # Registration not fully taken care of--- should fix in the R-interface files
  # routines <- names( getDLLRegisteredRoutines( loadio)$.Call)
  Croutines <- new.env( parent=envir)
  
  enviroutines <- lsall( envir)
  for( i in enviroutines) {
    # Don't bother with blah.routine if Rblah.routine also there
    if( ('R' %&% i) %in% enviroutines) {
      next
    }
    
    fun <- envir[[i]]
    # Make sure it's an ADT wrapper
    if( fun %is.a% 'function' &&
        length( body( fun))==2 &&
        body( fun)[[c(2,1)]]==as.name( 'return') &&
        ( body( fun)[[ c( 2, 2, 1)]]==as.name( '.Call') ||
          body( fun)[[ c( 2, 2, 1)]]==as.name( '.External')
        )
    ){
      body( fun)[[ c( 2, 2, 2)]] <- as.name( i)
      environment( fun) <- Croutines
      assign( sub( '^[^.]*[.]', '', i), fun, envir=envir)
      assign( i, getNativeSymbolInfo( '_' %&% i, loadio), envir=Croutines)
    }
  }
  rm( list=enviroutines, envir=envir)
  
  envir$create <- hack_create( envir$create) # no need to pass params in order by name in caller
  
  # Hack for now til nice wrappers exist:
  derivo <- ls( envir, patt='^LGLK_B[A-Z_]+$')
  
  # Genius R behaviour is to show the *wrong* code for the next function... but the
  # *contents* of the code should be OK (eg via body( Dlglk))
  # ... I hope !
  Dlglk <- eval( substitute(
    function( Context, p) {
      temp <- 0*p; LGLK_BPARAMS( Context, p, temp, 1); return( temp)
    },
    list( LGLK_BPARAMS=as.name( derivo))))
  environment( Dlglk) <- environment( envir$lglk)
  envir$Dlglk <- Dlglk
  
  envir$DLLinfo <- loadio # for unload
  
  # Auto-unload DLL when envir vanishes (eg via detach(), if onto search path)
  f <- function( e) try( dyn.unload( unclass(e$DLLinfo)$path))
  environment( f) <- .GlobalEnv # I hate complicated chains of environments
  reg.finalizer( Croutines, f) # risky in that envir may already have a finalizer... don't how to check!
  envir$Croutines <- Croutines
  return( envir)
}

