#fit new survival curve w/o proportional hazard component; examine influence of a,b,c on survival curve

haz.mult = exp(-0.19)  #proportional hazards multiplier for bearded seals
haz.mult = exp(0.26)  # alternative value to give lambda close to 1.0
a.haz = 0.0541
b.haz = 1.609 + 1.0  # bounded below by 1.0
c.haz = -(log(0.97)-0.00513)  #including harvest mortality of 0.03 here
phi_RAW = function(a.haz,b.haz,c.haz,haz.mult,Age){
  exp(-haz.mult*((a.haz*Age)^b.haz + (a.haz*Age)^(1/b.haz) + c.haz - (a.haz*(Age-1))^b.haz - (a.haz*(Age-1))^(1/b.haz) ))
}
Age = c(1:38)
S = phi_RAW(a.haz,b.haz,c.haz,haz.mult,Age)

S_ssq = function(par,S,Age){
  a.haz = exp(par[1])
  b.haz = exp(par[2])+1
  c.haz = exp(par[3])
  Pred = phi_RAW(a.haz,b.haz,c.haz,haz.mult=1,Age)
  return(sum((Pred-S)^2))
}

S.out = nlminb(c(0.5,0.5,0.5),S_ssq,S=S,Age=Age)  #-2.904, 0.586, -2.579

a.haz = exp(S.out$par[1])
b.haz = exp(S.out$par[2])+1
c.haz = exp(S.out$par[3])
plot(S)
S.new = phi_RAW(a.haz,b.haz,c.haz,haz.mult=1,Age)
lines(S.new)

plot(S.new)
a.haz = exp(S.out$par[1]-0.3)
b.haz = exp(S.out$par[2])+1
c.haz = exp(S.out$par[3])
lines(phi_RAW(a.haz,b.haz,c.haz,haz.mult=1,Age),col='blue')

a.haz = exp(S.out$par[1])
b.haz = exp(S.out$par[2]-0.5)+1
c.haz = exp(S.out$par[3])
lines(phi_RAW(a.haz,b.haz,c.haz,haz.mult=1,Age),col='green')

plot(S,ylim=c(0.5,1))
a.haz = exp(S.out$par[1])
b.haz = exp(S.out$par[2])+1
c.haz = exp(S.out$par[3]+1)
lines(phi_RAW(a.haz,b.haz,c.haz,haz.mult=1,Age),col='red')



