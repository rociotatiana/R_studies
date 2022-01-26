# primero vamos a activar los paquetes descargados ----
library(readxl)
library(writexl)
library(dplyr)

# RECORDAR ABRIR DESDE LA CARPETA
# ahora vamos a importar nuestros datos ----

registro_nombres <- readxl::read_excel("nombres.xlsx")

# Algunas funciones para mirar nuestros datos----

View(registro_nombres) #abre una pestaña con una vista de los datos

print(registro_nombres) 
registro_nombres #funciona igual que print, es como llamar de manera invisible esta función

head(registro_nombres) # por defecto muestra las primeras 6 filas
head(registro_nombres, n = 9)

tail(registro_nombres) #seis ultimas filas

str(registro_nombres) # muestra la estructura de los datos

datos <- c(36, 24, 57, 87, "veinte") # ejemplo de coerción

datos2 <- as.numeric(datos)

mean(datos2, na.rm = TRUE)

# signo $ es para referirse a una columna
# no puedo aplicar la función mean() a toda la tabla

mean(registro_nombres$n) # si se desea clacular la media de la columna n, especificamente

summary(registro_nombres)

dim(registro_nombres)
nrow(registro_nombres)
ncol(registro_nombres)

# Veamos como filtrar nuestros datos ----

View (filter(registro_nombres, nombre == "Rocío"))

Rocios <- filter(registro_nombres, nombre == "Rocío")

filter(registro_nombres, nombre == "Violetta", anio >= 2010)

filter(registro_nombres, nombre == "Violetta", anio >= 2010, n > 50)
