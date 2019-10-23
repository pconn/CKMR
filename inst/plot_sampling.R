# plot sampling probability
library(ggplot2)
library(RColorBrewer)

Pred1 = Pred2 = Pred3 = Pred4 = expand.grid(Easting=c(1:10),Northing=c(1:10))
Pred1$Probability=1

strata_probs = rep(0,100)
for(i in 1:10){
  strata_probs[10*(i-1)+c(1:10)]=(i-1)*2/90+.2
}
Pred2$Probability=strata_probs/max(strata_probs) #normalize

strata_probs = rep(0,100)
for(i in 1:10){
  strata_probs[10*(i-1)+c(1:10)]=i*.1
}
Pred3$Probability=strata_probs/max(strata_probs) #normalize

strata_probs = rep(0,100)
strata_probs[91:100]=0.4
strata_probs[81:90]=0.2
strata_probs[71:80]=0.1
Pred4$Probability=strata_probs/max(strata_probs) #normalize


random_plot = ggplot(Pred1)+geom_raster(aes(x=Easting,y=Northing,fill=Probability))+
  theme(text=element_text(size=14),plot.title = element_text(hjust = -.1))+ggtitle("A. Spatially uniform")+
  scale_fill_distiller(limits=c(0,1),palette="BuPu")

random_plot

moderate_plot = ggplot(Pred2)+geom_raster(aes(x=Easting,y=Northing,fill=Probability))+
  theme(text=element_text(size=14),plot.title = element_text(hjust = -.1))+ggtitle("B. Moderate gradient")+
  scale_fill_distiller(limits=c(0,1),palette="BuPu")

moderate_plot

extreme_plot = ggplot(Pred3)+geom_raster(aes(x=Easting,y=Northing,fill=Probability))+
  theme(text=element_text(size=14),plot.title = element_text(hjust = -.1))+ggtitle("C. Extreme gradient")+
  scale_fill_distiller(limits=c(0,1),palette="BuPu")

extreme_plot

refugia_plot = ggplot(Pred4)+geom_raster(aes(x=Easting,y=Northing,fill=Probability))+
  theme(text=element_text(size=14),plot.title = element_text(hjust = -.1))+ggtitle("D. Spatially restricted")+
  scale_fill_distiller(limits=c(0,1),palette="BuPu")

refugia_plot

library(grid)
library(gridExtra)
library(lattice)
pdf("sampling_fig2.pdf",width=8,height=6)
grid.arrange(random_plot,moderate_plot,extreme_plot, refugia_plot,ncol=2)
dev.off()
