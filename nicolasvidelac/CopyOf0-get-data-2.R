#' Referencia:
#' Este script fue extraido de la iniciativa datos de miércoles 
#' https://github.com/cienciadedatos/datos-de-miercoles/tree/master/datos/2019/2019-05-15
#' Y modificado/comentado para la iniciativa de este trabajo

# install.packages("Rspotify")
# install.packages("httpuv")
# install.packages("tidyverse")

library(Rspotify)
library(tidyverse)


## Conexion spotify

app_id <- 'AM2019' # el nombre que pusiste en la aplicacion
client_id<- '4809ca564f8d4cbcbc32a50af5840dfb' # el client id que figura en la web de spotify
client_secret <- '62a3cd3170b44335b740832882c650c4' # el client secret que figura en la web de spotify

keys <- spotifyOAuth(app_id, client_id, client_secret)

## Obtener las listas de top 50

# devuelve de a maximo 50.
user_playlists_1 <- getPlaylists("qn9el801z6l32l2whymqqs18p", token = keys)

# sigo del 51 en adelante ( ignora los primeros 50 )
user_playlists_2 <- getPlaylists("qn9el801z6l32l2whymqqs18p", offset = 50, token = keys)

# aparte se encuentra el de Venezuela
user_playlists_3 <- data.frame(id="624oAiyjMdmpdJWIylharU",name="El Top 50 de Venezuela",ownerid="suo2sbl91eeth3elwrfuq7qwn",tracks=50,stringsAsFactors = FALSE)

# junto todo
usr_playlist_total <- user_playlists_1 %>%
  union_all(user_playlists_2) %>%
  union_all(user_playlists_3) %>%
  rename(lista_id=id,
         nombre=name,
         quien_lista_id=ownerid,
         cantidad_canciones=tracks)

## filtrado top 50 a paises habla hispana

paises_es <- c("Argentina", "Bolivia", "Chile", "Colombia", "Costa Rica",
               "Cuba","la Republica Dominicana", "Dominican Republic",
               "Ecuador", "El Salvador", "Equatorial Guinea", "España",
               "Guatemala", "Honduras", "México", "Nicaragua", "Panamá",
               "Paraguay", "Perú", "Puerto Rico", "Uruguay", "Venezuela")

top_50_total <- usr_playlist_total %>%
  mutate(pais_nombre=str_remove(nombre, "El Top 50 de "))

top_50_total_es <- top_50_total %>%
  filter(pais_nombre %in% paises_es)


## Expando top 50 a paises habla hispana
## Obtengo de cada playlista las canciones

# para pre procesar la lista de canciones
top_50_total_es_canciones_nested <- top_50_total_es %>%
  # la función mutate agrega una columna dataframe
  mutate(canciones_lista =  purrr::pmap(.l=list(user_id=quien_lista_id,
                                                playlist_id=lista_id),
                                        .f=getPlaylistSongs,
                                        token=keys))
# modifico los dataframe y luego los expando
top_50_total_es_canciones <- top_50_total_es_canciones_nested %>%
  mutate(canciones_lista_con_puesto= purrr::map(canciones_lista,.f=function(top_50_param){
    top_50_resultado <- top_50_param %>% # al parametro que me llega
      mutate(cancion_numero=row_number()) %>% # agrego numero de top
      mutate(cancion_top=paste0(artist_full,' - ',tracks)) %>%  # agrego el nombre de la cancion con el artista full.
      rename(cancion_nombre=tracks,
             cancion_id=id,
             cancion_popularidad=popularity,
             cancion_artista=artist,
             cancion_artista_completo=artist_full,
             cancion_artista_id=artist_id,
             cancion_album=album,
             cancion_album_id=album_id)#cambio nombres columnas#
    top_50_resultado # el resultado que se va a devolver
  })) %>%
  unnest(canciones_lista_con_puesto) # expando el dataframe.

# Para saber sobre las funciones mutate, filter, select, rename y demás, ver dplyr package
# https://dplyr.tidyverse.org/
# Para saber sobre las funciones map, unnest y demás, ver purrr package
# https://purrr.tidyverse.org/index.html

## features de las canciones
# Ahora de cada una de las canciones extraemos sus features
# Más info de las features 
# ver https://developer.spotify.com/documentation/web-api/reference/object-model/#audio-features-object

top_50_total_es_canciones_features <- top_50_total_es_canciones %>%
  mutate(cancion_features =  purrr::map(.x=cancion_id,
                                        .f=getFeatures,
                                        token=keys))


top_50_total_es_canciones_features_unnested <- top_50_total_es_canciones_features %>%
  unnest(cancion_features) %>%
  rename(feature_id=id,
         feature_bailabilidad=danceability,
         feature_energia=energy,
         feature_clave=key,
         feature_fuerza=loudness,
         feature_modo=mode,
         feature_hablabilidad=speechiness,
         feature_acusticidad=acousticness,
         feature_instrumenabilidad=instrumentalness,
         feature_vivacidad=liveness,
         feature_valencia=valence,
         feature_tempo=tempo,
         feature_duracion_ms=duration_ms,
         feature_firma_temporal=time_signature,
         feature_uri=uri,
         feature_analisis_url=analysis_url)


## obtener informacion del album de cada canción


# para ahorrar queries: buscamos 1 sola vez la info de los albums
albums_info <- top_50_total_es_canciones_features_unnested %>%
  select(cancion_album_id) %>% # los album id
  distinct() %>% # unicos
  mutate(album_info=purrr::map(.x=cancion_album_id,
                               .f=getAlbumInfo,
                               token=keys))

albums_info_expandido <- albums_info %>%
  mutate(fechas=purrr::map(.x=album_info,
                           .f=function(album_inf_param){
                             album_inf_resu <- album_inf_param %>%
                               select(release_date) %>% # columna 6
                               head(1) %>% # el 1ro
                               pull() %>% # extraer
                               as.character() # como char
                             album_inf_resu # resu
                           })) %>%
  unnest(fechas)


albums_info_expandido_para_cruce <- albums_info_expandido %>% select(cancion_album_id,fechas)

#Cruzamos canciones con albums
top_50_total_es_canciones_featuress_albums <- top_50_total_es_canciones_features_unnested %>%
  left_join(albums_info_expandido_para_cruce, by = "cancion_album_id")


## seleccion final de columnas

top_50_total_es_para_desafio  <-  top_50_total_es_canciones_featuress_albums %>%
  select(-lista_id,-quien_lista_id,-cancion_id, -cancion_artista_id,-cancion_album_id,
         -feature_id, -feature_uri, -feature_analisis_url)

# aca dice como toman el atributo "valence"
# https://community.spotify.com/t5/Content-Questions/Valence-as-a-measure-of-happiness/td-p/4385221
# para entender las features de cada canción, 
# ver https://developer.spotify.com/documentation/web-api/reference/object-model/#audio-features-object

top_50_total_es_para_desafio  <- top_50_total_es_para_desafio %>%
  rename(feature_acustico = feature_acusticidad,
         feature_hablado=feature_hablabilidad,
         feature_instrumental=feature_instrumenabilidad,
         feature_en_vivo=feature_vivacidad,
         feature_positividad=feature_valencia,
         feature_tiempo_compas=feature_firma_temporal,
         album_fecha=fechas)

top_50_total_es_para_desafio_final <- top_50_total_es_para_desafio %>%
  select(cancion_nombre,cancion_popularidad,cancion_artista,cancion_artista_completo,
         cancion_album,cancion_numero,pais_nombre,
         feature_bailabilidad,feature_energia,feature_clave,
         feature_fuerza,feature_modo,feature_hablado,feature_acustico,
         feature_instrumental,feature_en_vivo,feature_positividad,feature_tempo,
         feature_duracion_ms,feature_tiempo_compas,album_fecha)



## para darle un a mirada a los datos
# install.packages("skimr")
# skimr::skim(top_50_total_es_para_desafio_final)

# o con el paquete DataExplorer
# install.packages("DataExplorer")
# library(DataExplorer)

## Para guardar el resultado:: WARN !

write.csv(top_50_total_es_para_desafio_final,"dataset.csv")

# WARN! CUIDADO! no se puede subir a GitHub por tema de condiciones de spotify.
# por eso se usa la api y el tutorial de la api

