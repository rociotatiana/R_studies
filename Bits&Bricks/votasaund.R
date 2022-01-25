library(tidyverse)



padron_2021 <- read_csv2("PADRON_DEF_2021_MUNGORE.csv")

head(padron_2021)%>%
  View()

tail(padron_2021)%>%
  View()

max(padron_2021$DV)

votacion_2020 <- read_csv2 ("VW_VOTARON_2020PLEB_Datos completos.csv")

summary(votacion_2020)


## CAP 3 DATA WRANGLING

atencion_ciudadano <- read.csv("http://bitsandbricks.github.io/data/gcba_suaci_barrios.csv")

str(atencion_ciudadano)

head(atencion_ciudadano)

summary(atencion_ciudadano)

levels(atencion_ciudadano$BARRIO)

levels(atencion_ciudadano$RUBRO) #no funciona


#agregando una nueva variable

barrios_comunas <- read.csv("http://bitsandbricks.github.io/data/barrios_comunas.csv")

barrios_comunas

atencion_ciudadano <- left_join(atencion_ciudadano, barrios_comunas)

head(atencion_ciudadano)  

write.csv(atencion_ciudadano, "atencion_ciudadano.csv", row.names = FALSE)


getwd()

seleccion <- select(atencion_ciudadano, PERIODO, total)

head(seleccion)

seleccion <- select(atencion_ciudadano, -(TIPO_PRESTACION:total))

seleccion <- select(atencion_ciudadano, -RUBRO, -BARRIO)

head(seleccion)




seleccion <- filter(atencion_ciudadano, BARRIO == "RETIRO", PERIODO == 201401)
head(seleccion)



* a & b     a y b
* a | b     a ó b
* a & !b    a, y no b
* !a & b    no a, y b
* !(a & b)  no (a y b) 

filter(atencion_ciudadano, TIPO_PRESTACION == "TRAMITE" & !(RUBRO == "REGISTRO CIVIL"))

seleccion <- filter(atencion_ciudadano, !(TIPO_PRESTACION == "DENUNCIA" & RUBRO == "SEGURIDAD E HIGIENE"))
head(seleccion)


ordenado <- arrange(atencion_ciudadano, total)

head(ordenado)


ordenado <- arrange(atencion_ciudadano, total, BARRIO)
head(ordenado)


##mutate()

circulos <- data.frame(nombre = c("Círculo 1", "Círculo 2", "Círculo 3"),
                       tamaño = c("Pequeño", "Mediano", "Grande"),
                       radio  = c(1, 3, 5))

circulos

mutate(circulos, area = 3.1416 * radio^2)


## separar la parte del año de la parte del mes

substr()

atencion_ciudadano <- mutate(atencion_ciudadano,
                             AÑO = substr(PERIODO, 1, 4),
                             MES = substr(PERIODO, 5, 6))
head(atencion_ciudadano)

atencion_ciudadano%>%
  group_by(AÑO)%>%
  summarise(promedio_totales = mean(total))

atencion_ciudadano%>%
  group_by (AÑO, MES) %>%
  summarise (promedio = mean(total))

atencion_ciudadano%>%
  group_by (AÑO, MES, BARRIO) %>%
  summarise (promedio = mean(total))

atencion_ciudadano %>%
  group_by(BARRIO) %>%
  filter(AÑO == 2015) %>%
  summarise(max(total, n =5))

atencion_ciudadano%>%
  filter(AÑO == 2015) %>%
  group_by(BARRIO) %>%
  summarise(total = sum (total)) %>%
  arrange (desc(total)) %>%
  head(5)


#VISUALIZACION

atencion_ciudadano <- read.csv("http://bitsandbricks.github.io/data/gcba_suaci_comunas.csv")
head(atencion_ciudadano)

contactos_por_comuna <- atencion_ciudadano %>% 
  group_by(COMUNA) %>% 
  summarise(miles_contactos = sum(total) / 1000 )

contactos_por_comuna

#descargar la cantidad de habitantes por comuna

habitantes <- read.csv("http://bitsandbricks.github.io/data/gcba_pob_comunas_17.csv")

habitantes

contactos_por_comuna <- contactos_por_comuna%>% left_join(habitantes)

contactos_por_comuna

ggplot(contactos_por_comuna) +
  geom_point(aes (x = POBLACION, y = miles_contactos))

ggplot(contactos_por_comuna) +
  geom_line(aes (x = POBLACION, y = miles_contactos))

ggplot(contactos_por_comuna) +
  geom_point(aes(x = POBLACION, y = miles_contactos, color = factor(COMUNA)))

ggplot(contactos_por_comuna) +
  geom_label(aes(x = POBLACION, y = miles_contactos, label = factor(COMUNA)))

ggplot(contactos_por_comuna) + 
  geom_point(aes(x = POBLACION, y = miles_contactos, size = miles_contactos))

ggplot(contactos_por_comuna) + 
  geom_point(aes(x = POBLACION, y = miles_contactos), color = "darkolivegreen4")

ggplot(contactos_por_comuna) + 
  geom_point(aes(x = POBLACION, y = miles_contactos), size = 5)

ggplot(contactos_por_comuna) + 
  geom_point(aes(x = POBLACION, y = miles_contactos), 
             size = 4, color = "chocolate3")
## FACETADO

contactos_por_comuna_y_tipo <- atencion_ciudadano%>%
  group_by(COMUNA, TIPO_PRESTACION) %>%
  summarise(miles_contactos = sum(total) / 1000 ) %>%
  left_join(habitantes)
head(contactos_por_comuna_y_tipo)

atencion_ciudadano

ggplot(contactos_por_comuna_y_tipo) + 
  geom_point(aes(x = POBLACION, y = miles_contactos)) +
  facet_wrap(~TIPO_PRESTACION)


ggplot(atencion_ciudadano) +
  geom_bar(aes(x = BARRIO, weight = total))

#SACAR LAS WEAITAS

options(scipen = 999)

ggplot(atencion_ciudadano) +
  geom_bar(aes(x = BARRIO, weight = total))


ggplot(atencion_ciudadano) +
  geom_bar(aes(x = BARRIO, weight = total, fill = TIPO_PRESTACION)) +
  coord_flip()

ggplot(atencion_ciudadano) +
  geom_bar(aes(x = BARRIO, weight = total, color = TIPO_PRESTACION)) +
  coord_flip()


ggplot(atencion_ciudadano) +
  geom_bar(aes(x = TIPO_PRESTACION, weight = total)) 

ggplot(atencion_ciudadano) +
  geom_bar(aes(x = TIPO_PRESTACION, weight = total, fill = BARRIO)) 

ggplot(atencion_ciudadano) +
  geom_bar(aes(x = TIPO_PRESTACION, weight = total)) +
  facet_wrap(~BARRIO)
## analicemos la distribución de registros mensuales (la columna PERIODO en nuestro dataset representa el lapso de un mes).

contactos_por_mes <- atencion_ciudadano %>% 
  group_by(PERIODO) %>% 
  summarise(gran_total = sum(total))

head(contactos_por_mes)

ggplot(contactos_por_mes) +
  geom_histogram(aes (x = gran_total))


contactos_por_mes_y_tipo <- atencion_ciudadano %>% 
  group_by(PERIODO, TIPO_PRESTACION) %>% 
  summarise(gran_total = sum(total))

head(contactos_por_mes_y_tipo)

ggplot(contactos_por_mes_y_tipo) +
  geom_histogram(aes (x = gran_total))


ggplot(contactos_por_mes_y_tipo) +
  geom_histogram(aes(x = gran_total)) +
  facet_wrap(~TIPO_PRESTACION)

ggplot(atencion_ciudadano) +
  geom_bar(aes(x = BARRIO, weight = total, fill = TIPO_PRESTACION)) +
  coord_flip()

ggplot(atencion_ciudadano) +
  geom_bar(aes(x = BARRIO, weight = total, fill = TIPO_PRESTACION)) +
  coord_flip() +
  labs(title = "Contactos realizados al Sistema Único de Atención Ciudadana",
       subtitle = "Ciudad Autónoma de Buenos Aires, 2013 - 2015",
       caption = "Fuente: portal de datos abiertos de la Ciudad - http://data.buenosaires.gob.ar",
       x = "barrio",
       y = "cantidad",
       fill = "Motivo del contacto")


# MODELAJE


data_mundial <- read.csv("https://bitsandbricks.github.io/data/gapminder.csv")

summary(data_mundial)

skimr::skim(data_mundial)

head(data_mundial)

# ¿Cómo ha se relaciona el paso del tiempo (variable explicativa) con la expectativa de vida en la Argentina?

data_arg <- data_mundial%>%
  filter(pais == "Argentina")

data_arg

ggplot(data = data_arg) +
  geom_point(aes(x = anio, y = expVida)) +
  labs(title = "Correlación entre tiempo y expectativa de vida",
       subtitle = "Argentina",
       y = "expectativa de vida")

cor(data_arg$anio, data_arg$expVida)

modelo_exp <- lm(expVida ~ anio, data = data_arg)

modelo_exp


ggplot(data = data_arg) + 
  geom_point(aes(x = anio, y = expVida)) +
  labs(title = "Correlación entre tiempo y expectativa de vida",
       subtitle = "Argentina",
       y = "expectativa de vida",
       caption = "con línea de regresión") +
  geom_abline(aes(intercept = -389.6063, slope = 0.2317), color = "blue")

ggplot(data = data_arg) + 
  geom_point(aes(x = anio, y = expVida)) +
  labs(title = "Correlación entre tiempo y expectativa de vida",
       subtitle = "Argentina",
       y = "expectativa de vida",
       caption = "con línea de regresión") +
  geom_abline(aes(intercept = -389.6063, slope = 0.2317), color = "blue") +
  xlim(c(1950, 2030)) +
  ylim(c(60, 85))

# Ahí está la predicción. Según nuestro modelo, para el año 2030 la expectativa de vida en la Argentina habrá superado los 80 años.

ggplot(data = data_arg) + 
  geom_point(aes(x = anio, y = expVida)) +
  labs(title = "Correlación entre tiempo y expectativa de vida",
       subtitle = "Argentina",
       y = "expectativa de vida",
       caption = "con línea de regresión vía geom_smooth()") +
  geom_smooth(aes(x = anio, y = expVida), method = "lm")

# PBI Y AÑO

ggplot(data = data_arg) + 
  geom_point(aes(x = anio, y = PBI_PC)) +
  labs(title = "Correlación entre PBI y expectativa de vida",
       subtitle = "Argentina",
       y = "PBI per cápita") +
  geom_smooth(aes(x = anio, y = PBI_PC), method = "lm")

modelo_PBI <- lm(PBI_PC ~ anio, data = data_arg)

modelo_PBI

# buscar los residuos

residuos <- residuals(modelo_PBI)

residuos

# unirlos al dataframe

data_arg <- data_arg %>% mutate(residuos_lm = residuos)

#graficar

ggplot(data_arg) +
  geom_point(aes(x = anio, y = residuos_lm)) +
  geom_hline(yintercept = 0, col = "blue") +
  labs(x = "año", y = "residuo del modelo lineal")

mean(data_arg$residuos_lm)

# revisemos la ruta del pib para ver la crisis del 2001

ggplot(data_arg) + 
  geom_line(aes(x = anio, y = PBI_PC)) +
  geom_vline(aes(xintercept = 2001), color = "red") +
  labs(title = "Evolución del PBI en la Argentina",
       y = "PBI per cápita",
       caption = "La línea roja indica la ocurrencia de la crisis del 2001")


### REGRESION CON CATEGORICA ----

data_mundial_2007 <- data_mundial %>% filter(anio == 2007)

ggplot(data = data_mundial_2007) +
  geom_point(aes(x = continente, y = expVida, color = continente)) +
  labs(title = "Expectativa de vida por continente",
       y = "expectativa de vida")

ggplot(data = data_mundial_2007) +
  geom_jitter(aes(x = continente, y = expVida, color = continente)) +
  labs(title = "Expectativa de vida por continente",
       y = "expectativa de vida")

ggplot(data = data_mundial_2007) +
  geom_histogram(aes(x = expVida, fill = continente)) +
  facet_wrap(~continente) +
  labs(title = "Expectativa de vida por continente",
       subtitle = "histogramas",
       x = "expectativa de vida",
       y = "cantidad")

modelo_exp_continente <- lm(expVida ~ continente, data = data_mundial_2007)

data_mundial_2007 <- data_mundial_2007 %>% 
  mutate(residuo_ml = residuals(modelo_exp_continente))

ggplot(data_mundial_2007) +
  geom_jitter(aes(x = continente, y = residuo_ml), width = 0.1) +
  geom_hline(yintercept = 0, col = "blue") +
  labs(x = "año", y = "residuo del modelo lineal")

mean(data_mundial_2007$residuo_ml)

data_mundial_2007%>%
  filter(continente == "Asia") %>%
  slice_min(expVida)

data_mundial_2007 %>% 
  filter(continente == "Asia") %>% 
  arrange(expVida) %>% 
  head()

# veamos que ondi afganistan

data_afganistan <- data_mundial %>% filter(pais == "Afghanistan")

ggplot(data_afganistan) + 
  geom_line(aes(x = anio, y = expVida)) +
  labs(title = "Expectativa de vida en Afganistán",
       y = "expectativa de vida")

## REGRESION MULTIPLES VARIABLES

modelo_exp_multiple <- lm(expVida ~ pobl + PBI_PC, data = data_mundial_2007)

modelo_exp_multiple

cor(data_mundial_2007$expVida, data_mundial_2007$pobl)

summary(modelo_exp_multiple)

summary(modelo_exp)


modelo_exp_multiple <- lm(expVida ~ pobl + PBI_PC + continente, data = data_mundial_2007)

summary(modelo_exp_multiple)
