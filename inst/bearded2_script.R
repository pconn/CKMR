#fit_bd_sim.R
setwd("c:/users/paul.conn/git/CKMR")
load("fitbits.RDa")
setwd("c:/users/paul.conn/git/CKMR/")
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

#make sure to do Debug > attach to process (rsession) in VS .cpp
Cenv = load_ADT_DLL(folder='c:/users/paul.conn/git/CKMR/bearded2/x64/debug')

set.seed(11113)

Seal_life_hist = read.csv("c:/users/paul.conn/git/ckmr/sim_inputs.csv",header=T)[1:38,]

#now simulated seal population 
ages <- (min(Seal_life_hist$Age):max(Seal_life_hist$Age))+1  #we'll start age at 1
n.ages= max(ages)-min(ages)+1
ageSurv <- survCurv <- Seal_life_hist$S.male *(1-Seal_life_hist$Harv)
ageMort <- 1-ageSurv
ageMort = c(0,ageMort[-length(ageMort)])  #Shane has a prebreeding census; trick it into a postbreeding one
#S.female=Seal_life_hist$S.female*(1-Seal_life_hist$Harv)
for(iage in 2:n.ages)survCurv[iage]=survCurv[iage-1]*ageSurv[iage]
stocks <- c(1)  #this is proportion in each stock but here we just have 1
admix.m <- matrix(NA, nrow = length(stocks), ncol = length(stocks))
for (i in 1:nrow(admix.m)) {
    admix.m[i,] <- stocks*stocks[i]
}
#Stable.age = c(1,survCurv)
#Stable.age=Stable.age[-length(Stable.age)]
#Stable.age=Stable.age/sum(Stable.age)

age.first.repro = 6
Leslie = matrix(0,n.ages,n.ages)
Leslie[1,(age.first.repro+1):n.ages]=0.5*ageSurv[(age.first.repro+1):n.ages]  #postbreeding census so need to factor in adult survival to fecundity; 0.5 is for female pups / mature mom
index1=c(2:n.ages)
index2=c(1:(n.ages-1))
for(i in 1:(n.ages-1))Leslie[index1[i],index2[i]]=ageSurv[i]
eigen(Leslie)$values[1]

Stable.age = eigen(Leslie)$vectors[,1]
Stable.age = as.numeric(Stable.age/sum(Stable.age))

archive <- make_archive()
indiv <- makeFounders(pop = 5000, osr = c(0.5, 0.5),stocks=1,maxAge=n.ages,survCurv=Stable.age)
nyrs = 50
# 2) population processes and archiving
firstBreed=6
Alive = Alive.breed.F = Alive.breed.M = rep(0,nyrs)
for(k in 1:nyrs) {
    Alive[k]=sum(as.numeric(indiv[,8])>firstBreed)
    indiv <- move(indiv = indiv, moveMat = admix.m)
    indiv <- mort(indiv = indiv, type = "age", ageMort = ageMort, year = k)
    archive <- archive_dead(indiv = indiv, archive = archive)
    indiv <- remove_dead(indiv = indiv)
    n.breeders.F = sum(indiv[,2]=="F" & as.numeric(indiv[,8])>firstBreed)
    Alive.breed.F[k]=n.breeders.F
    Alive.breed.M[k]=sum(indiv[,2]=="M" & as.numeric(indiv[,8])>firstBreed)
    indiv <- mate(indiv = indiv, fecundity=n.breeders.F/nrow(indiv),osr = c(0.5,0.5), firstBreed=firstBreed, exhaustMothers=TRUE,batchSize=.001, year = k)
    indiv <- birthdays(indiv = indiv)
}

# 3) archiving the living; sim close
indiv[,6] <- c(rep("alive", nrow(indiv)))
archive <- archive_dead(indiv = indiv, archive = archive)
write.csv(archive,file='c:/users/paul.conn/git/CKMR/seal_archive.csv',row.names=FALSE)

#reformat for use with C++ estimation code
all_bs <- read.csv( 'c:/users/paul.conn/git/CKMR/seal_archive.csv',stringsAsFactors=FALSE)
names( all_bs) <- cq( ID, SEX, DAD, MUM, BY, DY, STOCK, DA)
# DA is Death-Age; BY is Birth-Year; DY is Death-Year
all_bs$DY <- as.integer( all_bs$DY) # convert "alive" to NA


# 20 years of sampling--- from last 20 years of simulation
# Sample from among those animals which died that year
set.seed(1111)
seal_sample <- local({ # to avoid polluting workspace
  # First, remove all founders. Won't be many living by end of sim, anyway
  most_bs <- all_bs %where% (BY>0) # founders are born in year "-1"--- zap them
  
  first_y <- 31
  last_y <- 50
  #samp_size <- offarray( (1:10)*20, first=first_y, last=last_y)
  samp_size <- offarray(200,first=first_y,last=last_y)
  n_samps <- sum( samp_size)
  
  # "Empty" data.frame of correct size
  samps <- most_bs[ rep( 1, n_samps),]
  
  last_samp_row <- 0
  for( iy in first_y:last_y) {
    die_now <- which( most_bs$DY == iy)
    probs_now <- rep(1,length(die_now))
    #probs_now[which(most_bs[die_now,"DA"]==1)]=0  #don't harvest / genotype young-of-year
    samp_now <- sample(  die_now, samp_size[ iy],replace=FALSE,prob=probs_now)
    
    new_samp_rows <- last_samp_row + (1:samp_size[iy])
    samps[ new_samp_rows,] <- most_bs[ samp_now,]
    last_samp_row <- tail( new_samp_rows, 1)
  }
  
  counter = 1
  isamp_POP = jsamp_POP = rep(0,10000)
  for(isamp in 1:n_samps){
    which_mom = which(samps$MUM == samps[isamp,"ID"])
    if(length(which_mom)>0){
      isamp_POP[counter:(counter+length(which_mom)-1)]=isamp
      jsamp_POP[counter:(counter+length(which_mom)-1)]=which_mom
      counter = counter + length(which_mom)
    }
    which_dad = which(samps$DAD == samps[isamp,"ID"])
    if(length(which_dad)>0){
      isamp_POP[counter:(counter+length(which_dad)-1)]=isamp
      jsamp_POP[counter:(counter+length(which_dad)-1)]=which_dad
      counter = counter + length(which_dad)
    }
  }
  isamp_POP = isamp_POP[1:(counter-1)]
  jsamp_POP = jsamp_POP[1:(counter-1)]
  
  
  #mum_rows <- match( samps$ID, samps$MUM, 0)
  #dad_rows <- match( samps$ID, samps$DAD, 0)
  
  #isamp_POP <- c(mum_rows[ mum_rows>0],dad_rows[dad_rows>0])
  #jsamp_POP <- c(which( mum_rows>0),which(dad_rows>0))
  
  samps <- samps[ cq( ID, SEX, DY, DA)]
  # samps$DY is "tcap"
  # samps$DA is "a"
  return( returnList( samps, isamp_POP, jsamp_POP))
})

#alternate simulated data adapted from beluga code
# load("Sim_bearded_simple2.RData")

#par_start = c(as.numeric(log(eigen(Leslie)$values[1])),log(Alive[1]))  
par_start = c(as.numeric(log(eigen(Leslie)$values[1])),log(5000),log(5000))  


#fit_bd_sim <-function(Cenv,sim_data,par_start){
    
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
  save(seal_sample,file="seal_sample.RData")
  sim_data=seal_sample
  #sim_data = Out
  first_y = 1
  first_y_sample = min(sim_data$samps$DY)
  last_y= max(sim_data$samps$DY)
  n_par = 3
  n_samp = nrow(sim_data$samps)
  n_POP = length(sim_data$isamp_POP)
  amat = 6  #definitely need to generalize this; age at maturity is age at maturity here (note it was amat+1 for sims)
  tcap = sim_data$samps$DY
  a = sim_data$samps$DA
  sex = rep(0,n_samp) 
  sex[sim_data$samps$SEX=="M"]=1
  isamp_POP = sim_data$isamp_POP
  jsamp_POP = sim_data$jsamp_POP
  
  ck <- Cenv$create()  #R objects that match C code must be defined above
  
  Cenv$make_data_summaries( ck) # classic pattern for calls to C code-- ck will be 1st arg
  

  # much much later
  res1 <- Cenv$lglk( ck, par_start)
  grad1 = Cenv$Dlglk(ck,par_start)
  
  fitme <- nlminb( par_start, NEG( Cenv$lglk), NEG( Cenv$Dlglk), Context=ck, control=list( trace=6))
  H <- numderiv( Cenv$Dlglk, fitme$par, Context=ck)
  
  stuff <- list( lglk=Cenv$lglk( ck, fitme$par),par=fitme$par,Sigma=-solve(H)) # also ensures all internal stuff is set right
  #return(stuff)  
#}


#mtrace(fit_bd_sim)
#fit_bd_sim(Cenv=Cenv_tmp,sim_data=Simple,par_start=par_start)

#fit = fit_bd_sim(Cenv=Cenv_tmp,sim_data=seal_sample,par_start=par_start)
fit=stuff
exp(fit$par)
#
exp(fit$par[1]-1.96*sqrt(fit$Sigma[1]))
exp(fit$par[1]+1.96*sqrt(fit$Sigma[1]))
cv=sqrt(fit$Sigma[2,2])/fit$par[2]
C=exp(1.96*sqrt(log(1+cv^2)))
#log-based CIs
exp(fit$par[2])/C
exp(fit$par[2])*C
#

getc = function(x)eval(parse(text=paste0("Cenv$get.",x,"(ck)")))



N_y = getc("N_ys")
plot(Alive.breed.F[30:50],ylim=c(1000,3000))
plot.n = as.numeric(N_y[30:50,0])
lines(plot.n)

#### Debugging stuff
res1 <- Cenv$lglk( ck, par_start)

n_comps=getc("n_comps_ytbsm")
N_y = getc("N_ys")

#Probs = Cenv$get.Pr_PO_ytb(ck)
Pr_PO = getc("Pr_PO_ytbs")
#RP = P$P_Father
EPO.2 = apply(Pr_PO,2,'sum')
EPO.1 = apply(Pr_PO,1,'sum')
EPO.3 = apply(Pr_PO,3,'sum')
Obs = n_comps[,,,1,1]/(n_comps[,,,1,1]+n_comps[,,,1,0])
OPO.2 = apply(Obs,2,'mean',na.rm=TRUE)
OPO.1 = apply(Obs,1,'mean',na.rm=TRUE)
OPO.3 = apply(Obs,3,'mean',na.rm=TRUE)

par(mfrow=c(1,1))
plot(OPO.2[31:50]/mean(OPO.2[31:50]),xlab="year",main="PO by parent death year",ylab='standardized value')
lines(EPO.2[31:50]/mean(EPO.2[31:50]))

Tmp = OPO.1/mean(OPO.1,na.rm=TRUE)
which.na = which(is.na(Tmp))
x.orig = c(1:50)
plot(x.orig[-which.na],Tmp[-which.na],xlab="year",main="PO by parent birth year",ylab='standardized value',xlim=c(1,50))
lines(EPO.1/mean(EPO.1))

Tmp = OPO.3/mean(OPO.3,na.rm=TRUE)
which.na = which(is.na(Tmp))
x.orig = c(1:50)
plot(x.orig[-which.na],Tmp[-which.na],xlab="year",main="PO by offspring birth year",ylab='standardized value',xlim=c(1,50))
lines(EPO.3/mean(EPO.3))




new_rcomps = array(0,dim=c(60,60,60))
for(i in 1:nrow(Data_dad_no)){
  new_rcomps[Data_dad_no[i,1],Data_dad_no[i,2],Data_dad_no[i,3]]=new_rcomps[Data_dad_no[i,1],Data_dad_no[i,2],Data_dad_no[i,3]]+Data_dad_no[i,4]
}

new_ccomps = array(n_comps[,,,0,1],dim=c(60,60,60))
new_cp = array(Pr_PO[,,,0],dim=c(60,60,60))
cgt0 = which(new_ccomps>0)
rgt0 = which(new_rcomps>0)

#to compare ncomps, restrict to cases where p>0
rpgt0 = which(RP>0)
cpgt0 = which(new_cp>0)

np_r_gt0 = RP*new_rcomps
np_c_gt0 = new_cp * new_ccomps

unique(as.numeric(RP-new_cp))
unique(as.numeric(np_r_gt0-np_c_gt0))
which(np_r_gt0 != np_c_gt0)

#Which.extra = which(!(rpct0 %in% cpgt0))
Tmp.index = matrix(0,60*60*60,3)
counter = 1
for(k in 1:60){
  for(j in 1:60){
    for(i in 1:60){
      Tmp.index[counter,]=c(i,j,k)
      counter = counter + 1
    }
  }
}

Tmp.index2 = matrix(0,60*60,2)
counter = 1
for(k in 1:60){
  for(j in 1:60){
      Tmp.index2[counter,]=c(j,k)
      counter = counter + 1
    }
}

#cur.which = which(((Pr_PO ==0) * (n_comps[,,,,1])>0)>0,arr.ind=TRUE)

#emp <- numderiv( Cenv$lglk, par_start, Context=ck, eps=1e-3)
#ana <- Cenv$Dlglk( ck, par_start)






