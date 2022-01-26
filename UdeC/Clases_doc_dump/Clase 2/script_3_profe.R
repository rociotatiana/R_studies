# Script clase 4 (02/07/2021): web scraping
# enlace a este archivo: https://www.dropbox.com/s/5xvq33ikxf2z7fs/script.R?dl=0

# Chequear si la página nos autoriza a extraer información
library(robotstxt)
get_robotstxt("https://www.wikipedia.org/")
paths_allowed("https://es.wikipedia.org/wiki/Los_%C3%81ngeles")

# Vamos ahora con La Tercera

get_robotstxt("https://www.latercera.com/")
paths_allowed("https://www.latercera.com/etiqueta/feminismo")

# Paquetes ----
library(rvest)
library(dplyr)
library(stringr)
library(lubridate)
library(readr)
library(purrr)
library(tidyr)

# Extraer el código html de la primera página de la etiqueta feminismo en La Tercera

html_p1 <- read_html("https://www.latercera.com/etiqueta/feminismo/page/1/")

titulares_p1 <- html_p1 %>% 
  html_nodes("h3") %>% 
  html_text(trim = TRUE) %>% 
  .[-1]

enlaces_p1 <- html_p1 %>% 
  html_nodes("h3 a") %>% 
  html_attr("href")

titulares_p1 <- tibble(titular = titulares_p1,
                       enlace_noticia = enlaces_p1) %>% 
  mutate(enlace_noticia = paste0("https://www.latercera.com", enlace_noticia)) %>% 
  separate(col = titular,
           into = c("seccion", "titular"),
           sep = "  ",
           extra = "merge")

# Escalemos el proceso

# Voy a escribir la función con "pseudo código" primero.

obtener_titulares <- function(numero_pagina){
  
  Sys.sleep(2)
  
  # generar el enlace de la página
  enlace <- paste0("https://www.latercera.com/etiqueta/feminismo/page/", numero_pagina)
  
  # extraer el código html de esa página
  html <- read_html(enlace)
  
  # extraer titulares y enlaces
  
  titulares <- html %>% 
    html_nodes("h3") %>% 
    html_text(trim = TRUE) %>% 
    .[-1]
  
  enlaces <- html %>% 
    html_nodes("h3 a") %>% 
    html_attr("href")
  
  # generar la tabla
  
  tibble(titular = titulares,
         enlace_noticia = enlaces) %>% 
    mutate(enlace_noticia = paste0("https://www.latercera.com", enlace_noticia)) %>% 
    separate(col = titular,
             into = c("seccion", "titular"),
             sep = "  ",
             extra = "merge")
}

# Probemos nuestra función

titulares_p3 <- obtener_titulares(3)

# Qué pasa si quisiéramos hacerlo con varias páginas a la vez: iterar con las funciones map

ejemplo_map <- map(1:3, obtener_titulares)
ejemplo_map_df <- map_df(1:3, obtener_titulares)

# Ahora sí, probemos extraer las 27 páginas

titulares_feminismo <- map_df(1:27, obtener_titulares)

# guardemos nuestra tabla

hoy <- today()
write_csv(titulares_feminismo, paste0("titulares_feminismo_", hoy, ".csv"))

# Exploremos estos datos ----
# ¿Cuáles son las palabras que se utilizan con más frecuencia en las noticias etiquetadas como "feminismo" en La Tercera en línea? 
# Vamos a activar un par de paquetes adicionales
library(tidytext)
library(ggplot2)

# necesitamos stopwords
# algunos paquetes traen stopwords para el español
tm::stopwords("es")

# sino, podemos importarlas de listas que otras personas ya crearon
stopwords_espanol <- read_csv("https://raw.githubusercontent.com/7PartidasDigital/AnaText/master/datos/diccionarios/vacias.txt")

head(stopwords_espanol)

frecuentes_feminismo <- titulares_feminismo %>% 
  unnest_tokens(input = titular, output = palabra) %>% 
  count(palabra, sort = TRUE) %>% 
  anti_join(stopwords_espanol)

# exploremos los bigramas

bigramas_feminismo <- titulares_feminismo %>% 
  unnest_tokens(input = titular,
                output = bigrama,
                token = "ngrams",
                n = 2) %>% 
  count(bigrama, sort = TRUE) %>% 
  separate(bigrama,
           into = c("palabra1", "palabra2"),
           sep = " ") %>% 
  filter(!palabra1 %in% stopwords_espanol$palabra) %>% 
  filter(!palabra2 %in% stopwords_espanol$palabra) 


bigramas_feminismo <- bigramas_feminismo %>% 
  unite("bigrama",
        c(palabra1, palabra2),
        sep = " ")


bigramas_feminismo %>% 
  slice_max(n, n = 10) %>% 
  ggplot(aes(y = reorder(bigrama, n), n)) +
  geom_col() +
  labs(y = NULL)