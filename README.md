# am2019-spotify

Consignas para el trabajo final de la cátedra Aprendizaje automático UTN Mendoza

# 1- Git 
  
1 - Cree una cuenta en GitHub, le servirá más adelante para la entrega.
 
2 - Instale Git en su máquina

3 - Realice un fork de este repositorio. Trabaje sobre su repositorio actualizándolo usando git add, git commit y git push. Para más información sobre como trabajar con Git + R o una introducción gentil a Git, ver el libro [Happy Git with R](https://happygitwithr.com/)

4 - Orden sobre como trabajar.

* Cree una carpeta con cuyo nombre siga el siguiente formato APELLIDO-NOMBRE-userGitHub , ejemplo PANZA-SANCHO-pancita **WARNING**
* Mueva el script 0-get-data-2.R a esa carpeta. 
* Recuerde: creará todos sus scripts, notebooks, etc en dicha carpeta.

# 2- Descarga de datos

Para obtener los datos deberás seguir estos 3 sencillos pasos:

- Hacer una App de Spotify Developer [aquí](https://developer.spotify.com/dashboard) (puedes seguir las imágenes en [estas instrucciones en inglés](https://r-music.rbind.io/posts/2018-10-01-rspotify/)):
    -   Crea una cuenta si no tienes una
    -   Crea una app con el nombre que quieras. Recuerda este nombre, es el `app-id` que vamos a utilizar luego. Escoge Website entre las opciones y declara que la app NO ES COMERCIAL (en nuestro caso, no lo es).
    -   Copia tu `client ID` y tu `client Secret`.
    -   Haz clic en "Edit settings" y cambia Redirect URLs a <http://localhost:1410/> .
- Instala los paquetes `tidyverse`, `Rspotify` y `httpuv` si no los tienes (con `install.packages`).

- En el código de `0-get-data.R`, cambia en la línea donde se definen la variable `keys` los valores de `app_id`, `client_id` y `client_secret` por tus datos (línea 17. contando los saltos de línea).

- Corre el código `0-get-data.R`. Dependiendo de tu conexión, tardará en ejecutarse unos 4 minutos.

# 3- Análisis descriptivo exploratorio

Realice un análisis descriptivo exploratorio (EDA en inglés) sobre los datos.

Puede encontrar ejemplos de como realizarlo [en este capítulo de r4ds](https://r4ds.had.co.nz/exploratory-data-analysis.html).

Debe explicar el significado de las features de las canciones en este apartado.

Debe realizar al menos tres gráficos con ggplot2.

**BONUS**: realizar más de tres (3) gráficos con ggplot2.

# 4- Clustering

Emplee un algoritmo de clustering sobre las *features* de las canciones. 

Justifique las elecciones para su diseño (algoritmo, features a utilizar, creación de nuevas features, pre-procesamiento,etc).

**BONUS**: usar más de un algoritmo de clustering

# 5 - Conclusiones y evaluación de resultados

* Analice los resultados de los puntos anteriores.
* Escriba conclusiones generales del trabajo.

# 6 - Entrega

Mediante pull request a este repo.
**DEADLINE TODO**

# 6 - Referencias

| Enlace | Descripción |
| --- | --- |
| [:link:](https://github.com/cienciadedatos/datos-de-miercoles/tree/master/datos/2019/2019-05-15) | Datos de miércoles con Rspotify |
| [:link:](http://es.r4ds.hadley.nz/) | Traducción (en proceso) al español de "R for Data Science" |
| [:link:](https://happygitwithr.com/) | Happy Git with R |
| [:link:](https://r-music.rbind.io/) | Blog del paquete Rspotify |
| [:link:](https://dplyr.tidyverse.org/) | Dplyr, manipulacion datos, Hoja machete |
| [:link:](https://purrr.tidyverse.org/) | Purrr, toolkit programación funcional, funciones sobre arreglos/data.frames|


# Enlaces extras

| Enlace | Descripción |
| --- | --- |
| [:link:](http://r4ds.had.co.nz/) | El libro "R for Data Science" en inglés |
| [:link:](https://serialmentor.com/dataviz/) | Libro: Fundamentals of data visualization|
| [:link:](https://adv-r.hadley.nz/) | Libro: Advanced R |
| [:link:](https://r-graphics.org/) | Libro: R Graphics Cookbook, 2nd edition |
| [:link:](https://bookdown.org/csgillespie/efficientR/) | Libro: Efficient R programming |






