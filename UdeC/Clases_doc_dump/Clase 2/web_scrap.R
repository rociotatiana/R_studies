# Antes de chequear los paquetes, veremos si la pagina nos permite extraer info

library(robotstxt)

get_robotstxt("https://es.wikipedia.org/")

get_robotstxt("https://www.latercera.com/")

paths_allowed("https://www.latercera.com/etiqueta/re-constitucion/")

library(rvest)
library(dplyr)
library(stringr)
library(lubridate)
library(readr)
library(purrr)
library(tidyr)
library(ggplot2)

# Extraer el código html de la 1era pagina de la etiqueta feminismo en La Tercera.

html_p1 <- read_html("https://www.latercera.com/etiqueta/feminismo/page/1/")

titulares_pag1 <- html_p1 %>%
  html_nodes("h3") %>%
  html_text(trim = TRUE) %>% #recorta los excesos
  .[-1]

enlaces_p1 <- html_p1 %>%
  html_nodes("h3 a") %>%
  html_attr("href")

titulares_p1 <- tibble(titular = titulares_pag1,
       enlace_noticia = enlaces_p1) %>%
  mutate(enlace_noticia = paste0("https://www.latercera.com", enlace_noticia)) %>%
  separate(col = titular,
           into = c("seccion", "titular"),
           sep = "  ",
           extra = "merge")

# Escalemos el proceso

# Voy a escribir la funcion con "pseudo código

obtener_titulares <- function(numero_pagina) {
  # generar el enlace de la página
  
  enlace <- paste0("https://www.latercera.com/etiqueta/feminismo/page/", numero_pagina)
  
  # extraer el codigo html de esa pagina
  
  read_html(enlace)

  # extraer titulares y enlaces
  
  titulares <- html %>%
    html_nodes("h3") %>%
    html_text(trim = TRUE) %>% 
    .[-1]
  
  enlace <- html %>%
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

obtener_titulares(2)

# VERSION PROFE


obtener_titulares <- function(numero_pagina){
  # generar el enlace de la página
  Sys.sleep(2)
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

obtener_titulares(2)


titulares_p3 <- obtener_titulares(3)

# Qué pasa si quisieramos hacerlo con varias paginas a la vez?
map(1:3, obtener_titulares)

titulares_feminismo <- map_df(1:27, obtener_titulares)

# guardemo nuestra tabla

hoy <- today()

write_csv(titulares_feminismo, paste0("titulares_feminismo_", hoy, ".csv"))


#EXPLOREMOS LOS DATOS----

# cuales son las palabras que se utilizan con mas frecuencia en las noticias etiquetadas como "feminismo"?

#tokenizacion, un texto darle un valor
#bigramas

library(tidytext)

frecuentes_feminismo <- titulares_feminismo %>%
  unnest_tokens(input = titular, output = palabra) %>% # drop = FALSE si quiere mantener el titulo
  count(palabra, sort = TRUE) %>%
  anti_join(stopwords_espanol)

# paquetes stopwords español
tm::stopwords("es")

stopwords_espanol <- read_csv("https://raw.githubusercontent.com/7PartidasDigital/AnaText/master/datos/diccionarios/vacias.txt")

# Exploremos los bigramas

titulares_feminismo%>%
  unnest_tokens(input = titular, 
                output = bigrama,
                token = "ngrams",
                n = 2) %>%
  count(bigrama, sort = TRUE) %>%
  separate(bigrama,
           into = c("palabra1", "palabra2"),
           sep = "  ") %>%
  filter(!palabra1 %in% stopwords_espanol$palabra)%>%
  filter(!palabra2 %in% stopwords_espanol$palabra)%>%
  unite("bigrama", 
        col = palabra1:palabra2,
        sep = "  ")

# VERSION PROFE

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

bigramas_feminismo <- bigramas_feminismo%>%
  unite("bigrama",
        c(palabra1, palabra2),
        sep = " ")
bigramas_feminismo %>%
  slice_max(n, n = 10) %>%
  ggplot(aes(y = reorder(bigrama, n), n)) +
  geom_col() +
  labs(y = NULL)
