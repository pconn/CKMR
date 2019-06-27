#run simulation study
set.seed(12345)
start.time = proc.time()
n.sims = 100
n.yrs=n_yrs = 60  #note this is hardwired into sim functions
first_y_sample = 41

source('c:/users/paul.conn/git/ckmr/r/simulate_spatial.R')


setwd("c:/users/paul.conn/git/CKMR")
load("fitbits.RDa")
library('mvbutils')
library('debug')
library('atease')
library('offarray')
library('ids')
source("./R/util_funcs.R")  #more functions from Mark


Cenv = load_ADT_DLL(folder='c:/users/paul.conn/git/CKMR/bearded2/x64/debug')
getc = function(x)eval(parse(text=paste0("Cenv$get.",x,"(ck)")))


#Survival stuff
# haz.mult = exp(-0.19)  #proportional hazards multiplier for bearded seals
# haz.mult = exp(0.26)  # alternative value to give lambda close to 1.0
# a.haz = 0.0541
# b.haz = 1.609 + 1.0  # bounded below by 1.0
# c.haz = -(log(0.97)-0.00513)  #including harvest mortality of 0.03 here
# a_mean = a.haz
# b_mean = b.haz
# c_mean = c.haz
# wt_a = 100
# wt_b = 100
# wt_c = 100
# haz_mult=haz.mult
SD_eta = c(0.15,0.25,0.5)  #prior sd's  
Mu_eta = c(-2.904, 0.586, -2.579) #prior means (log-scale RAW survival model) - produced in fit_survival.R

Seal_life_hist = read.csv("c:/users/paul.conn/git/ckmr/sim_inputs.csv",header=T)[1:38,]
ages <- (min(Seal_life_hist$Age):max(Seal_life_hist$Age))+1  #we'll start age at 1
n.ages=n_ages= max(ages)-min(ages)+1
# Mat.male = c(0,Seal_life_hist[1:37,"Mat.male"])  #add a zero because of delayed implantation
# Mat.fem = c(0,Seal_life_hist[1:37,"Mat.fem"]) #add a zero because of delayed implantation
Fec_as = matrix(0,n_ages,2)
# Fec_as[,1] = 0.5*Mat.fem
# Fec_as[,2] = 0.5*Mat.male
Fec_as[,1] = 0.5/(1+exp(-1.264*(c(1:n_ages)-5.424)))  #exponential models fit to bearded seal data
Fec_as[,2] = 0.5/(1+exp(-1.868*(c(1:n_ages)-6.5)))
Fec_as[1:2,]=0 
Mu_fec = matrix(c(1.264,1.868,5.424,6.5),2,2)
SD_fec = 0.4*Mu_fec

n.stocks = 100 #make sure square
library(sp)
library(rgeos)
Locations = SpatialPoints(cbind(rep(c(1:sqrt(n.stocks)),each=sqrt(n.stocks)),rep(c(sqrt(n.stocks):1),sqrt(n.stocks))))
Distances = gDistance(Locations,byid=TRUE) #formulate distance matrix, assuming stocks are numbered from top to bottom

n_ages = n.ages

#par_start = c(log(945),log(a.haz),log(b.haz-1),log(c.haz)) 
par_start = c(log(945),Mu_eta,1.3,5.4,1.9,6.5)  #init R0, 3 survival RAW pars, 2 logistic fecundity fem, 2 logistic fecundity male 


Disp.type = c("random","all.ages","juvenile","none")
Exp.type = c('constant','moderate.gradient','extreme.gradient','refugia')

Sim_results = array(0,dim=c(length(Disp.type),length(Exp.type),n.sims,5)) #last dim is True N, est N, SE N, Est S, SE S
Est_pars = SE_pars = array(0,dim=c(length(Disp.type),length(Exp.type),n.sims,8)) 

idisp=1
iexp=1
isim=1

for(idisp in 1:4){
  for(iexp in 1:4){
    for(isim in 1:n.sims){
      curd = simulate_spatial(exp.type=Exp.type[iexp],dispersal.type=Disp.type[idisp],init.N=10000,samp.size=100,n.stocks=n.stocks)
      first_y = 1
      last_y= max(curd$sim_data$samps$DY)
      
      #n_par = 4
      n_par = 8
      n_samp = nrow(curd$sim_data$samps)
      n_POP = length(curd$sim_data$isamp_POP)
      amat = 3  #age at maturity is used to calculate number of comparisons and thus speeds likelihood computation
      # (don't bother with ages for which parent is immature)
      tcap = curd$sim_data$samps$DY
      a = curd$sim_data$samps$DA
      sex = rep(0,n_samp) 
      sex[curd$sim_data$samps$SEX=="M"]=1
      isamp_POP = curd$sim_data$isamp_POP
      jsamp_POP = curd$sim_data$jsamp_POP
      isamp_HS = c(curd$sim_data$isamp_MHSP,curd$sim_data$isamp_PHSP)
      jsamp_HS = c(curd$sim_data$jsamp_MHSP,curd$sim_data$jsamp_PHSP)
      sex_HS = c(rep(0,length(curd$sim_data$isamp_MHSP)),rep(1,length(curd$sim_data$isamp_PHSP)))
      n_HS=length(isamp_HS)
      
      m_tas = curd$m_tas
      ck <- Cenv$create()  #R objects that match C code must be defined above
      
      Cenv$make_data_summaries( ck) # classic pattern for calls to C code-- ck will be 1st arg
      
      
      # much much later
      res1 <- Cenv$lglk( ck, par_start)
      grad1 = Cenv$Dlglk(ck,par_start)
      
      fitme <- nlminb( par_start, NEG( Cenv$lglk), NEG( Cenv$Dlglk), Context=ck, control=list( trace=6,eval.max=1000,iter.max=750))
      H <- numderiv( Cenv$Dlglk, fitme$par, Context=ck)
      
      stuff <- list( lglk=Cenv$lglk( ck, fitme$par),par=fitme$par,Sigma=-solve(H)) # also ensures all internal stuff is set right
      
      # cat(paste('expected R0: ',945))
      # cat(paste('estimated R0: ',exp(fitme$par[1])))
      # 
      # N_y = getc("N_yas")
      # plot(apply(curd$N_yas[41:60,1:38,],1,'sum'),ylim = c(0,13000)) 
      # plot.n = apply(N_y[41:60,1:38,],1,'sum')
      # lines(plot.n)
      
      fit=stuff
      
      getN <- function( params) {
        Cenv$lglk( ck, params) 
        N_yas <- getc("N_yas")
        N_mat <- N_yas[,1:n_ages,]
        return( as.vector(apply(N_mat,1,'sum')))
      }
      getN_mean <- function( params, years, ages) {
        Cenv$lglk( ck, params) 
        N_yas <- getc("N_yas")
        N_mat <- N_yas[years,ages,]
        return( mean(apply(N_mat,1,'sum')))
      }
      library(numDeriv)
      dNdpar <- numderiv( getN_mean, fitme$par, years=41:60, ages=3:n_ages)
      varN = dNdpar %**% solve( -H) %**% t(dNdpar)
      #sqrt(diag(varN))
      
       
      true.mean.N = mean(apply(curd$N_yas[41:60,3:38,],1,'sum'))
      est.mean.N = getN_mean(params=fitme$par,years=41:60,ages=3:n_ages)
      SE = sqrt(varN)

      
      phi_RAW = function(a.haz,b.haz,c.haz,haz.mult,Age){
        exp(-haz.mult*((a.haz*Age)^b.haz + (a.haz*Age)^(1/b.haz) + c.haz - (a.haz*(Age-1))^b.haz - (a.haz*(Age-1))^(1/b.haz) ))
      }
      #haz.mult = exp(0.26)  # alternative value to give lambda close to 1.0
      #a.haz = 0.0541
      #b.haz = 1.609 + 1.0  # bounded below by 1.0
      #c.haz = -(log(0.97)-0.00513)  #including harvest mortality of 0.03 here
      #ageSurv <- phi_RAW(a.haz,b.haz,c.haz,haz.mult=exp(0.26),c(1:38))
      
      # S2 = phi_RAW(exp(fitme$par[2]),exp(fitme$par[3])+1,exp(fitme$par[4]),haz.mult=exp(0.26),Age=c(1:38))
      # S2 = phi_RAW(exp(fitme$par[2]),exp(fitme$par[3])+1,exp(fitme$par[4]),haz.mult=1,Age=c(1:38))
      # plot(S2)
      # lines(ageSurv)
      # S3 = phi_RAW(exp(par_start[2]),exp(par_start[3])+1,exp(par_start[4]),haz.mult=haz.mult,Age=c(1:38))
      # lines(S3,lty=2)
      
      getS <- function( params, a,i,j) {
        Cenv$lglk( ck, params) 
        S_aij <- getc("S_aij")
        return( S_aij[a,i,j])
      }
      true.S = prod(phi_RAW(a.haz=exp(-2.904),b.haz=1+exp(.586),c.haz=exp(-2.579),haz.mult=1,c(4:10)))
      estS = getS(fitme$par,4,1,8)  
      dSdpar <- numderiv( getS, fitme$par, a=4,i=1,j=8)
      varS = dSdpar %**% solve( -H) %**% t(dSdpar)
      
      Sim_results[idisp,iexp,isim,]=c(true.mean.N,est.mean.N,SE,estS, sqrt(varS))
      Est_pars[idisp,iexp,isim,]=fitme$par
      SE_pars[idisp,iexp,isim,]=sqrt(diag(stuff$Sigma))
    }
    save(Sim_results,file="Sim_out_fec.RData")
    save(Est_pars,file="Est_pars.RData")
    save(SE_pars,file="SE_pars.RData")
  }
}
elapsed = proc.time()-start.time
cat(elapsed)

# 
# n_comps_ytbs = getc("n_comps_ytbs")
# n_match = getc("n_match_ytbs")
# exp_match = getc("exp_match_ytbs")
# Pr_PO=getc("Pr_PO_ytbs")
# which.gt.0 = which(exp_match>0)
# summary(as.numeric((n_match-exp_match)/exp_match)[which.gt.0])
# resid = (n_match-exp_match)/exp_match
# arr.index = which(resid>0,arr.ind=TRUE)
# resid.num = as.numeric(resid)
# resid2 = resid.num[which(resid.num>0)]
# summary(lm(resid2~arr.index[,1]))
# summary(lm(resid2~arr.index[,2]))
# summary(lm(resid2~arr.index[,3]))
# summary(lm(resid2~arr.index[,4]))
# #trends here don't necessarily mean anything.  There are fewer comparisons for earlier birthed animals simply because there aren't that
# #many old animals sampled
# 
# plot(apply(n_match,1,'sum'),col="blue")
# points(apply(exp_match,1,'sum'))
# 
# plot(apply(n_match,1,'sum')-apply(exp_match,1,'sum'))
# crap = apply(n_match,1,'sum')-apply(exp_match,1,'sum')
# plot(predict(loess(crap~c(1:60))))
# 
# plot(apply(n_match,2,'sum'),col="blue")
# points(apply(exp_match,2,'sum'))
# 
# plot(apply(n_match,2,'sum')-apply(exp_match,2,'sum'))
# crap = apply(n_match,2,'sum')-apply(exp_match,2,'sum')
# plot(predict(loess(crap~c(1:60))))
# 
# plot(apply(n_match,3,'sum'),col="blue")
# points(apply(exp_match,3,'sum'))
# 
# plot(apply(n_match,3,'sum')-apply(exp_match,3,'sum'))
# crap = apply(n_match,3,'sum')-apply(exp_match,3,'sum')
# plot(predict(loess(crap~c(1:60))))
# 
# plot(apply(n_match,4,'sum'),col="blue")
# points(apply(exp_match,4,'sum'))
# 
# 
# #look at difference in birth year among half-sibs
# summary((curd$sim_data$samps[curd$sim_data$isamp_PHSP,"DY"]-curd$sim_data$samps[curd$sim_data$isamp_PHSP,"DA"])-(curd$sim_data$samps[curd$sim_data$jsamp_PHSP,"DY"]-curd$sim_data$samps[curd$sim_data$jsamp_PHSP,"DA"]))
# summary((curd$sim_data$samps[curd$sim_data$isamp_MHSP,"DY"]-curd$sim_data$samps[curd$sim_data$isamp_MHSP,"DA"])-(curd$sim_data$samps[curd$sim_data$jsamp_MHSP,"DY"]-curd$sim_data$samps[curd$sim_data$jsamp_MHSP,"DA"]))
# 
# #look at num matches, Pr_PO, n_comps
# #
