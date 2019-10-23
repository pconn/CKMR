#### check how often GOF tests can detect lack of mixing for different mixing and sampling scenarios
# and different sample sizes

start.time = proc.time()
n.sims = n_sims = 100
n.yrs=n_yrs = 60  #note this is hardwired into sim functions
first_y_sample = 41
source('c:/users/paul.conn/git/ckmr/r/simulate_spatial.R')


Mu_eta = c(-2.904, 0.586, -2.579) #prior means (log-scale RAW survival model) - produced in fit_survival.R

Seal_life_hist = read.csv("c:/users/paul.conn/git/ckmr/sim_inputs.csv",header=T)[1:38,]
ages <- (min(Seal_life_hist$Age):max(Seal_life_hist$Age))+1  #we'll start age at 1
n.ages=n_ages= max(ages)-min(ages)+1
Fec_as = matrix(0,n_ages,2)
Fec_as[,1] = 0.5/(1+exp(-1.264*(c(1:n_ages)-5.424)))  #exponential models fit to bearded seal data
Fec_as[,2] = 0.5/(1+exp(-1.868*(c(1:n_ages)-6.5)))
Fec_as[1:2,]=0 
Mu_fec = matrix(c(1.264,1.868,5.424,6.5),2,2)

n.stocks = 100 #make sure square
library(sp)
library(rgeos)
Locations = SpatialPoints(cbind(rep(c(1:sqrt(n.stocks)),each=sqrt(n.stocks)),rep(c(sqrt(n.stocks):1),sqrt(n.stocks))))
Distances = gDistance(Locations,byid=TRUE) #formulate distance matrix, assuming stocks are numbered from top to bottom

Disp.type = c("random","all.ages","juvenile","none")
Exp.type = c('constant','moderate.gradient','extreme.gradient','refugia')

Samp.size = c(15,25,100)

Detect = array(0,dim=c(n_sims,length(Disp.type),length(Exp.type),length(Samp.size),4))  #last dimension is num PO matches, num half-sib matches, detect nonmixing - PO, detect nonmixing - HS

Locations = SpatialPoints(cbind(rep(c(1:sqrt(n.stocks)),each=sqrt(n.stocks)),rep(c(sqrt(n.stocks):1),sqrt(n.stocks))))
Distances = gDistance(Locations,byid=TRUE) #formulate distance matrix, assuming stocks are numbered from top to bottom

idisp = 1
iexp = 4
ieffort = 3
isim = 1

cur.seed = 11111
for(idisp in 1:1){
  for(iexp in 1:4){
    for(ieffort in 1:3){
      for(isim in 1:n.sims){
        cur.seed=cur.seed+1
        set.seed(cur.seed)
        curd = simulate_spatial(exp.type=Exp.type[iexp],dispersal.type=Disp.type[idisp],init.N=10000,samp.size=Samp.size[ieffort],n.stocks=n.stocks)
        first_y = 1
        last_y= max(curd$sim_data$samps$DY)
        
        n_samp = nrow(curd$sim_data$samps)
        n.pop = length(curd$sim_data$isamp_POP)
        isamp_HS = c(curd$sim_data$isamp_MHSP,curd$sim_data$isamp_PHSP)
        jsamp_HS = c(curd$sim_data$jsamp_MHSP,curd$sim_data$jsamp_PHSP)
        n.hs = length(isamp_HS)
        
        #random samples of comparisons
        n.rand = 10000
        Rand = cbind(sample(c(1:n_samp),n.rand,replace=TRUE),sample(c(1:n_samp),n.rand,replace=TRUE))
        Dist.rand = rep(0,n.rand)
        for(i in 1:n.rand)Dist.rand[i]=Distances[curd$sim_data$samps[Rand[i,1],"STOCK"],curd$sim_data$samps[Rand[i,2],"STOCK"]]
        Which.same.year = which((curd$sim_data$samps[Rand[,1],"DY"]==curd$sim_data$samps[Rand[,2],"DY"]) & (curd$sim_data$samps[Rand[,1],"DA"]==1 | curd$sim_data$samps[Rand[,2],"DA"]==1))
        if(length(Which.same.year)>0)Dist.rand = Dist.rand[-Which.same.year]
        
        
        Dist.pop = rep(0,n.pop)
        for(i in 1:n.pop)Dist.pop[i] = Distances[curd$sim_data$samps[curd$sim_data$isamp_POP[i],"STOCK"],curd$sim_data$samps[curd$sim_data$jsamp_POP[i],"STOCK"]]
        Which = which((curd$sim_data$samps[curd$sim_data$isamp_POP,"DA"]==1)&(curd$sim_data$samps[curd$sim_data$isamp_POP,"DY"]==curd$sim_data$samps[curd$sim_data$jsamp_POP,"DY"]))
        if(length(Which)>0){
          Dist.pop = Dist.pop[-Which]
          n.pop = n.pop-length(Which)
        }
        
        Dist.hs = rep(0,n.hs)
        for(i in 1:n.hs)Dist.hs[i] = Distances[curd$sim_data$samps[isamp_HS[i],"STOCK"],curd$sim_data$samps[jsamp_HS[i],"STOCK"]]
        Which = which((curd$sim_data$samps[isamp_HS,"DY"]==curd$sim_data$samps[jsamp_HS,"DY"])&(curd$sim_data$samps[isamp_HS,"DA"]==1)&(curd$sim_data$samps[jsamp_HS,"DA"]==1))
        if(length(Which)>0){
          Dist.hs=Dist.hs[-Which]
          n.hs = n.hs -length(Which)
        }
        
        Detect[isim,idisp,iexp,ieffort,1]= n.pop
        Detect[isim,idisp,iexp,ieffort,2]= n.hs
        
        if(n.pop>0)Detect[isim,idisp,iexp,ieffort,3]=ks.test(Dist.rand,Dist.pop,alternative="less")$p.value
        else Detect[isim,idisp,iexp,ieffort,3]=NA
        Detect[isim,idisp,iexp,ieffort,4]=ks.test(Dist.rand,Dist.hs,alternative="less")$p.value
        
      }
      save(Detect,file="GOF_out.RData")
      
    }
  }
}





