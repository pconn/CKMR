# expected n_comps  - for debugging

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
n.stocks = 1 #make sure square
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

nyrs = 60
N_yas = N_yas_breed = array(0,dim=c(nyrs,n.ages,2))
N_yas[1,,1]=N_yas[1,,2]=Stable.age*5000
Em_tas = array(0,dim=c(60,38,2))
for(it in 2:60){
  N_yas[it,,1]=N_yas[it,,2]=Leslie%*%matrix(N_yas[it-1,,1],n.ages,1)
}
for(it in 41:60){
  Dead = N_yas[it,,1]*(1-ageSurv)
  Em_tas[it,,1]=Em_tas[it,,2]=50*Dead/sum(Dead)
}
plot(apply(Em_tas[41:60,,],2,'mean'),apply(m_tas,2,'mean'))  #need to run sim first to get m_tas
lines(c(0:20),c(0:20))
#looks like proportion sampled in each age class look right

#expected number of comparisons  ---- NOT IMPLEMENTED CORRECTLY
#Em_tas = Em_tas[41:60,,]
E_comps_ytbs = array(0,dim=c(60,60,60,2))
for(isex in 1:2){
  for(it1 in 41:60){
    for(iage1 in 4:38){
      ib = it1 - iage1 + 1
      for(ib2 in (ib+3):60){ 
        for(it2 in 41:60){
          iage2 = it2-ib2+1
          if(iage2<39 & ib2<=it1){
            E_comps_ytbs[it1-iage1+1,it1,ib2,isex]=E_comps_ytbs[it1-iage1+1,it1,ib2,isex]+Em_tas[it1,iage1,isex]*sum(Em_tas[it2,iage2,])
          }
        }
      }
    }
  }
}





