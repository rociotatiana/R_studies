install.packages("swirl")
install.packages("lattice")
install.packages("car")
install.packages("flimport")
install.packages("tseries")
library(tidyverse)
library(dplyr)
library(readxl)

registro_nombres <- read_excel("nombres.xlsx")

head(registro_nombres)
tail(registro_nombres)

summary(registro_nombres)

mortalidad_baires <- read.csv('https://bitsandbricks.github.io/data/mortalidad_infantil_caba_2016.csv')

mortalidad_baires

dim(mortalidad_baires)

names(mortalidad_baires)

names(registro_nombres)


head(mortalidad_baires)

ggplot(mortalidad_baires) +
  geom_col (aes(x = factor (Comuna), y = Tasa2016))

## instalar un paquete de mapas

install.packages("sf")
library(sf)


#Luego, cargamos un archivo georeferenciado con las comunas de la Ciudad Autónoma de Buenos Aires, disponible online en formato geojson, un estándar de representación de datos geográficos que es fácil de usar:

comunas <- st_read('https://bitsandbricks.github.io/data/CABA_comunas.geojson')

dim(comunas)

names(comunas)

head(comunas)


ggplot(comunas) +
  geom_sf(aes(fill = comunas))

#diferenciar el norte y el sur, no hay linea oficial pero socialmente es Rivadavia

rivadavia <- st_read('https://bitsandbricks.github.io/data/avenida_rivadavia.geojson')

ggplot(comunas) +
  geom_sf(aes(fill = comunas)) + 
  geom_sf(data = rivadavia, color = "red")

#agregaremos si son del norte o sur

nueva_columna <- c("Sur", "Norte", "Sur", "Sur", "Sur", "Norte", "Sur", "Sur", "Sur", "Norte", "Norte", "Norte", "Norte", "Norte", "Norte")

comunas <- mutate(comunas, ubicacion = nueva_columna)


ggplot(comunas) +
  geom_sf(aes(fill = ubicacion)) +
  geom_sf(data = rivadavia, color = "red")

mortalidad_baires <- mutate(mortalidad_baires, ubicacion = nueva_columna)
head(mortalidad_baires)

#ahora agregamos al plot la mortalidad

ggplot(comunas) + 
  geom_sf(aes(fill = mortalidad_baires$Tasa2016)) + 
  geom_sf(data = rivadavia, color = "red") +
  scale_fill_distiller(palette = "Spectral") +
  labs(title = "Mortalidad infantil en la Ciudad Autónoma de Buenos Aires",
       subtitle = "Año 2016",
       x = "color según tasa de mortalidad") 


ggplot(mortalidad_baires) + 
  geom_col(aes(x = Comuna, y = Tasa2016,  fill = ubicacion)) +
  labs (title = "Mortalidad infantil en la Ciudad Autónoma de Buenos Aires", 
        subtitle = "Año 2016", 
        y = "tasa")

#separamos los datos segun ubicacion

comunas_sur <- filter(mortalidad_baires, ubicacion == "Sur")

comunas_norte <- filter(mortalidad_baires, ubicacion == "Norte")

#diferencia entre el promedio de mortalidad de ambas

mean(comunas_sur$Tasa2016) / mean(comunas_norte$Tasa2016)

#En el año 2016, la tasa de mortalidad infantil en todo los barrios del sur es más alta que en cualquier de los del norte.

#Para los nacidos en 2016 de padres que viven en el sur de la ciudad, la posibilidad de morir antes del primer año es, en promedio, el doble que la de aquellos con padres que residen al norte.

