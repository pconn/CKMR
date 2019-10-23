### tabulate GOF results
load("GOF_out.RData")
Det=Detect
load("GOF_out2.RData")
Det[,2,,,]=Detect[,2,,,]
load("GOF_out3.RData")
Det[,3,,,]=Detect[,3,,,]
load("GOF_out4.RData")
Det[,4,,,]=Detect[,4,,,]

#dimensions of Det are sim #, dispersal scenario, exploitation scenario, effort scenario, result
#results are 1) n.pop, 2) n.hs, 3) ks.pop, 4) ks.hs
nrows = 100*4*4*3*2
Disp.type = c("Complete mixing","All ages dispersal","Juvenile dispersal","No dispersal")
Exp.type = c('Spatially uniform','Moderate gradient','Extreme gradient','Spatially restricted')
Eff.type = c('Low','Med','High')
Comp.type = c('POP','HS')

KS_df = data.frame("Group" = rep(c(1:100),4*4*3*2),
                   "Dispersal"=rep(rep(Disp.type,each=100),4*3*2),
                   "Sampling"=rep(rep(Exp.type,each=100*4),3*2),
                   "Effort"=rep(rep(Eff.type,each=100*4*4),2),
                   "Comparison"=rep(Comp.type,each=100*4*4*3),
                   "p"=as.numeric(Det[,,,,3:4]))
KS_df$Effort = factor(KS_df$Effort,levels=Eff.type)
KS_df=KS_df[-which(is.na(KS_df$p)),]

library(ggplot2)
pdf("KS_results.pdf")
ggplot(KS_df)+ geom_boxplot(aes(x = Effort,y=p,fill=Comparison)) + 
  facet_grid(Dispersal~Sampling) + ylab('p-value') +
  theme(text=element_text(size=13))+scale_fill_manual(values=c('lightyellow','lightblue'))
dev.off()

mean(Det[,,,1,1])
mean(Det[,,,2,1])
mean(Det[,,,3,1])
mean(Det[,,,1,2])
mean(Det[,,,2,2])
mean(Det[,,,3,2])
