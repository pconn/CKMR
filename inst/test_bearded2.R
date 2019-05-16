# debug bearded seal estimation model by analyzing w/ data simulated directly from expectations


set.seed(1234)
n.sims = 1000
n.yrs=n_yrs = 60  #note this is hardwired into sim functions
first_y_sample = 41

setwd("c:/users/paul.conn/git/CKMR")
load("fitbits.RDa")
library('mvbutils')
library('debug')
library('atease')
library('offarray')
library('ids')
source("./R/util_funcs.R")  #more functions from Mark


Cenv = load_ADT_DLL(folder='c:/users/paul.conn/git/CKMR/Bearded2/x64/debug')
getc = function(x)eval(parse(text=paste0("Cenv$get.",x,"(ck)")))


#Survival stuff
haz.mult = exp(-0.19)  #proportional hazards multiplier for bearded seals
haz.mult = exp(0.26)  # alternative value to give lambda close to 1.0
a.haz = 0.0541
b.haz = 1.609 + 1.0  # bounded below by 1.0
c.haz = -(log(0.97)-0.00513)  #including harvest mortality of 0.03 here
a_mean = a.haz
b_mean = b.haz
c_mean = c.haz
wt_a = 1000000
wt_b = 1000000
wt_c = 1000000
haz_mult=haz.mult
phi_RAW = function(a.haz,b.haz,c.haz,haz.mult,Age){
  exp(-haz.mult*((a.haz*Age)^b.haz + (a.haz*Age)^(1/b.haz) + c.haz - (a.haz*(Age-1))^b.haz - (a.haz*(Age-1))^(1/b.haz) ))
}

Seal_life_hist = read.csv("c:/users/paul.conn/git/ckmr/sim_inputs.csv",header=T)[1:38,]
#Seal_life_hist[6:38,"S.male"]=Seal_life_hist[6:38,"S.fem"]=0.9  # we'll simplify half sibs by having constant adult survival
#now simulated seal population 
ages <- (min(Seal_life_hist$Age):max(Seal_life_hist$Age))+1  #we'll start age at 1
n.ages=n_ages= max(ages)-min(ages)+1
Mat.male = c(0,Seal_life_hist[1:37,"Mat.male"])  #add a zero because of delayed implantation
Mat.fem = c(0,Seal_life_hist[1:37,"Mat.fem"]) #add a zero because of delayed implantation
Fec_as = matrix(0,n_ages,2)
Fec_as[,1] = 0.5*Mat.fem
Fec_as[,2] = 0.5*Mat.male
#Fec_as[2:n_ages,1]=0.5*Mat.fem[1:(n_ages-1)]
#Fec_as[2:n_ages,2]=0.5*Mat.male[1:(n_ages-1)]

n.stocks = 100 #make sure square
library(sp)
library(rgeos)
Locations = SpatialPoints(cbind(rep(c(1:sqrt(n.stocks)),each=sqrt(n.stocks)),rep(c(sqrt(n.stocks):1),sqrt(n.stocks))))
Distances = gDistance(Locations,byid=TRUE) #formulate distance matrix, assuming stocks are numbered from top to bottom

n_ages = n.ages

par_start = c(log(945),log(a.haz),log(b.haz-1),log(c.haz)) 


### expected value "data" 

#now simulated seal population 
ages <- (min(Seal_life_hist$Age):max(Seal_life_hist$Age))+1  #we'll start age at 1
n.ages= max(ages)-min(ages)+1
ageSurv <- survCurv <- phi_RAW(a.haz,b.haz,c.haz,haz.mult,c(1:38))
ageMort <- 1-ageSurv
ageMort = c(0,ageMort[-length(ageMort)])  #Shane has a prebreeding census; trick it into a postbreeding one
#S.female=Seal_life_hist$S.female*(1-Seal_life_hist$Harv)
for(iage in 2:n.ages)survCurv[iage]=survCurv[iage-1]*ageSurv[iage]
n.stocks = 100 #make sure square
stocks <- rep(0.01,n.stocks)  # number of 'stocks' (spatial strata)
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

#age.first.repro = 7
Leslie = matrix(0,n.ages,n.ages)
#Leslie[1,(age.first.repro+1):n.ages]=0.5*ageSurv[(age.first.repro+1):n.ages]  #postbreeding census so need to factor in adult survival to fecundity; 0.5 is for female pups / mature mom
Leslie[1,]=0.5*Mat.fem*ageSurv
index1=c(2:n.ages)
index2=c(1:(n.ages-1))
for(i in 1:(n.ages-1))Leslie[index1[i],index2[i]]=ageSurv[i]
#eigen(Leslie)$values[1]

Stable.age = eigen(Leslie)$vectors[,1]
Stable.age = as.numeric(Stable.age/sum(Stable.age))

N = N_breed = array(0,dim = c(n.yrs,n.ages,2))
N[1,,1] = N[1,,2] = Stable.age * 5000
N_breed[1,,1]=N_breed[1,,2]=N[1,,1]*ageSurv
for(i in 2:n.yrs){
  N[i,,1]=N[i,,2] = Leslie %*% N[i-1,,1]
  N_breed[i,,1] = N_breed[i,,2] = N[i,,1]*ageSurv
}

Mat = rbind(Mat.fem, Mat.male)
Pr_match = array(0,dim=c(n.yrs,n.ages,2))
for(iyr in 1:n.yrs){
  for(isex in 1:2){
    Pr_match[iyr,,isex] = Mat[isex,]/as.numeric(N_breed[iyr,,isex]%*%Mat[isex,]) #note this is in by of young
  }
}


Pr_match_ytbs = array(0,dim=c(n.yrs,n.yrs,n.yrs,2))

n_each = 1
m_tas = array(n_each,dim=c(20,38,2))
n_samp = 20*38*2*n_each
sex = a = tcap = rep(0,20*38*2*n_each)
ientry = 0
for(isex in 1:2){
  for(it in first_y_sample:n.yrs){
    for(iage in 1:38){
      for(isamp in 1:n_each){
        ientry = ientry+1
        sex[ientry]=isex
        a[ientry]=iage
        tcap[ientry]=it
      }
    }
  }
}
by = tcap-a+1

isamp = jsamp = NA
for(is in 1:(n_samp-1)){
  for(js in (is+1):n_samp){
    by1 = tcap[is]-a[is]+1
    by2 = tcap[js]-a[js]+1
    if(by1<by2 & (by2-by1+1)<39 & by1>0 & tcap[is]>by2){   #case 1: i is parent
      if(runif(1)<Pr_match[by2,by2-by1+1,sex[is]]){
        isamp = c(isamp,js)
        jsamp = c(jsamp,is)
      }
    }
    if(by2<by1 & (by1-by2+1)<39 & by2>0 & tcap[js]>by1){  #case 2: j is parent
      if(runif(1)<Pr_match[by1,by1-by2+1,sex[js]]){
        isamp = c(isamp,is)
        jsamp = c(jsamp,js)
      }
    }
  }
}
isamp = isamp[-1]
jsamp = jsamp[-1]
sex = sex-1  #0,1 in C++

first_y = 1
last_y= 60

n_par = 4

#calc n_match_ytbs to compare to C++
n_match_ytbs = array(0,dim=c(60,60,60,2))
for(i in 1:length(isamp)){
  n_match_ytbs[by[jsamp[i]],tcap[jsamp[i]],by[isamp[i]],sex[jsamp[i]]+1]=
    n_match_ytbs[by[jsamp[i]],tcap[jsamp[i]],by[isamp[i]],sex[jsamp[i]]+1]+1
}

#calc n_comps_ytbs to compare to C++  - this isn't right; # depends on potential offspring captured after first_y_sample
# n_comps_ytbs = array(0,dim=c(60,60,60,2))
# for(isex in 1:2){
#   for(it in first_y_sample:last_y){
#     for(iy in 1:(last_y-1){
#       for(ib in (iy+1):last_y){
#         if(it)
#         n_comps_ytbs[iy,it,ib,is]= 100
#       }
#     }
#   }
# }



#things not really needed right now but required by C++
n_samp = sum(m_tas)
n_HS = 5
n_POP = length(isamp)
amat = 1
isamp_POP = isamp
jsamp_POP = jsamp
isamp_HS = jsamp_HS = rep(1,n_HS)
sex_HS = rep(0,n_HS)

save.image(file="tmp.RData")
#n_samp = nrow(curd$sim_data$samps)
#n_POP = length(curd$sim_data$isamp_POP)
#amat = 3  #age at maturity is used to calculate number of comparisons: don't bother with ages for which parent is immature
#tcap = curd$sim_data$samps$DY
#a = curd$sim_data$samps$DA
#sex = rep(0,n_samp) 
#sex[curd$sim_data$samps$SEX=="M"]=1
#isamp_POP = curd$sim_data$isamp_POP
#jsamp_POP = curd$sim_data$jsamp_POP
#isamp_HS = c(curd$sim_data$isamp_MHSP,curd$sim_data$isamp_PHSP)
#jsamp_HS = c(curd$sim_data$jsamp_MHSP,curd$sim_data$jsamp_PHSP)
#sex_HS = c(rep(0,length(curd$sim_data$isamp_MHSP)),rep(1,length(curd$sim_data$isamp_PHSP)))
#n_HS=length(isamp_HS)

#m_tas = curd$m_tas
ck <- Cenv$create()  #R objects that match C code must be defined above

Cenv$make_data_summaries( ck) # classic pattern for calls to C code-- ck will be 1st arg


# much much later

res1 <- Cenv$lglk( ck, par_start)
grad1 = Cenv$Dlglk(ck,par_start)

fitme <- nlminb( par_start, NEG( Cenv$lglk), NEG( Cenv$Dlglk), Context=ck, control=list( trace=6,eval.max=1000,iter.max=750))
H <- numderiv( Cenv$Dlglk, fitme$par, Context=ck)

stuff <- list( lglk=Cenv$lglk( ck, fitme$par),par=fitme$par,Sigma=-solve(H)) # also ensures all internal stuff is set right

cat(paste('expected R0: ',945))
cat(paste('estimated R0: ',exp(fitme$par[1])))
#S2 = phi_RAW(exp(fitme$par[2]),exp(fitme$par[3])+1,exp(fitme$par[4]),haz.mult=haz.mult,Age=c(1:38))
#plot(S2)
#lines(ageSurv)  
N_y = getc("N_yas_breed")
plot(apply(N_breed[40:60,3:38,],1,'sum'),ylim = c(0,9500)) 
plot.n = apply(N_y[40:60,3:38,],1,'sum')
lines(plot.n)

# sex specific
# plot(apply(curd$N_yas_breed[30:50,3:38,1],1,'sum'),ylim = c(0,9500)) 
# plot.n = apply(N_y[30:50,3:38,1],1,'sum')
# lines(plot.n)
# 
# plot(apply(curd$N_yas_breed[30:50,3:38,2],1,'sum'),ylim = c(0,9500)) 
# plot.n = apply(N_y[30:50,3:38,2],1,'sum')
# lines(plot.n)  


fit=stuff
exp(fit$par[1]-1.96*sqrt(fit$Sigma[1]))
exp(fit$par[1]+1.96*sqrt(fit$Sigma[1]))

getN <- function( params) {
  Cenv$lglk( ck, params) # which sets up n_t and loads of other stuff
  N_yas <- getc("N_yas_breed")
  N_mat <- N_yas[,3:n_ages,]
  return( as.vector(apply(N_mat,1,'sum')))
}
library(numDeriv)
dNdpar <- numderiv( getN, fitme$par)
varN = dNdpar %**% solve( -H) %**% t(dNdpar)
sqrt(diag(varN))

phi_RAW = function(a.haz,b.haz,c.haz,haz.mult,Age){
  exp(-haz.mult*((a.haz*Age)^b.haz + (a.haz*Age)^(1/b.haz) + c.haz - (a.haz*(Age-1))^b.haz - (a.haz*(Age-1))^(1/b.haz) ))
}
haz.mult = exp(0.26)  # alternative value to give lambda close to 1.0
a.haz = 0.0541
b.haz = 1.609 + 1.0  # bounded below by 1.0
c.haz = -(log(0.97)-0.00513)  #including harvest mortality of 0.03 here
ageSurv <- phi_RAW(a.haz,b.haz,c.haz,haz.mult,c(1:38))

S2 = phi_RAW(exp(fitme$par[2]),exp(fitme$par[3])+1,exp(fitme$par[4]),haz.mult=haz.mult,Age=c(1:38))
plot(S2)
lines(ageSurv)
S3 = phi_RAW(exp(par_start[2]),exp(par_start[3])+1,exp(par_start[4]),haz.mult=haz.mult,Age=c(1:38))
lines(S3,lty=2)

n_comps_ytbs = getc("n_comps_ytbs")
n_match = getc("n_match_ytbs")
exp_match = getc("exp_match_ytbs")
Pr_PO=getc("Pr_PO_ytbs")

which(n_match != n_match_ytbs,arr.ind=TRUE)[1:5,]
which(n_match>0 & n_comps_ytbs==0,arr.ind=TRUE)

which.gt.0 = which(exp_match>0)
summary(as.numeric((n_match-exp_match)/exp_match)[which.gt.0])
resid = (n_match-exp_match)/exp_match
arr.index = which(resid>0,arr.ind=TRUE)
resid.num = as.numeric(resid)
resid2 = resid.num[which(resid.num>0)]
summary(lm(resid2~arr.index[,1]))
summary(lm(resid2~arr.index[,2]))
summary(lm(resid2~arr.index[,3]))
summary(lm(resid2~arr.index[,4]))
#trends here don't necessarily mean anything.  There are fewer comparisons for earlier birthed animals simply because there aren't that
#many old animals sampled


#look at difference in birth year among half-sibs
summary((curd$sim_data$samps[curd$sim_data$isamp_PHSP,"DY"]-curd$sim_data$samps[curd$sim_data$isamp_PHSP,"DA"])-(curd$sim_data$samps[curd$sim_data$jsamp_PHSP,"DY"]-curd$sim_data$samps[curd$sim_data$jsamp_PHSP,"DA"]))
summary((curd$sim_data$samps[curd$sim_data$isamp_MHSP,"DY"]-curd$sim_data$samps[curd$sim_data$isamp_MHSP,"DA"])-(curd$sim_data$samps[curd$sim_data$jsamp_MHSP,"DY"]-curd$sim_data$samps[curd$sim_data$jsamp_MHSP,"DA"]))

#look at num matches, Pr_PO, n_comps
