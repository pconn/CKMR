# plot refitted bearded seal mortality and fecundity inputs...this version has 2 param logistic for fecundity
# and a refitted RAW model with NO hazard multiplier

#bearded seal hazard rate pars for RAW model
library(ggplot2)
haz.mult = 1
a.haz = exp(-2.904)
b.haz = exp(.586) + 1.0  # bounded below by 1.0
c.haz = exp(-2.579)  #including harvest mortality of 0.03 here
phi_RAW = function(a.haz,b.haz,c.haz,haz.mult,Age){
  exp(-haz.mult*((a.haz*Age)^b.haz + (a.haz*Age)^(1/b.haz) + c.haz - (a.haz*(Age-1))^b.haz - (a.haz*(Age-1))^(1/b.haz) ))
}

ages <- c(1:38)
n.ages= max(ages)-min(ages)+1
ageSurv <- survCurv <- phi_RAW(a.haz,b.haz,c.haz,haz.mult,c(1:38))
ageMort <- 1-ageSurv

Fec_as = matrix(0,n.ages,2)
Fec_as[,1] = 1/(1+exp(-1.264*(c(1:n.ages)-5.424)))  #exponential models fit to bearded seal data
Fec_as[,2] = 1/(1+exp(-1.868*(c(1:n.ages)-6.5)))
Fec_as[1:2,]=0 

DF = data.frame(Value = c(ageSurv,Fec_as[,2],Fec_as[,1]),Type=rep(c("Survival","Male fecundity","Female fecundity"),each=38),Age=rep(c(0:37),3))

pdf("life_history2.pdf")
ggplot(DF)+geom_line(aes(x=Age,y=Value,linetype=Type,colour=Type),size=1.2)+
  theme(text=element_text(size=14))+scale_color_manual( values = c("black","brown","blue"))+
  theme(legend.key.width = unit(0.8, "cm")) + ylab("Probability")
dev.off()