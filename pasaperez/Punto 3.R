library("GGally")
library(ggplot2)
library(tidyverse)
library(gapminder)
library(DataExplorer)

dsspotify<-read.csv("./dataset_spotify.csv")
resumen<-summary(dsspotify)

numerovariable<-ncol(dsspotify)
numeroobjetorig<-nrow(dsspotify)

variables<-colnames(dsspotify)
variablestructura<-plot_str(dsspotify)

cajafechas<-boxplot(as.Date(dsspotify$fecha))
cajasvariables<-plot_boxplot(data = dsspotify[,c("volumen","nota_musical","en_vivo","tempo","tiempo_compas", "top_pais")], by = "top_pais")
correlavariables<-plot_correlation(dsspotify, maxcat = 0)

prepros1<-dsspotify %>% filter(puesto<=50)
numeroobje<-nrow(prepros1)
columnasprepro2<-c(2,4,7,8,3,9,10,14,15,18,20,12)
prepros2<-prepros1 %>% select(columnasprepro2)

correlacvariapreprose<-plot_correlation(prepros2[,-5], maxcat = 0)
grafirealgorit <- ggpairs(prepros2, mapping = aes(color = top_pais), columns = 
                  colnames(prepros2[,4:5]),cardinality_threshold = 20); grafirealgorit #Top-Popul

grafivar <- ggpairs(prepros2, mapping = aes(color = top_pais), 
                    columns = colnames(prepros2)[-c(1:2,5)],cardinality_threshold = 20); grafivar
grafiusar <- ggpairs(prepros2, mapping = aes(color = top_pais), 
                    columns = colnames(prepros2)[c(4,6:12)],cardinality_threshold = 20); grafiusar

grafiartishisto <- ggpairs(prepros2, mapping = aes(color = top_pais), 
                     columns = colnames(prepros2)[c(2)],cardinality_threshold = 300); grafiartishisto
graficanchisto <- ggpairs(prepros2, mapping = aes(color = top_pais), 
                      columns = colnames(prepros2)[c(1)],cardinality_threshold = 300); graficanchisto

graficancion<-plot_scatterplot(prepros2[1:5], by = "cancion")
grafiartista<-plot_scatterplot(prepros2[1:5], by = "artista")

toppaises<-prepros2 %>% select(top_pais) %>% distinct(top_pais)
paises<-substring(as.character(toppaises[1:18,]), 14)
canciones<-prepros2 %>% select(cancion) %>% distinct(cancion)
artistas<-prepros2 %>% select(artista) %>% distinct(artista)