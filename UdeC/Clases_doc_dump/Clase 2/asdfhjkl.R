library(rvest)
library(dplyr)
library(tidyr)
library(lubridate)
library(stringr)
library(janitor)
library(readr)
library(glue)

# Leer el código html 

html_senado <- read_html("https://www.senado.cl/appsenado/index.php?mo=lobby&ac=GetReuniones")

# extraer la tabla donde están los datos que nos interesan:

reuniones_html <- html_senado %>% 
  html_nodes("table") %>% 
  html_table()

tabla_reuniones <- reuniones_html[[2]] %>%
  clean_names() %>%
  separate(fecha_duracion_lugar,
           into = c("fecha", "duracion", "lugar"),
           sep = "  ",
           extra= "merge")
head(tabla_reuniones)
tail(tabla_reuniones)

tabla_reuniones <- tabla_reuniones %>%
  mutate(fecha = as_date(fecha)) %>%
  mutate(duracion = parse_number(duracion))

tabla_reuniones <-  tabla_reuniones %>%
  mutate(fecha = as_date(fecha)) %>%
  mutate(duracion_minutos = parse_number(duracion), .keep = "unused", .after = fecha)

# guardemos nuestra tabla
hoy <- today()

write_csv(tabla_reuniones, glue("lobby_senadores_{today()}.csv"))

tabla_reuniones %>%
  filter(str_detect(materia, "pesca")) %>%
  View()

tabla_reuniones %>%
  filter(str_detect(materia, "salmon|salmón")) %>%
  View()


tabla_reuniones %>%
  filter(str_detect(materia, regex("uber|cabify|didi", ignore_case = TRUE))) %>%
  View()

tabla_reuniones %>%
  filter(str_detect(materia, regex("afp|pension|pensión|jubila",
                                   ignore_case = TRUE))) %>%
  View()

tabla_reuniones %>%
  filter(fecha >= "2020-10-25" & fecha <= "2021-04-09")
View()


tabla_reuniones%>%
  mutate(anio = year (fecha),
         mes = month(fecha),
         dia = day(fecha))
         

# VISUALIZACION DE DATOS ----


         