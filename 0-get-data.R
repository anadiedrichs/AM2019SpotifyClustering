#' Referencia:
#' Este script fue extraido de la iniciativa datos de miércoles 
#' https://github.com/cienciadedatos/datos-de-miercoles/tree/master/datos/2019/2019-05-15
#' 
#' Siga las instrucciones del sitio anterior para crear cuenta en API de spotify
########### Extraer Top 50 ############
#' Con este script se extraen el Top 50 de cada país latinoamericano, y de allí sus canciones, de las canciones sus features.
#' 
# install.packages("Rspotify")
# install.packages("tidyverse")
# install.packages("httpuv")
library(Rspotify)
library(tidyverse)

# app_id es el nombre de la apylicación que creaste
# client_id y client_secret, son keys de la api de spotify
app_id <- 'appspot' # el nombre que pusiste en la aplicacion
client_id<- '82855c5e46bc4807958f062d0355fb95' # el client id que figura en la web de spotify
client_secret <- 'cbf43565e92a4ae4bef55c06e55ae153' # el client secret que figura en la web de spotify

keys <- spotifyOAuth(app_id, client_id, client_secret)

paises_es <- c("Argentina", "Bolivia", "Chile", "Colombia", "Costa Rica",
               "Cuba","la Republica Dominicana", "Dominican Republic",
               "Ecuador", "El Salvador", "Equatorial Guinea", "España",
               "Guatemala", "Honduras", "México", "Nicaragua", "Panamá",
               "Paraguay", "Perú", "Puerto Rico", "Uruguay", "Venezuela")
user_playlists_1 <- getPlaylists("qn9el801z6l32l2whymqqs18p", token = keys)
user_playlists_2 <- getPlaylists("qn9el801z6l32l2whymqqs18p", 50, token = keys)
tops_50 <- rbind(user_playlists_1, user_playlists_2)
# encontré aparte el de venezuela que no estaba incluido
tops_50 <- rbind(tops_50, c("624oAiyjMdmpdJWIylharU", "El Top 50 de Venezuela", "suo2sbl91eeth3elwrfuq7qwn", 50))

paises <- purrr::map_chr(tops_50$name, ~ str_remove(.x, "El Top 50 de "))
bool_es <- purrr::map_lgl(paises, ~ .x %in% paises_es)
tops_50_es <- tops_50[bool_es, ]

viralcharts_user = "qn9el801z6l32l2whymqqs18p"

canciones_tops50_es <- purrr::map(tops_50_es$id[-length(tops_50_es$id)],
                                  ~ getPlaylistSongs(user_id = viralcharts_user,
                                                     .x,
                                                     token = keys))
canciones_tops50_es[[18]] <- getPlaylistSongs(user_id = "suo2sbl91eeth3elwrfuq7qwn",
                                              "624oAiyjMdmpdJWIylharU",
                                              token = keys)

dataset_canciones = tibble()
for (i in 1:length(canciones_tops50_es)) {
  dataset_canciones = rbind(dataset_canciones, cbind(canciones_tops50_es[[i]],
                                                     top = as.character(tops_50_es$name)[i],
                                                     numero = 1:nrow(canciones_tops50_es[[i]])))
}
features_canciones = tibble()
for (j in 1:nrow(dataset_canciones)) {
  features_canciones = rbind(features_canciones,
                             getFeatures(dataset_canciones$id[j], keys))
}
dataset_spotify = cbind(dataset_canciones, features_canciones)

fechas = purrr::map(unique(dataset_spotify$album_id), ~getAlbumInfo(.x, keys)[1, 6])
album_fechas =  tibble(album_id = unique(dataset_spotify$album_id),
                       fecha = as.character(unlist(fechas)))
dataset_spotify = dataset_spotify[, -2] %>%
  left_join(album_fechas, by = "album_id")

dataset_spotify = dataset_spotify %>%
  select(-id, -artist_id, - album_id, -uri, -analysis_url)

nombres_columnas = c("cancion", "popularidad", "artista", "artista_completo",
                     "album", "top_pais", "puesto", "bailabilidad", "energia",
                     "nota_musical", "volumen", "modo", "hablado", "acustico",
                     "instrumental","en_vivo", "positividad", "tempo",
                     "duracion", "tiempo_compas", "fecha")

# para entender las features de cada canción, 
# ver https://developer.spotify.com/documentation/web-api/reference/object-model/#audio-features-object

colnames(dataset_spotify) <- nombres_columnas

# guardamos dataset final
# WARNING!!! NO subas el dataset a GitHub, por condiciones de servicio. 
write.csv(dataset_spotify,"dataset_spotify.csv")
