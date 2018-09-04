load("fitbits.RDa")

library('ids')
#library('rsample')

library('mvbutils')
#library('atease')
library('offarray')
library('debug')
library('ids')


set.seed(11112)

#source( 'd:/rpackages/sources/fishSim-master/fishSim/R/fishSim_dev.R')
source("c:/users/paul.conn/git/fishsim/fishsim/R/fishSim_dev.R")
source("c:/users/paul.conn/git/CKMR/R/sim_funcs_Mark.R")

Seal_life_hist <- read.csv( "sim_inputs.csv",header=T)[1:38,]

#now simulated seal population
ages <- (min(Seal_life_hist$Age):max(Seal_life_hist$Age))+1  #we'll start age at 1
n.ages <- max(ages)-min(ages)+1
ageSurv <- survCurv <- Seal_life_hist$S.male *(1-Seal_life_hist$Harv)
ageMort <- 1-ageSurv
ageMort <- c(0,ageMort[-length(ageMort)])  #Shane has a prebreeding census; trick it into a postbreeding one
#S.female <- Seal_life_hist$S.female*(1-Seal_life_hist$Harv)
for(iage in 2:n.ages)survCurv[iage] <- survCurv[iage-1]*ageSurv[iage]
stocks <- c(1)  #this is proportion in each stock but here we just have 1
admix.m <- matrix(NA, nrow = length(stocks), ncol = length(stocks))
for (i in 1:nrow(admix.m)) {
  admix.m[i,] <- stocks*stocks[i]
}
#Stable.age <- c(1,survCurv)
#Stable.age <- Stable.age[-length(Stable.age)]
#Stable.age <- Stable.age/sum(Stable.age)

age.first.repro <- 6
Leslie <- matrix(0,n.ages,n.ages)
Leslie[1,(age.first.repro+1):n.ages] <- 0.5*ageSurv[(age.first.repro+1):n.ages]  #postbreeding census so need to factor in adult survival to fecundity; 0.5 is for female pups / mature mom
index1 <- c(2:n.ages)
index2 <- c(1:(n.ages-1))
for(i in 1:(n.ages-1))Leslie[index1[i],index2[i]] <- ageSurv[i]
eigen(Leslie)$values[1]

Stable.age <- eigen(Leslie)$vectors[,1]
Stable.age <- as.numeric(Stable.age/sum(Stable.age))

archive <- make_archive()
indiv <- makeFounders(pop = 1000, osr = c(0.5, 0.5),stocks=1,maxAge=n.ages,survCurv=Stable.age)
nyrs <- 80
# 2) population processes and archiving
firstBreed <- 6
Alive <- Alive.breed.F <- Alive.breed.M <- rep(0,nyrs)
for(k in 1:nyrs) {
  cat( k, '\r'); flush.console()
  Alive[k] <- sum(as.numeric(indiv[,8])>firstBreed)
  indiv <- move(indiv = indiv, moveMat = admix.m)
  indiv <- mort(indiv = indiv, type = "age", ageMort = ageMort, year = k)
  archive <- archive_dead(indiv = indiv, archive = archive)
  indiv <- remove_dead(indiv = indiv)
  n.breeders.F <- sum(indiv[,2]=="F" & as.numeric(indiv[,8])>firstBreed)
  Alive.breed.F[k] <- n.breeders.F
  Alive.breed.M[k] <- sum(indiv[,2]=="M" & as.numeric(indiv[,8])>firstBreed)
  indiv <- mate(indiv = indiv, fecundity=n.breeders.F/nrow(indiv),osr = c(0.5,0.5), firstBreed=firstBreed, exhaustMothers=TRUE,batchSize=.001, year = k)
  indiv <- birthdays(indiv = indiv)
}

# 3) archiving the living; sim close
indiv[,6] <- c(rep("alive", nrow(indiv)))
archive <- archive_dead(indiv = indiv, archive = archive)

# write.csv(archive,file = 'seal_archive_alive_too.csv',row.names=FALSE)

bs2 <- read_seal_sim( all_bs=archive)

# 20 years of sampling--- from last 20 years of simulation
# Sample from among those animals which died that year
fmatat=bs2@fmatat 
set.seed( 99)
bsamps <- sample_seal_sim( bs2, first_y=31, last_y=50, samp_size=100)
save( bsamps, file= "seal_sample.RData")

#alternate simulated data adapted from beluga code
# load("Sim_bearded_simple2.RData")

#make sure to do Debug > attach to process (rsession) in VS .cpp
#nv <- load_ADT_DLL( folder=file.path( 'Bearded2',
#                                        if( .Machine$sizeof.pointer ==4) 'Win32' else 'x64',
#                                        'debug'))
Cenv = load_ADT_DLL(folder='c:/users/paul.conn/git/CKMR/bearded2/x64/debug')


#par_start <- c(as.numeric(log(eigen(Leslie)$values[1])),log(Alive[1]))
par_start <- c(0,log(4000),log(5000))

mtrace( fit_bd2_sim)
fit_bd2_sim( Cenv = Cenv, sim_data=bsamps, par_start=par_start)

# Regen bsamps and try again... to be really systematic, check Dlglk at the "true" pars, except we don't know what they are...

if( FALSE) {
  #fit <- fit_bd_sim(Cenv=Cenv_tmp,sim_data=seal_sample,par_start=par_start)
  fit <- stuff
  exp(fit$par)
  #
  exp(fit$par[1]-1.96*sqrt(fit$Sigma[1]))
  exp(fit$par[1]+1.96*sqrt(fit$Sigma[1]))
  cv <- sqrt(fit$Sigma[2,2])/fit$par[2]
  C <- exp(1.96*sqrt(log(1+cv^2)))
  #log-based CIs
  exp(fit$par[2])/C
  exp(fit$par[2])*C
  #
  
  getc <- function(x)eval(parse(text=paste0("Cenv$get.",x,"(ck)")))
  
  #### Debugging stuff
  #res1 <- Cenv$lglk( ck, par_start)
  
  
  N_y <- getc("N_ys")
  n_comps <- getc("n_comps_ytbsm")
  #Probs <- Cenv$get.Pr_PO_ytb(ck)
  Pr_PO <- getc("Pr_PO_ytbs")
  RP <- P$P_Father
  
  plot(Alive.breed.F[30:50],ylim = c(1000,3000))
  lines(N_y[30:50,0])
  
  new_rcomps <- array(0,dim=c(60,60,60))
  for(i in 1:nrow(Data_dad_no)){
    new_rcomps[Data_dad_no[i,1],Data_dad_no[i,2],Data_dad_no[i,3]] <- new_rcomps[Data_dad_no[i,1],Data_dad_no[i,2],Data_dad_no[i,3]]+Data_dad_no[i,4]
  }
  
  new_ccomps <- array(n_comps[,,,1,0],dim=c(60,60,60))
  new_cp <- array(Pr_PO[,,,1],dim=c(60,60,60))
  cgt0 <- which(new_ccomps>0)
  rgt0 <- which(new_rcomps>0)
  
  #to compare ncomps, restrict to cases where p>0
  rpgt0 <- which(RP>0)
  cpgt0 <- which(new_cp>0)
  
  np_r_gt0 <- RP*new_rcomps
  np_c_gt0 <- new_cp * new_ccomps
  
  unique(as.numeric(RP-new_cp))
  unique(as.numeric(np_r_gt0-np_c_gt0))
  which(np_r_gt0 != np_c_gt0)
  
  #Which.extra <- which(!(rpct0 %in% cpgt0))
  Tmp.index <- matrix(0,60*60*60,3)
  counter <- 1
  for(k in 1:60){
    for(j in 1:60){
      for(i in 1:60){
        Tmp.index[counter,] <- c(i,j,k)
        counter <- counter + 1
      }
    }
  }
} # if FALSE
#cur.which <- which(((Pr_PO ==0) * (n_comps[,,,,1])>0)>0,arr.ind=TRUE)

#emp <- numderiv( Cenv$lglk, par_start, Context = ck, eps=1e-3)
#ana <- Cenv$Dlglk( ck, par_start)


