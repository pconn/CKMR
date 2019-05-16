# plot distance kernels, distance distributions for 

source("c:/users/paul.conn/git/ckmr/r/simulate_spatial.R")
library(mgcv)

#look at spatial distribution of matches relative to all other comparisons
#returns distance, age1, age2 - note idata indexes young, jdata indexes parents for POPs
get_distances <- function(samps,idata,jdata,Distances,POP=TRUE){
  most = samps[-c(idata,jdata),]
  n.dist = floor(nrow(most)/2)
  if(POP)n.col=3
  else n.col=2
  Null = matrix(NA,n.dist,n.col)
  Test = matrix(NA,length(idata),n.col)
  if(!POP)cat("Warning: Null distribution not implemented for half-sibs")
  
  Remain = c(1:nrow(most))
  for(i in 1:n.dist){
    Which = sample(c(1:length(Remain)),2)
    if(POP)Null[i,]=c(Distances[most[Remain[Which[1]],"STOCK"],most[Remain[Which[2]],"STOCK"]],most[Remain[Which[1]],"DA"],most[Remain[Which[2]],"DY"]-(most[Remain[Which[1]],"DY"]-most[Remain[Which[1]],"DA"]))
    #Null[i,]=c(Distances[most[Remain[Which[1]],"STOCK"],most[Remain[Which[2]],"STOCK"]],2*most[Remain[Which[1]],"DA"]+most[Remain[Which[2]],"DY"]-most[Remain[Which[1]],"DY"])
    Remain = Remain[-Which]
  }
  if(POP)for(i in 1:length(idata))Test[i,]=c(Distances[samps$STOCK[idata[i]],samps$STOCK[jdata[i]]],samps$DA[idata[i]],samps$DY[jdata[i]]-(samps$DY[idata[i]]-samps$DA[idata[i]]))
  if(!POP)for(i in 1:length(idata)){
    if((samps$DY[idata[i]]-samps$DA[idata[i]])<(samps$DY[jdata[i]]-samps$DA[jdata[i]])){ #i is oldest
      Test[i,]=c(Distances[samps$STOCK[idata[i]],samps$STOCK[jdata[i]]],2*samps$DA[idata[i]]+samps$DY[jdata[i]]-samps$DY[idata[i]])
    }
    else{
      Test[i,]=c(Distances[samps$STOCK[idata[i]],samps$STOCK[jdata[i]]],2*samps$DA[jdata[i]]+samps$DY[idata[i]]-samps$DY[jdata[i]])
    }
  }
  list(Null = Null, Test = Test)
}

n.stocks = 100 #make sure square
library(sp)
library(rgeos)
Locations = SpatialPoints(cbind(rep(c(1:sqrt(n.stocks)),each=sqrt(n.stocks)),rep(c(sqrt(n.stocks):1),sqrt(n.stocks))))
Distances = gDistance(Locations,byid=TRUE) #formulate distance matrix, assuming stocks are numbered from top to bottom


set.seed(1111)
Rand.sim = simulate_spatial(exp.type="constant",dispersal.type="all.ages",init.N=10000,samp.size=200,n.stocks=100)
Juv.sim = simulate_spatial(exp.type="constant",dispersal.type="juvenile",init.N=10000,samp.size=200,n.stocks=100)

sim_data = Rand.sim$sim_data

POP_dists = get_distances(sim_data$samps,sim_data$isamp_POP,sim_data$jsamp_POP,Distances)
MHS_dists = get_distances(sim_data$samps,sim_data$isamp_MHSP,sim_data$jsamp_MHSP,Distances,POP=FALSE)
PHS_dists = get_distances(sim_data$samps,sim_data$isamp_PHSP,sim_data$jsamp_PHSP,Distances,POP=FALSE)
#FS_dists = get_distances(sim_data$samps,sim_data$isamp_FSP,sim_data$jsamp_FSP,Distances)

#DF for ggplot   #maybe need to 
library(ggplot2)
Tmp = rbind(POP_dists$Null,POP_dists$Test)  
POP_df = POP_pred = data.frame(AgeO = Tmp[,2],DurP=Tmp[,3],Dist = Tmp[,1], Type = c(rep("Null",nrow(POP_dists$Null)),rep("Match",nrow(POP_dists$Test))))
POP_df = POP_df[which(POP_df$DurP>0),] # take out null matches that weren't possible due to age of parent
POP_glm <- glm(Dist ~ AgeO*DurP*Type,data=POP_df)
POP_glm_o <- glm(Dist ~ AgeO*Type,data=POP_df)
POP_glm_null <- glm(Dist ~ 1,data=POP_df)

POP_pred = expand.grid(AgeO=c(1:10),DurP=c(1:10),Type=c("Null","Match"))
POP_pred$Distance = predict(POP_glm,newdata=POP_pred)
contour_POP = ggplot(POP_pred)+geom_raster(aes(x=AgeO,y=DurP,fill=Distance))+facet_wrap(~Type)
contour_POP

DF = data.frame(Distance = POP_dists$Test[,1],AgeO=POP_dists$Test[,2],DurP=POP_dists$Test[,3])
match_glm = gam(Distance~s(AgeO,DurP),data=DF)
Pred = expand.grid(AgeO=c(1:10),DurP=c(1:10))
Pred$Distance = predict(match_glm,newdata=Pred)
contour_POP = ggplot(Pred)+geom_raster(aes(x=AgeO,y=DurP,fill=Distance))+
  theme(plot.title = element_text(hjust = -.1),text=element_text(size=14))+
  ggtitle("B. Age-independent dispersal")+xlab("Offspring age")+ylab("Adult age increment")
contour_POP

#alternatively two line plots: one for offspring, one for parents

#4 panel plot
#plot 1: histogram
dens_plot = ggplot(POP_df)+geom_density(aes(x=Dist,fill=Type),alpha=0.4,adjust=2)+
  xlab('Distance')+ylab('Density')+theme(plot.title = element_text(hjust = -.1),text=element_text(size=14))+scale_fill_manual( values = c("black","blue"))+
  ggtitle("A. Distance distributions")
#plot 2: movement kernels - Gaussian and Laplace
kernel_df = data.frame(Distance = rep(c(0:99)/10,2),Kernel=c(rep("Gaussian",100),rep("Exponential",100)),Density=rep(0,200))
kernel_df$Density[1:100]=dnorm(kernel_df$Distance[1:100],0,2)
kernel_df$Density[101:200]=dexp(kernel_df$Distance[101:200],0.3)
kernel_df$Density[1:100]=kernel_df$Density[1:100]/sum(kernel_df$Density[1:100])
kernel_df$Density[101:200]=kernel_df$Density[101:200]/sum(kernel_df$Density[101:200])
kernel_plot = ggplot(kernel_df)+geom_line(size=1.2,aes(x=Distance,y=Density,linetype=Kernel))+
  theme(plot.title = element_text(hjust = 0),text=element_text(size=14),axis.text.y=element_blank(),axis.ticks.y=element_blank())+scale_color_manual( values = c("darkgreen","brown"))+
  ggtitle("B. Movement kernels")+theme(legend.key.width = unit(0.8, "cm"))
kernel_plot

###random dispersal: parent, offspring, half-sib cumulative distance
P_glm = gam(log(Distance+.01)~s(DurP,k=4),data=DF)
O_glm = gam(log(Distance+.01)~s(AgeO,k=4),data=DF)
Pred = data.frame(AgeO= matrix(c(1:100)/10,100,1))
Pred$DurP = Pred$AgeO
Pred$DurP2 = Pred$AgeO2 = Pred$AgeO^2
DistP = predict(P_glm,newdata=Pred)
DistO = predict(O_glm,newdata=Pred)
DF_HS = data.frame(Distance = c(MHS_dists$Test[,1],PHS_dists$Test[,1]),AgeO=c(MHS_dists$Test[,2],PHS_dists$Test[,2]))
HS_glm = gam(log(Distance+.01)~s(AgeO,k=4),data=DF_HS)
DistHS = predict(HS_glm,newdata=Pred)
Plot_df = data.frame(Distance = exp(c(DistP,DistO,DistHS)),Type=rep(c("Parent","Offspring","Half-Sib"),each=100),Time = rep(Pred$AgeO,3))
dist_plot = ggplot(Plot_df)+geom_line(size=1.2,aes(x=Time,y=Distance,linetype=Type))+
  theme(plot.title = element_text(hjust = 0),text=element_text(size=14))+scale_color_manual( values = c("darkgreen","brown"))+
  ggtitle("C. Random dispersal")+ theme(legend.key.width = unit(0.8, "cm"))+ylim(c(0,4))
dist_plot


### juvenile dispersal
sim_data = Juv.sim$sim_data
set.seed(1234)
POP_dists = get_distances(sim_data$samps,sim_data$isamp_POP,sim_data$jsamp_POP,Distances)
MHS_dists = get_distances(sim_data$samps,sim_data$isamp_MHSP,sim_data$jsamp_MHSP,Distances,POP=FALSE)
PHS_dists = get_distances(sim_data$samps,sim_data$isamp_PHSP,sim_data$jsamp_PHSP,Distances,POP=FALSE)
DF = data.frame(Distance = POP_dists$Test[,1],AgeO=POP_dists$Test[,2],DurP=POP_dists$Test[,3])
DF$AgeO2=DF$AgeO^2
DF$DurP2=DF$DurP^2
DF_HS = data.frame(Distance = c(MHS_dists$Test[,1],PHS_dists$Test[,1]),AgeO=c(MHS_dists$Test[,2],PHS_dists$Test[,2]))
DF_HS$AgeO2=DF_HS$AgeO^2
HS_glm = gam(log(Distance+0.01)~s(AgeO),data=DF_HS)
P_glm = gam(log(Distance+0.01)~s(DurP),data=DF)
O_glm = gam(log(Distance+0.01)~s(AgeO),data=DF)
DistP = predict(P_glm,newdata=Pred)
DistO = predict(O_glm,newdata=Pred)
DistHS = predict(HS_glm,newdata=Pred)
Plot_df = data.frame(Distance = exp(c(DistP,DistO,DistHS)),Type=rep(c("Parent","Offspring","Half-Sib"),each=100),Time = rep(Pred$AgeO,3))
dist_plot_j = ggplot(Plot_df)+geom_line(size=1.2,aes(x=Time,y=Distance,linetype=Type))+
  theme(plot.title = element_text(hjust = 0),text=element_text(size=14))+scale_color_manual( values = c("darkgreen","brown"))+
  ggtitle("D. Juvenile dispersal")+ theme(legend.key.width = unit(0.8, "cm"))+ylim(c(0,2))
dist_plot_j

match_glm = gam(Distance~s(AgeO,DurP),data=DF)
Pred = expand.grid(AgeO=c(1:10),DurP=c(1:10))
Pred$Distance = predict(match_glm,newdata=Pred)
contour_POP_j = ggplot(Pred)+geom_raster(aes(x=AgeO,y=DurP,fill=Distance))+
  theme(plot.title = element_text(hjust = -.1),text=element_text(size=14))+
  ggtitle("C. Juvenile dispersal")+xlab("Offspring age")+ylab("Adult age increment")
contour_POP_j

library(grid)
library(gridExtra)
library(lattice)
pdf("distance_fig.pdf",width=4,height=8)
  grid.arrange(dens_plot,contour_POP,contour_POP_j,ncol=1)
dev.off()


