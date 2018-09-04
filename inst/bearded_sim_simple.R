#Simple bearded sim adapted from Beluga code - assumes ages known w certainty!
#Pars consists of 1) log(No. of mature females) at time 1 (40 years before there are data), 
#  2) log(No. of mature males) at time 1, 3) sexual maturity age for males (weird link), and 
#  4) a common slope for population trend of matures (log link)

#set dimensions of things
n_ages = 38  #total number of ages modeled (should be set to max age possible or thereabouts)
n_yrs =60
t_start = 41 #first year of study
t_end = 60  #last year of study
n_yrs_sample = t_end-t_start+1
P_Mother = P_Father = array(0,dim=c(n_yrs,n_yrs,n_yrs))  #array  dimensions are parent birth year, parent death year, offspring birth year
Maturity_age = Paternity_age = rep(0,n_ages)
Maturity_age[8:n_ages]=Paternity_age[8:n_ages]=1

get_P_beluga <- function(Pars,P_Mother,P_Father,Maturity_age,Paternity_age,n_yrs,t_start,t_end){
  n_ages=length(Maturity_age)
  Log_trend = (0.01/(1+exp(-Pars[3]))-0.005)*(0:(t_end-1))  #trend on log scale limited to +/- 0.01/yr
  N_F_yr=exp(Pars[1]+Log_trend)  #number of mature females (assume time constant) - (total reproductive output from females)
  for(ibirth1 in 1:n_yrs){  #mum
    for(ideath1 in max(ibirth1,t_start):t_end){ 
      for(ibirth2 in 1:n_yrs){
        if(ibirth2<=ideath1 & ibirth2>ibirth1 & ((ibirth2-ibirth1)<=n_ages))
          P_Mother[ibirth1,ideath1,ibirth2]=Maturity_age[ibirth2-ibirth1]/N_F_yr[ibirth2]
      }
    } 
  }
  N_M_yr=exp(Pars[2]+Log_trend) #number of mature males (time constant) - (total reproductive output from males)
  #cat(Paternity_age)
  for(ibirth1 in 1:n_yrs){  #dad
    for(ideath1 in max(ibirth1,t_start):t_end){ 
      for(ibirth2 in 1:n_yrs){
        if(ibirth2<=ideath1 & ibirth2>ibirth1 & ((ibirth2-ibirth1)<=n_ages))
          P_Father[ibirth1,ideath1,ibirth2]=Paternity_age[ibirth2-ibirth1]/N_M_yr[ibirth2]
      }
    } 
  }
  return(list(P_Mother=P_Mother,P_Father=P_Father))
}


#Generate some data
logit<-function(x)log(x/(1-x))
Pars=c(log(10000),log(10000),0)

P = get_P_beluga(Pars=Pars,P_Mother=P_Mother,P_Father=P_Father,Paternity_age=Paternity_age,Maturity_age=Maturity_age,n_yrs=n_yrs,t_start=t_start,t_end=t_end) 

#extremely basic checks on P function
#P$P_Mother[1,5,20] #okay to be zero because it's before the study starts
#P$P_Mother[1,41,5] #should be zero because mother not mature when offspring born
#P$P_Mother[1,41,13] #mother fully mature so should be 1/N_F
#P$P_Father[1,41,13] #male fully mature so should be 1/N_M
#P$P_Father[1,41,7] #male immature so should ~0

n_samples_per_yr = 100

Surv_age = rep(0.92,n_ages)
Surv_age[1]=0.55
Prop_age = rep(1,n_ages)
for(iage in 2:n_ages)Prop_age[iage]=Prop_age[iage-1]*Surv_age[iage-1]
Prop_age=Prop_age/sum(Prop_age)  #stable age distribution given assumed survival

n_samples=n_yrs_sample*n_samples_per_yr
Samples = matrix(0,n_samples,3)
Samples[,1]=rep(c(t_start:t_end),each=n_samples_per_yr)
Samples[,2]=Samples[,1]-sample(c(1:n_ages),n_samples,replace=TRUE,prob=Prop_age) #birth year
Samples[,3]=round(runif(n_samples)) #sex; 0=female

#Pairwise comparison matrix - still includes within year comparisons (may want to change)
Data = array(0,dim=c(n_samples*(n_samples-1)/2,5))
#columns are: adult birth; adult death year; young birth; adult sex; probability of POP
Prob_vec = rep(0,nrow(Data))
Prob_mat = matrix(0,n_samples,n_samples)
counter=1
for(iind1 in 1:(n_samples-1)){ #brute force - could probably be improved w/ expand.grid or something
  for(iind2 in (iind1+1):n_samples){
    if(Samples[iind1,2]>Samples[iind2,2]){ #birth year greater for first value
      Data[counter,1]=Samples[iind2,2]
      Data[counter,2]=Samples[iind2,1]
      Data[counter,3]=Samples[iind1,2]
      Data[counter,4]=Samples[iind2,3]
    }
    else{ #birth year greater for second value
      Data[counter,1]=Samples[iind1,2]
      Data[counter,2]=Samples[iind1,1]
      Data[counter,3]=Samples[iind2,2]
      Data[counter,4]=Samples[iind1,3]
    }
    if(Data[counter,4]==0){
      Prob_vec[counter]=P$P_Mother[Data[counter,1],Data[counter,2],Data[counter,3]]
      Prob_mat[iind1,iind2]=P$P_Mother[Data[counter,1],Data[counter,2],Data[counter,3]]
    }
    if(Data[counter,4]==1){
      Prob_vec[counter]=P$P_Father[Data[counter,1],Data[counter,2],Data[counter,3]]
      Prob_mat[iind1,iind2]=P$P_Father[Data[counter,1],Data[counter,2],Data[counter,3]]
    }
    counter=counter+1
  }
}
#determine matches
#Data[,5]=(runif(nrow(Data))<Prob_vec)

#format for C++ 
Samps = data.frame(matrix(0,nrow(Samples),4))
colnames(Samps)=c("ID","SEX","DY","DA")
Samps$SEX="F"
Samps[which(Samples[,3]==1),"SEX"]="M"
Samps[,3]=Samples[,1]
Samps[,4]=Samples[,1]-Samples[,2]

#remove males and comparisons in birth year for now
#Which.remove = which(Samps$SEX=='M')
#Samps = Samps[-Which.male,]
#Prob_mat = Prob_mat[-Which.male,-Which.male]

Match_mat = 0*Prob_mat
Match_mat[which(Prob_mat>0)]=(runif(length(which(Prob_mat>0)))<Prob_mat[which(Prob_mat>0)])

n.pops = sum(Match_mat==1)
cat(n.pops)

isamp_POP = jsamp_POP = rep(0,n.pops)

Which.match = which(Match_mat==1,arr.ind=TRUE)
isamp_POP=Which.match[,1]
jsamp_POP=Which.match[,2]

Out=list(samps = Samps,isamp_POP=isamp_POP,jsamp_POP=jsamp_POP)
save(Out,file="Sim_bearded_simple.RData")

