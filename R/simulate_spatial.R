# simulate spatial CKMR data

#' simulate spatial CKMR data
#' @param exp.type   exploitation type. Possible types are 'constant' (default), 'moderate.gradient', 'extreme.gradient'
#' @param dispersal.type  Type of dispersal - 'random' (default - complete mixing), 'all.ages', 'juvenile', or 'none' (all.ages and juvenile include dispersal kernels)
#' @param init.N Initial population size
#' @param samp.size Number of dead animals to genotype each year for last 20 years of time series
#' @param n.stocks Number of spatial strata
#' @return CKMR data
#' @export
#' @keywords simulation, spatial CKMR
#' @author Paul B. Conn
simulate_spatial <- function(exp.type="constant",dispersal.type="random",init.N=10000,samp.size=100,n.stocks=1){
  
  setwd("c:/users/paul.conn/git/CKMR")
  #load("fitbits.RDa")
  #options(repos=unique(c(mvb="https://markbravington.github.com/Rmvb-repo",getOption('repos'))))
  #install.packages(pkg='mvbutils')
  #install.packages(pkg='debug')
  #install.packages(pkg='atease')
  #install.packages(pkg='offarray')
  library('mvbutils')
  library('debug')
  library('atease')
  library('offarray')
  library('ids')
  
  source("./R/util_funcs.R")  #more functions from Mark
  source("c:/users/paul.conn/git/fishsim/fishsim/R/fishSim_dev.R")
  
  
  #bearded seal hazard rate pars for RAW model (from Trukhanova at al.)
  haz.mult = exp(-0.19)  #proportional hazards multiplier for bearded seals
  haz.mult = exp(0.26)  # alternative value to give lambda close to 1.0
  a.haz = 0.0541
  b.haz = 1.609 + 1.0  # bounded below by 1.0
  c.haz = -(log(0.97)-0.00513)  #including harvest mortality of 0.03 here
  phi_RAW = function(a.haz,b.haz,c.haz,haz.mult,Age){
    exp(-haz.mult*((a.haz*Age)^b.haz + (a.haz*Age)^(1/b.haz) + c.haz - (a.haz*(Age-1))^b.haz - (a.haz*(Age-1))^(1/b.haz) ))
  }
  
  Seal_life_hist = read.csv("c:/users/paul.conn/git/ckmr/sim_inputs.csv",header=T)[1:38,]
  
  #now simulated seal population 
  ages <- (min(Seal_life_hist$Age):max(Seal_life_hist$Age))+1  #we'll start age at 1
  n.ages= max(ages)-min(ages)+1
  ageSurv <- survCurv <- phi_RAW(a.haz,b.haz,c.haz,haz.mult,c(1:38))
  ageMort <- 1-ageSurv
  ageMort = c(0,ageMort[-length(ageMort)])  #Shane has a prebreeding census; trick it into a postbreeding one
  #S.female=Seal_life_hist$S.female*(1-Seal_life_hist$Harv)
  for(iage in 2:n.ages)survCurv[iage]=survCurv[iage-1]*ageSurv[iage]
  stocks <- rep(1/n.stocks,n.stocks)  # number of 'stocks' (spatial strata)
  library(sp)
  library(rgeos)
  Locations = SpatialPoints(cbind(rep(c(1:sqrt(n.stocks)),each=sqrt(n.stocks)),rep(c(sqrt(n.stocks):1),sqrt(n.stocks))))
  Distances = gDistance(Locations,byid=TRUE) #formulate distance matrix, assuming stocks are numbered from top to bottom
  kernel.sd = 1
  Transition = matrix(dnorm(as.numeric(Distances),0,kernel.sd),n.stocks,n.stocks)  #assuming normal kernel; exponential might be more appropriate
  Transition = Transition /rowSums(Transition)
  
  Stable.age = c(1,survCurv)
  Stable.age=Stable.age[-length(Stable.age)]
  Stable.age=Stable.age/sum(Stable.age)
  Mat.male = c(0,Seal_life_hist[1:37,"Mat.male"])  #add a zero because of delayed implantation
  Mat.fem = c(0,Seal_life_hist[1:37,"Mat.fem"]) #add a zero because of delayed implantation
  #Mat.male = c(0,rep(0.5,37))
  #Mat.fem = c(0,rep(0.54,37)) #
  
  #age.first.repro = 7
  Leslie = matrix(0,n.ages,n.ages)
  #Leslie[1,(age.first.repro+1):n.ages]=0.5*ageSurv[(age.first.repro+1):n.ages]  #postbreeding census so need to factor in adult survival to fecundity; 0.5 is for female pups / mature mom
  Leslie[1,]=0.5*Mat.fem*ageSurv
  index1=c(2:n.ages)
  index2=c(1:(n.ages-1))
  for(i in 1:(n.ages-1))Leslie[index1[i],index2[i]]=ageSurv[i]
  eigen(Leslie)$values[1]
  
  Stable.age = eigen(Leslie)$vectors[,1]
  Stable.age = as.numeric(Stable.age/sum(Stable.age))
  
  A.list = vector("list",n.ages)
  for(i in 1:n.ages)A.list[[i]]=diag(n.stocks)
  if(dispersal.type=="all.ages"){
    for(i in 1:n.ages)A.list[[i]]=Transition
    Move = list(F=A.list,M=A.list)  #This holds movement matrices for each sex and age
  }
  if(dispersal.type=="juvenile")A.list[[1]]=Transition
  if(dispersal.type=="random"){
    for(i in 1:n.ages)A.list[[i]]=0*A.list[[i]]+1/n.stocks  #complete mixing
  }
  Move = list(F=A.list,M=A.list)  #This holds movement matrices for each sex and age
  
  archive <- make_archive()
  indiv <- makeFounders(pop = init.N, osr = c(0.5, 0.5),stocks=stocks,maxAge=n.ages,survCurv=Stable.age)
  nyrs = 60
  # population processes and archiving
  firstBreed=3 #just used to calc summary
  N_yas = N_yas_breed = array(0,dim=c(nyrs,n.ages,2))
  for(k in 1:nyrs) {
    Age.sum.F = tabulate(as.numeric(indiv[indiv[,2]=="F",8]))
    Age.sum.M = tabulate(as.numeric(indiv[indiv[,2]=="M",8]))
    if(length(Age.sum.F)<39)N_yas[k,1:length(Age.sum.F),1]=Age.sum.F
    else N_yas[k,1:38,1]=Age.sum.F[1:38]
    if(length(Age.sum.M)<39)N_yas[k,1:length(Age.sum.M),2]=Age.sum.M
    else N_yas[k,1:38,2]=Age.sum.M[1:38]
    indiv <- mort(indiv = indiv, type = "age", ageMort = ageMort, year = k,maxAge=n.ages)
    archive <- archive_dead(indiv = indiv, archive = archive)
    indiv <- remove_dead(indiv = indiv)
    indiv <- move_as(indiv = indiv, Move = Move)
    #Age.sum.F = tabulate(as.numeric(indiv[indiv[,2]=="F" & is.na(indiv[,6])==TRUE,8]))
    #Age.sum.M = tabulate(as.numeric(indiv[indiv[,2]=="M" & is.na(indiv[,6])==TRUE,8]))
    #N_yas_breed[k,1:length(Age.sum.F),1]=Age.sum.F 
    #N_yas_breed[k,1:length(Age.sum.M),2]=Age.sum.M
     
    indiv <- altMate(indiv = indiv, type='ageSex',maleCurve=Mat.male,femaleCurve=Mat.fem,osr = c(0.5,0.5),batchSize=.001, year = k)
    indiv <- birthdays(indiv = indiv)
  }
  #don't archive living or recruits (which will actually recruit in year nyrs+1)
  # archiving the living; sim close
  #indiv[,6] <- c(rep("alive", nrow(indiv)))
  #archive <- archive_dead(indiv = indiv, archive = archive)
  # correct birth year; birth year recorded in altMate in year k of loop, but those animals really recruit in year k+1
  archive[,5] = as.character(as.numeric(archive[,5])+1)
  #write.csv(archive,file='c:/users/paul.conn/git/CKMR/sim_archive.csv',row.names=FALSE)
  
  
  #reformat for use with C++ estimation code
  #all_bs <- read.csv('c:/users/paul.conn/git/CKMR/sim_archive.csv')
  all_bs = data.frame(archive,stringsAsFactors=FALSE)
  names( all_bs) <- cq( ID, SEX, DAD, MUM, BY, DY, STOCK, DA)
  all_bs$BY = as.numeric(all_bs$BY)
  all_bs$DY = as.numeric(all_bs$DY)
  all_bs$STOCK = as.numeric(all_bs$STOCK)
  all_bs$DA = as.numeric(all_bs$DA)
  
  if(sum(all_bs$DA>n.ages)>0){
    all_bs = all_bs[-which(all_bs$DA>n.ages),]
  }
  all_bs = all_bs[-which(all_bs$BY<1),]  #zap founders
  # DA is Death-Age; BY is Birth-Year; DY is Death-Year
  

  
  
  #all_bs$DY <- as.integer( all_bs$DY) # convert "alive" to NA   #this was messed up...DY wrong because it gives the factor level which is unordered!!
  all_bs$DY <- as.integer( as.character(all_bs$DY)) # convert "alive" to NA
  
  source('c:/users/paul.conn/git/CKMR/R/sim_funcs_Mark.R')
  bs2 <- read_seal_sim( all_bs=all_bs)
  
  # 20 years of sampling--- from last 20 years of simulation
  # Sample from among those animals which died that year
  #fmatat=bs2@fmatat 
  #fmatat=bs2$fmatat
  first_y_sample = 41
  #bsamps<- sample_seal_sim( bs2, first_y=31, last_y=50, samp_size=100)
  #bsamps<- sample_seal_sim2( bs2, first_y=first_y_sample, last_y=50, samp_size=c(3,6,35,77,59,88,50,82,102,102,74,154,148,151,124,116,91,135))
  strata_probs = rep(0,100)
  if(exp.type=="extreme.gradient"){
    strata_probs[91:100]=0.3
    strata_probs[81:90]=0.2
    strata_probs[71:80]=0.1
  }
  if(exp.type=="moderate.gradient"){
    for(i in 1:10){
      strata_probs[10*(i-1)+c(1:10)]=(i-1)*2/90+.2
    }
  }
  if(exp.type=="constant")strata_probs = rep(0.01,100)
  bsamps<- sample_seal_sim2( bs2, first_y=first_y_sample, last_y=60, samp_size=rep(100,20),strata_probs=strata_probs)
  
  get_m_data <- function(samps,nyrs,n.ages){
    m_tas = array(0,dim=c(nyrs,n.ages,2))
    for(isamp in 1:nrow(samps)){
      m_tas[samps[isamp,"DY"],samps[isamp,"DA"],1+1*(samps[isamp,"SEX"]=="M")]=m_tas[samps[isamp,"DY"],samps[isamp,"DA"],1+1*(samps[isamp,"SEX"]=="M")]+1
    }
    m_tas
  }
  m_tas = get_m_data(bsamps$samps,60,n.ages)
  
  sim_data=bsamps
  
  #sim_data = Out
  first_y = 1
  last_y= max(sim_data$samps$DY)
  m_tas = m_tas[first_y_sample:last_y,,]
  
  return(list(m_tas=m_tas,sim_data=sim_data,N_yas=N_yas))
}