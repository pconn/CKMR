# plot bearded seal mortality and fecundity inputs

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
#Seal_life_hist[6:38,"S.male"]=Seal_life_hist[6:38,"S.fem"]=0.9  # we'll simplify half sibs by having constant adult survival
#now simulated seal population 
ages <- (min(Seal_life_hist$Age):max(Seal_life_hist$Age))+1  #we'll start age at 1
n.ages= max(ages)-min(ages)+1
ageSurv <- survCurv <- phi_RAW(a.haz,b.haz,c.haz,haz.mult,c(1:38))
ageMort <- 1-ageSurv

Mat.male = c(0,Seal_life_hist[1:37,"Mat.male"])  #add a zero because of delayed implantation
Mat.fem = c(0,Seal_life_hist[1:37,"Mat.fem"]) #add a zero because of delayed implantation

DF = data.frame(Value = c(ageSurv,Mat.male,Mat.fem),Type=rep(c("Survival","Male fecundity","Female fecundity"),each=38),Age=rep(c(0:37),3))

pdf("life_history.pdf")
ggplot(DF)+geom_line(aes(x=Age,y=Value,linetype=Type,colour=Type),size=1.2)+
  theme(text=element_text(size=14))+scale_color_manual( values = c("black","brown","blue"))+
  theme(legend.key.width = unit(0.8, "cm")) + ylab("Probability")
dev.off()