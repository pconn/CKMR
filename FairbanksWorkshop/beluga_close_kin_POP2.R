#Toy Beluga close kin model - assumes ages known w certainty!
#attempting to estimate 1) No. of mature females at time 1 (40 years before there are data), 
#  2) No. of mature males at time 1, 3) sexual maturity age for males, and 
#  4) a common slope for population trend of matures

#set dimensions of things
n_ages = 40  #total number of ages modeled (should be set to max age possible or thereabouts)
n_yrs =60
t_start = 41 #first year of study
t_end = 60  #last year of study
P_Mother = P_Father = array(0,dim=c(n_yrs,n_yrs,n_yrs))  #array  dimensions are parent birth year, parent death year, offspring birth year
Maturity_age = rep(0,n_ages)
Maturity_age[12:n_ages]=1
Maturity_age[7:11] = c(1:5)/6

get_P_beluga <- function(Pars,P_Mother,P_Father,Maturity_age,n_yrs,t_start,t_end){
  n_ages=length(Maturity_age)
  Log_trend = (0.01/(1+exp(-Pars[4]))-0.005)*(0:(t_end-1))  #trend on log scale limited to +/- 0.01/yr
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
  Paternity_age=rep(0,n_ages)
  age_50 = n_ages/(1+exp(-Pars[3]))  #logistic location parameter has range (0,n_ages)
  Paternity_age=1/(1+exp(-10*(c(1:n_ages)-age_50)))  #"almost" knife edged maturity for males (continuous logistic function to be kind to optimizer)
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

#Datasets have the following columns: birth of parent, death of parent, birth of offspring, frequency of comparison
beluga_neg_log_lik <- function(Pars,Negatives_Mother,Negatives_Father,Pairs_Mother,Pairs_Father,P_Mother,P_Father,Maturity_age,n_yrs,t_start,t_end){
  P=get_P_beluga(Pars=Pars,P_Mother=P_Mother,P_Father=P_Father,Maturity_age=Maturity_age,n_yrs=n_yrs,t_start=t_start,t_end=t_end)

  loglik=0
    
  #likelihood contributions for all negative comparisons
  for(irow in 1:nrow(Negatives_Mother)){
    loglik=loglik+Negatives_Mother[irow,4]*log(1-P$P_Mother[Negatives_Mother[irow,1],Negatives_Mother[irow,2],Negatives_Mother[irow,3]])
  }
  for(irow in 1:nrow(Negatives_Father)){
    loglik=loglik+Negatives_Father[irow,4]*log(1-P$P_Father[Negatives_Father[irow,1],Negatives_Father[irow,2],Negatives_Father[irow,3]])
  }  
  #likelihood contributions for positive comparisons
  for(irow in 1:nrow(Pairs_Mother)){
    loglik=loglik+Pairs_Mother[irow,4]*log(P$P_Mother[Pairs_Mother[irow,1],Pairs_Mother[irow,2],Pairs_Mother[irow,3]])
  }
  for(irow in 1:nrow(Pairs_Father)){
    loglik=loglik+Pairs_Father[irow,4]*log(P$P_Father[Pairs_Father[irow,1],Pairs_Father[irow,2],Pairs_Father[irow,3]])
  }  
  -loglik
}

#Generate some data
age_mat_male=8
logit<-function(x)log(x/(1-x))
Pars=c(log(4000),log(5000),logit(age_mat_male/n_ages),0)

P = get_P_beluga(Pars=Pars,P_Mother=P_Mother,P_Father=P_Father,Maturity_age=Maturity_age,n_yrs=n_yrs,t_start=t_start,t_end=t_end) #age_50 on real scale is 8

#extremely basic checks on P function
P$P_Mother[1,5,20] #okay to be zero because it's before the study starts
P$P_Mother[1,41,5] #should be zero because mother not mature when offspring born
P$P_Mother[1,41,13] #mother fully mature so should be 1/N_F
P$P_Father[1,41,13] #male fully mature so should be 1/N_M
P$P_Father[1,41,7] #male immature so should ~0

n_samples_per_yr = 30

Surv_age = rep(0.95,n_ages)
Surv_age[1]=0.85
Prop_age = rep(1,n_ages)
for(iage in 2:n_ages)Prop_age[iage]=Prop_age[iage-1]*Surv_age[iage-1]
Prop_age=Prop_age/sum(Prop_age)  #stable age distribution given assumed survival

n_samples=n_yrs*n_samples_per_yr
Samples = matrix(0,n_samples,3)
Samples[,1]=rep(c(t_start:t_end),each=n_samples_per_yr)
Samples[,2]=Samples[,1]-sample(c(1:n_ages),n_samples,replace=TRUE,prob=Prop_age) #birth year
Samples[,3]=round(runif(n_samples)) #sex; 0=female

#Pairwise comparison matrix - still includes within year comparisons (may want to change)
Data = array(0,dim=c(n_samples*(n_samples-1)/2,5))
#columns are: adult birth; adult death year; young birth; adult sex; probability of POP
Prob_vec = rep(0,nrow(Data))
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
    if(Data[counter,4]==0)Prob_vec[counter]=P$P_Mother[Data[counter,1],Data[counter,2],Data[counter,3]]
    if(Data[counter,4]==1)Prob_vec[counter]=P$P_Father[Data[counter,1],Data[counter,2],Data[counter,3]]
    counter=counter+1
  }
}
#determine matches
Data[,5]=(runif(nrow(Data))<Prob_vec)
cat(paste("Number of POPs:",sum(Data[,5])))  # number of POPs

#split into male/female, match/no match datasets and do some frequency calculations; switching definition of 4th column to frequency
Data_dad_no = Data[which(Data[,4]==1 & Data[,5]==0),1:4]
Data_dad_yes = Data[which(Data[,4]==1 & Data[,5]==1),1:4]
Data_mom_no = Data[which(Data[,4]==0 & Data[,5]==0),1:4]
Data_mom_yes = Data[which(Data[,4]==0 & Data[,5]==1),1:4]

library(plyr) #for frequencies
Data_dad_no=count(Data_dad_no[,1:3])
Data_mom_no=count(Data_mom_no[,1:3])
Data_dad_yes=count(Data_dad_yes[,1:3])
Data_mom_yes=count(Data_mom_yes[,1:3])


#make sure there's no issues w initial values
beluga_neg_log_lik(Pars=Pars,Negatives_Mother=Data_mom_no,Negatives_Father=Data_dad_no,Pairs_Mother=Data_mom_yes,Pairs_Father=Data_dad_yes,P_Mother=P_Mother,P_Father=P_Father,Maturity_age=Maturity_age,n_yrs=n_yrs,t_start=t_start,t_end=t_end)



#fit model!!
library(optimx)
CK_fit <- optimx(par=Pars,fn=beluga_neg_log_lik,hessian=TRUE,method="BFGS",Negatives_Mother=Data_mom_no,Negatives_Father=Data_dad_no,Pairs_Mother=Data_mom_yes,Pairs_Father=Data_dad_yes,P_Mother=P_Mother,P_Father=P_Father,Maturity_age=Maturity_age,n_yrs=n_yrs,t_start=t_start,t_end=t_end)
CK_fit

#compute variance covariance matrix 
D=diag(4)*c(exp(CK_fit$p1),exp(CK_fit$p2),n_ages*exp(CK_fit$p3)/(1+exp(CK_fit$p3))^2,0.01*exp(CK_fit$p4)/(1+exp(CK_fit$p4))^2) #derivatives of transformations
VC_trans = solve(attr(CK_fit, "details")["BFGS" ,"nhatend"][[1]])
VC = (t(D)%*%VC_trans%*%D) #delta method
SE=sqrt(diag(VC))

cat(paste("Estimated mature female abundance: ",exp(CK_fit$p1),", SE = ",SE[1],"\n"))
cat(paste("Estimated mature male abundance: ",exp(CK_fit$p2),", SE = ",SE[2],"\n"))
cat(paste("Estimated male age at maturity: ",n_ages*plogis(CK_fit$p3),", SE = ",SE[3],"\n"))
cat(paste("Estimated log-scale trend: ",0.01*plogis(CK_fit$p4)-0.005,", SE = ",SE[4],"\n"))
cat(paste("Real scale lambda: ",exp(0.01*plogis(CK_fit$p4)-0.005),"\n"))



