# fit logistic model to bearded seal fecundity

Seal_life_hist = read.csv("c:/users/paul.conn/git/ckmr/sim_inputs.csv",header=T)[1:38,]
ages <- (min(Seal_life_hist$Age):max(Seal_life_hist$Age))+1  #we'll start age at 1
n.ages=n_ages= max(ages)-min(ages)+1
Mat.male = c(0,Seal_life_hist[1:37,"Mat.male"])  #add a zero because of delayed implantation
Mat.fem = c(0,Seal_life_hist[1:37,"Mat.fem"]) #add a zero because of delayed implantation
Fec_as = matrix(0,n_ages,2)
Fec_as[,1] = 0.5*Mat.fem
Fec_as[,2] = 0.5*Mat.male


#logistic fun

logistic_ssq = function(par,Fec){
  n.ages = length(Fec)
  Pred = 0.5/(1+exp(-par[1]*(c(1:n.ages)-par[2])))
  return(sum((Pred-Fec)^2))
}

Fem.out = nlminb(c(0,0),logistic_ssq,Fec=Fec_as[,1])  #1.264,5.424
Male.out = nlminb(c(0,0),logistic_ssq,Fec=Fec_as[,2])  #1.868,6.5

plot(Fec_as[,2])
lines(0.5/(1+exp(-Male.out$par[1]*(c(1:nrow(Fec_as))-Male.out$par[2]))))
