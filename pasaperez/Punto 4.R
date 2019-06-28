library(clustertend)
library(dbscan)
library(factoextra)
library("plot3Drgl")
library("plot3D")
library("fpc")
library("GGally")
library(ggplot2)
library(tidyverse)
library(gapminder)
library(DataExplorer)

ds1<-read.csv("./dspreprocesado.csv") %>% select(2:13)
ds<-ds1

rge <- apply(ds1[,c(10,12)],2,min)
ds[,c(10,12)] <- sweep(ds1[,c(10,12)],2, rge, FUN="/")
ds[,10]<-ds1[,10]
rge2 <- apply(ds1[,c(4,5,11)],2,max)
ds[,c(4,5,11)] <- sweep(ds1[,c(4,5,11)],2, rge2, FUN="/")
x1<-array(dim = c(900,3))
x1[,1]<-as.integer(ds[,1])
x1[,2]<-as.integer(ds[,2])
x1[,3]<-as.integer(ds[,3])
rge3<-apply(x1,2,max)
ds[,c(1:3)] <- sweep(x1,2, rge3, FUN="/")
ds2<-ds
ds<-scale(ds, center = TRUE, scale = TRUE)

#Entre 1 y 200

for (ver in c(200, 100, 50, 25, 13)) 
{
  k.list <- c(1:ver)
  tw<- NULL
  tw <- vector()
  tw<- c(tw, 0)
  for(k in k.list)
  {
    km<-kmeans(x=ds, centers = k, iter.max = 128)
    tw<-c(tw, km$tot.withinss)
  }
  plot(c(0,k.list),tw,type="b")
}

#Entre 1 y 20

k<-NULL
k<-list()
betw<-NULL
betw<-list()
for (kme in 1:20)
{
  k[[kme]]<-kmeans(ds, centers = kme, iter.max = 128)
  betw[[kme]]<-k[[kme]]$betweenss/(k[[kme]]$totss)
}
plot(1:20, betw, type = "b")

#Entre 1 y 10

k<-NULL
k<-list()
betw<-NULL
betw<-list()
for (kme in 1:15) 
{
  k[[kme]]<-kmeans(ds, centers = kme, iter.max = 128)
  betw[[kme]]<-k[[kme]]$betweenss/(k[[kme]]$totss)
}
plot(1:15, betw, type = "p")
#4, 5, 6, 7, 11, 12 y 13

fviz_nbclust(x = ds, FUNcluster = pam, method = "wss", k.max = 200, diss = dist(ds, method = "manhattan"))
#6, 7, 12 y 13

p<-NULL
p<-vector()
for (n_clusters in 1:20) 
{
  p1<-cluster::pam(x = ds, k = n_clusters, metric = "manhattan")
  p<-c(p, p1$objective["swap"])
}
plot(1:20,p)

#5, 6 y 7

########################

fviz_cluster(p, ds)

hc_euclidea_completo <- hclust(d = dist(x = ds, method = "euclidean"),
                               method = "complete")
fviz_dend(x = hc_euclidea_completo, cex = 0.5, main = "Linkage completo",
          sub = "Distancia euclídea")

#5
hcluster<-cutree(hc_euclidea_completo, k=5)
plot(1:900, hcluster)
hkmeans_cluster <- hkmeans(x = ds, hc.metric = "euclidean", hc.method = "complete", k = 5)
fviz_cluster(object = hkmeans_cluster)

clus<-NULL
clus<-vector()
for (punt in 1:30) 
{
  dbscan::kNNdistplot(ds, k = punt)
}
#eps entre 2 y 4
for (punt in 0:30) 
{
  datasca<-fpc::dbscan(ds, eps = 3, MinPts = punt, showplot = 0)
  clus<-c(clus,max(datasca$cluster))
}

plot(0:30, clus)
#Entre 3 y 5 con 1
#Entre 4 y 5 con 1.5
#Entre 4 y 5 con 2
#5 con 3

fuzzy_cluster <- fanny(x = ds, diss = FALSE, k = 5, metric = "euclidean", stand = FALSE)
fviz_cluster(object = fuzzy_cluster, repel = TRUE, ellipse.type = "norm", pallete = "jco")

fviz_pca_ind(X = prcomp(ds), geom = "point", title = "PCA - ds", pallete = "jco")
H<-hopkins(data = ds, n = nrow(ds)-1)
fviz_dist(dist.obj = dist(ds, method = "euclidean"), show_labels = FALSE) +
  labs(title = "Datos iris") + theme(legend.position = "bottom")


scatter2D(as.integer(ds[,1]), as.integer(ds[,2]),colvar = as.integer(ds[,3]), theta = 45, phi = 30)
scatter3D(ds[,7], ds[,8], ds[,9],colvar = as.integer(ds[,3]), theta = 45, phi = 30)
plot3d(ds[1:900,3], ds[1:900,5], ds[1:900,10])
plotrgl()