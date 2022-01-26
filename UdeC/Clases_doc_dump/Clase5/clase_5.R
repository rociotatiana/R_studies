#Sersión 5: ejercicios de limpieza y transformación de datos + CASEN

library(dplyr)
library(readxl)
library(tidyr)
library(stringr)
library(janitor)
library(ggplot2)
library (haven)

install.packages("janitor")

##1. Transformación de datos (y un poquito de limpieza) ---

encuesta_colores <- read_excel("encuesta-colores.xlsx")
head(encuesta_colores, n = 12)

#case_when() 

encuesta_colores <- encuesta_colores%>%
  mutate(categoria_edad = case_when(
    edad < 18 ~ "menor de edad",
    edad >= 18 & edad <= 60 ~ "adulto", 
    edad > 60 ~ "adulto mayor"
  ))

# crear una nueva variable que sea la categoría de edad

# convertir estos datos en una tabla "larga"

colores_larga <- encuesta_colores %>%
  separate_rows(colores_favoritos)

count(colores_larga, colores_favoritos)

colores_larga <- encuesta_colores %>%
  separate_rows(colores_favoritos) %>%
  mutate(colores_favoritos = str_to_lower(colores_favoritos))

count(colores_larga, colores_favoritos, sort = TRUE) 

# convertir estos datos en una tabla "ancha"

encuesta_colores%>%
  separate(col = colores_favoritos,
           into = c("color1", "color2", "color3"))


colores_ancha <- encuesta_colores%>%
  mutate(colores_favoritos = str_to_lower(colores_favoritos))%>%
  separate(col = colores_favoritos,
           into = c("color1", "color2", "color3"))

## 2. Limpieza y transformacion con datos sobre migración

migrantes <- read_excel("nacidos-fuera-del-pais.xlsx")
# se ve raro, se agregaron nuevos nombres pq existe una columna combinada

migrantes <- read_excel("nacidos-fuera-del-pais.xlsx", skip = 1)
head(migrantes)

migrantes %>%
  remove_empty(c("cols", "rows")) 

# ya logramos sacar esas filas, ahora rellenamos

migrantes <- migrantes %>%
  remove_empty(c("cols", "rows")) %>%
  fill(c("REGIÓN RESIDENCIA HABITUAL", "CÓDIGO REGIÓN"))%>%
  pivot_longer(cols = PERÚ:"PAÍS DE NACIMIENTO NO DECLARADO",
               names_to = "origen",
               values_to = "frecuencia") %>%
  clean_names()  # (case = "upper_camel") ó "lower_camel

distinct(migrantes, region_residencia_habitual)

migrantes %>%
  filter(region_residencia_habitual == "BIOBÍO", 
         llegada_a_chile == "Entre 2010 y 2017") %>%
  ggplot(aes(y = reorder(origen, frecuencia), frecuencia)) +
  geom_col() +
  labs(y = NULL)
"Personas fuera de Chile que residen en la región del Biobío entre el 2010 y 2017"

## 3. Encuesta CASEN ----

download.file(url = "http://observatorio.ministeriodesarrollosocial.gob.cl/storage/docs/casen/2017/casen_2017_spss.rar
", destfile = "casen2017.rar", mode = "wb")

casen <- read_spss("Casen 2017.sav")

head(casen)
str(casen$region)

# Queremos las preguntas sobre educacion (e y un numero), region, provincia, comuna, pco1

casen_educacion_biobio <- casen %>%
  select(region:comuna, pco1, e1:e0) %>%
  filter(region == 8)

head(casen_educacion_biobio)

str(casen_educacion_biobio$e3)

#como hacer que las variables que nos salen numericas nos salgan como factor?

casen_educacion_biobio %>%
  mutate(region = as_factor(region))

casen_educacion_biobio %>%
  mutate(provincia = as_factor(provincia))

casen_educacion_biobio %>%
  mutate(across(where(is.labelled), as_factor))

casen_educacion_biobio <- casen_educacion_biobio %>%
  mutate(across(where(is.labelled), as_factor))

readr::write_rds(casen_educacion_biobio, "casen_educacion_biobio.rds", compress = "gz")

casen_edu_biobio <- readr::read_rds("casen_educacion_biobio.rds")
