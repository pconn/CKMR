#plot simulation results

load('Sim_out.RData')

Disp.type = c("Random","All.ages","Juvenile","None")
Exp.type = c('Constant','Moderate.gradient','Extreme.gradient')

BiasN_df = data.frame(Dispersal = rep(Disp.type,300),Sampling=rep(rep(Exp.type,each=4),100),
                     Bias = as.numeric((Sim_results[,,,2]-Sim_results[,,,1])/Sim_results[,,,1]))

library(ggplot2)

pdf("BiasN.pdf")
ggplot(BiasN_df)+ geom_boxplot(aes(x = Sampling,y=Bias,fill=Sampling)) + 
  facet_wrap(~Dispersal,ncol=2)+
  theme(axis.title.x=element_blank(),axis.text.x=element_blank(),text=element_text(size=14))
dev.off()

#Figure out coverage w/ log-based confidence intervals
C = as.numeric(exp(1.96 * sqrt(log(1+Sim_results[,,,3]^2/Sim_results[,,,1]^2))))
BiasN_df$Coverage = as.numeric(Sim_results[,,,1]>(Sim_results[,,,2]/C) & Sim_results[,,,1]<(Sim_results[,,,2]*C))
C = exp(1.96*sqrt(log(1+Var.N/n_est^2)))
CI.low = n_est/C  #log-based CI for N (see e.g. Buckland et al. Distance sampling book, pg 88)
CI.hi = n_est*C

library(doBy)
summaryBy(Coverage~Dispersal+Sampling,data=BiasN_df)


#summarize survival 
haz.mult = exp(-0.19)  #proportional hazards multiplier for bearded seals
haz.mult = exp(0.26)  # alternative value to give lambda close to 1.0
a.haz = 0.0541
b.haz = 1.609 + 1.0  # bounded below by 1.0
c.haz = -(log(0.97)-0.00513)  #including harvest mortality of 0.03 here
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


