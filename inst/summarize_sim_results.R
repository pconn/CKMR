#plot simulation results

load('Sim_out_fec.RData')

Disp.type = c("Complete mixing","All ages dispersal","Juvenile dispersal","No dispersal")
Exp.type = c('Spatially uniform','Moderate gradient','Extreme gradient','Spatially restricted')

BiasN_df = data.frame(Dispersal = rep(Disp.type,400),Sampling=rep(rep(Exp.type,each=4),100),
                     Bias = as.numeric((Sim_results[,,,2]-Sim_results[,,,1])/Sim_results[,,,1]))
BiasN_df$Dispersal <- factor(BiasN_df$Dispersal, levels = Disp.type)
BiasN_df$Sampling <- factor(BiasN_df$Sampling, levels = Exp.type)

library(ggplot2)

pdf("BiasN_fec.pdf")
ggplot(BiasN_df)+ geom_boxplot(aes(x = Sampling,y=Bias,fill=Sampling)) + 
  facet_wrap(~Dispersal,ncol=2)+
  theme(axis.title.x=element_blank(),axis.text.x=element_blank(),text=element_text(size=14))
dev.off()

#Figure out coverage w/ log-based confidence intervals
C = as.numeric(exp(1.96 * sqrt(log(1+Sim_results[,,,3]^2/Sim_results[,,,1]^2))))
BiasN_df$Coverage = as.numeric(Sim_results[,,,1]>(Sim_results[,,,2]/C) & Sim_results[,,,1]<(Sim_results[,,,2]*C))
#C = exp(1.96*sqrt(log(1+Var.N/n_est^2)))
#CI.low = n_est/C  #log-based CI for N (see e.g. Buckland et al. Distance sampling book, pg 88)
#CI.hi = n_est*C

library(doBy)
summaryBy(Coverage~Dispersal+Sampling,data=BiasN_df)


#summarize survival 
a.haz = exp(-2.904)
b.haz = 1 + exp(0.586)
c.haz = exp(-2.579)
haz.mult=1
phi_RAW = function(a.haz,b.haz,c.haz,haz.mult,Age){
  exp(-haz.mult*((a.haz*Age)^b.haz + (a.haz*Age)^(1/b.haz) + c.haz - (a.haz*(Age-1))^b.haz - (a.haz*(Age-1))^(1/b.haz) ))
}
ageSurv <- survCurv <- phi_RAW(a.haz,b.haz,c.haz,haz.mult,c(1:38))
trueS = prod(ageSurv[4:10])

BiasS_df = BiasN_df
BiasS_df$estS = as.numeric(Sim_results[,,,4])
BiasS_df$Bias =(BiasS_df$estS - trueS)/trueS
summaryBy(Bias~Dispersal+Sampling,data=BiasS_df)


summaryBy(Bias~Dispersal+Sampling,data=BiasN_df)

#summarize fecundity
n_ages = 38
Fec_as = matrix(0,n_ages,2)
Fec_as[,1] = 1/(1+exp(-1.264*(c(1:n_ages)-5.424)))  #exponential models fit to bearded seal data
Fec_as[,2] = 1/(1+exp(-1.868*(c(1:n_ages)-6.5)))
Fec_as[1:2,]=0 

load("Est_pars.Rdata")
load("SE_pars.Rdata")

n_sims=100
n_ages=12
Ages = c(1:n_ages)
Sex = c("Female","Male")
#Disp.type = c("Complete mixing","Limited (all ages)","Limited (juv. only)","Sessile")
n_rows = n_sims * n_ages * 2 * length(Exp.type) * length(Disp.type)
Fec_df = data.frame(Age=rep(1:n_ages,2*n_sims*length(Exp.type)*length(Disp.type)),Fecundity=rep(0,n_rows),Dispersal=rep(0,n_rows),Sampling=rep(0,n_rows),Sex=rep(0,n_rows),Sim=rep(0,n_rows))
counter = 1
for(idisp in 1:length(Disp.type)){
  for(isamp in 1:length(Exp.type)){
    for(isex in 1:2){
      for(isim in 1:n_sims){
        Fec_df$Sim[counter:(counter+n_ages-1)]=paste(idisp,isamp,isex,isim)
        Fec_df$Dispersal[counter:(counter+n_ages-1)]=Disp.type[idisp]
        Fec_df$Sampling[counter:(counter+n_ages-1)]=Exp.type[isamp]
        Fec_df$Sex[counter:(counter+n_ages-1)]=Sex[isex]
        if(isex==1)Fec_df$Fecundity[counter:(counter+n_ages-1)]=1/(1+exp(-Est_pars[idisp,isamp,isim,5]*(Ages-Est_pars[idisp,isamp,isim,6])))
        if(isex==2)Fec_df$Fecundity[counter:(counter+n_ages-1)]=1/(1+exp(-Est_pars[idisp,isamp,isim,7]*(Ages-Est_pars[idisp,isamp,isim,8])))
        Fec_df$Fecundity[counter:(counter+1)]=0
        counter=counter+n_ages
      }
    }
  }
}
Mean.df <- aggregate(data = Fec_df, Fecundity ~ Dispersal*Sampling*Sex*Age, mean)

Prior_mean = data.frame(Age = rep(1:n_ages,2),Fecundity=rep(0,2*n_ages),Sex=c(rep("Female",n_ages),rep("Male",n_ages)),Group=c(rep(1,n_ages),rep(2,n_ages)))
Prior_mean$Fecundity[1:n_ages]=1/(1+exp(-1.264*(c(1:n_ages)-5.424)))  #exponential models fit to bearded seal data
Prior_mean$Fecundity[1:2]=0
Prior_mean$Fecundity[(n_ages+1):(2*n_ages)]= 1/(1+exp(-1.868*(c(1:n_ages)-6.5)))
Prior_mean$Fecundity[n_ages+c(1:2)]=0

pdf("Fec_results.pdf")
ggplot() + geom_line(data=Fec_df,aes(x=Age,y=Fecundity,color=Sex,group=Sim),alpha=0.08) + facet_grid(Dispersal~Sampling) +
   geom_line(data=Mean.df,aes(x=Age,y=Fecundity,group=Sex),linetype='dashed',color='black',size=0.8)+
  geom_line(data=Prior_mean,aes(x=Age,y=Fecundity,group=Group),size=.8,color='black')+
  scale_color_manual(values=c("#E69F00", "#56B4E9"))+theme(text = element_text(size=13))+
  scale_x_continuous(limits=c(1, 11.5)) + guides(colour = guide_legend(override.aes = list(alpha = 1,size=1.2)))
dev.off()


### same panel plot but for survival
n_sims=100
n_ages=38
Ages = c(1:n_ages)
n_rows = n_sims * n_ages * length(Exp.type) * length(Disp.type)
S_df = data.frame(Age=rep(1:n_ages,n_sims*length(Exp.type)*length(Disp.type)),Survival=rep(0,n_rows),Dispersal=rep(0,n_rows),Sampling=rep(0,n_rows),Sim=rep(0,n_rows))
counter = 1
for(idisp in 1:length(Disp.type)){
  for(isamp in 1:length(Exp.type)){
    for(isim in 1:n_sims){
      S_df$Sim[counter:(counter+n_ages-1)]=paste(idisp,isamp,isim)
      S_df$Dispersal[counter:(counter+n_ages-1)]=Disp.type[idisp]
      S_df$Sampling[counter:(counter+n_ages-1)]=Exp.type[isamp]
      S_df$Survival[counter:(counter+n_ages-1)]=phi_RAW(a.haz=exp(Est_pars[idisp,isamp,isim,2]),b.haz=1+exp(Est_pars[idisp,isamp,isim,3]),c.haz=exp(Est_pars[idisp,isamp,isim,4]),haz.mult=1,Age=Ages)
      counter=counter+n_ages
    }
  }
}
Mean.df <- aggregate(data = S_df, Survival ~ Dispersal*Sampling*Age, mean)

Prior_mean = data.frame(Age = rep(1:n_ages),Survival=phi_RAW(a.haz,b.haz,c.haz,haz.mult=1,Age=Ages))


pdf("S_results.pdf")
ggplot() + geom_line(data=S_df,aes(x=Age,y=Survival,group=Sim),alpha=0.08) + facet_grid(Dispersal~Sampling) +
  geom_line(data=Mean.df,aes(x=Age,y=Survival),size=1.1)+
  geom_line(data=Prior_mean,aes(x=Age,y=Survival),size=1.1,color='red')+
  scale_color_manual(values=c("#999999"))+theme(text = element_text(size=13))+
  scale_x_continuous(limits=c(1, 38)) 
dev.off()

#plot Fec priors (bootstrap)
set.seed(12345)
n_boot = 100
n_ages = 20
Par1 = rnorm(n_boot,1.264,0.4*1.264)
Par2 = rnorm(n_boot,5.424,0.4*5.424)
Par3 = rnorm(n_boot,1.868,0.4*1.868)
Par4 = rnorm(n_boot,6.5,0.4*6.5)
#Which.gt.0 = which(Par1>0 & Par2>0)
Fec_boot_df = data.frame(Age = rep(1:n_ages,2*n_boot),Fecundity=rep(0,2*n_ages*n_boot),Sex=c(rep("Female",n_ages*n_boot),rep("Male",n_ages*n_boot)),Group=rep(0,n_ages*n_boot*2))
counter=1
for(iboot in 1:n_boot){
  Fec_boot_df$Fecundity[counter:(counter+n_ages-1)]=1/(1+exp(-Par1[iboot]*(c(1:n_ages)-Par2[iboot])))
  Fec_boot_df$Fecundity[counter:(counter+1)]=0
  Fec_boot_df$Group[counter:(counter+n_ages-1)]=paste(iboot)
  counter=counter+n_ages
}
for(iboot in 1:n_boot){
  Fec_boot_df$Fecundity[counter:(counter+n_ages-1)]=1/(1+exp(-Par3[iboot]*(c(1:n_ages)-Par4[iboot])))
  Fec_boot_df$Fecundity[counter:(counter+1)]=0
  Fec_boot_df$Group[counter:(counter+n_ages-1)]=paste(iboot+n_boot)
  counter=counter+n_ages
}
Prior_mean = data.frame(Age = rep(1:n_ages,2),Fecundity=rep(0,2*n_ages),Sex=c(rep("Female",n_ages),rep("Male",n_ages)))
Prior_mean$Fecundity[1:n_ages]=1/(1+exp(-1.264*(c(1:n_ages)-5.424)))  #exponential models fit to bearded seal data
Prior_mean$Fecundity[1:2]=0
Prior_mean$Fecundity[(n_ages+1):(2*n_ages)]= 1/(1+exp(-1.868*(c(1:n_ages)-6.5)))
Prior_mean$Fecundity[n_ages+c(1:2)]=0

Post_pars = apply(Est_pars[,,,5:8],4,'mean')
Post_mean = data.frame(Age = rep(1:n_ages,2),Fecundity=rep(0,2*n_ages),Sex=c(rep("Female",n_ages),rep("Male",n_ages)))
Post_mean$Fecundity[1:n_ages]=1/(1+exp(-Post_pars[1]*(c(1:n_ages)-Post_pars[2])))  #exponential models fit to bearded seal data
Post_mean$Fecundity[1:2]=0
Post_mean$Fecundity[(n_ages+1):(2*n_ages)]= 1/(1+exp(-Post_pars[3]*(c(1:n_ages)-Post_pars[4])))
Post_mean$Fecundity[n_ages+c(1:2)]=0


pdf("Fec_prior.pdf")
ggplot() + geom_line(data=Fec_boot_df,aes(x=Age,y=Fecundity,group=Group),alpha=0.08)+facet_wrap(~Sex)+
  #geom_line(data=Mean.df,aes(x=Age,y=Fecundity,color=Sex),size=1.2)+
  scale_color_manual(values=c("#E69F00", "#56B4E9"))+theme(text = element_text(size=13))+
  scale_x_continuous(limits=c(1, 20)) +
  geom_line(data=Prior_mean,aes(x=Age,y=Fecundity),alpha=1,color='black',size=1.3)+
  geom_line(data=Post_mean,aes(x=Age,y=Fecundity),alpha=0.5,color='red',size=1.3)
dev.off()


#plot Survival priors (bootstrap)
set.seed(12345)
n_boot = 100
n_ages = 38

Par1 = rnorm(n_boot,-2.904,0.15)
Par2 = rnorm(n_boot,0.586,0.25)
Par3 = rnorm(n_boot,-2.579,0.5)
#Which.gt.0 = which(Par1>0 & Par2>0)
Surv_boot_df = data.frame(Age = rep(1:n_ages,n_boot),Survival=rep(0,n_ages*n_boot),Group=rep(0,n_ages*n_boot))
counter=1
for(iboot in 1:n_boot){
  Surv_boot_df$Survival[counter:(counter+n_ages-1)]=phi_RAW(a.haz=exp(Par1[iboot]),b.haz=1+exp(Par2[iboot]),c.haz=exp(Par3[iboot]),haz.mult=1,c(1:n_ages))
  Surv_boot_df$Group[counter:(counter+n_ages-1)]=paste(iboot)
  counter=counter+n_ages
}
Prior_mean = data.frame(Age = rep(1:n_ages),Survival=rep(0,n_ages))
Prior_mean$Survival=phi_RAW(a.haz=exp(-2.904),b.haz=1+exp(0.586),c.haz=exp(-2.579),haz.mult=1,c(1:n_ages))


pdf("Surv_prior.pdf")
ggplot() + geom_line(data=Surv_boot_df,aes(x=Age,y=Survival,group=Group),alpha=0.08)+
  #geom_line(data=Mean.df,aes(x=Age,y=Survival,color=Sex),size=1.2)+
  scale_color_manual(values=c("#E69F00", "#56B4E9"))+theme(text = element_text(size=14))+
  geom_line(data=Prior_mean,aes(x=Age,y=Survival),color='blue',size=1.3)
dev.off()

#Ratio of prior to posterior SDs
apply(SE_pars[,,,2:8],4,'mean',na.rm=TRUE)/c(0.15,0.25,0.5,0.4,0.4,0.4,0.4)



