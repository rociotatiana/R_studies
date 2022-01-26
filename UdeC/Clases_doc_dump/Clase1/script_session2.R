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

datos2 <- as.numeric(datos) #quiero que entienda como datos numericos

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

Violetas <- filter(registro_nombres, nombre %in% c("Violetta", "Violeta"))

filter(registro_nombres, nombre %in% c("Violetta", "Violeta"))

filter(registro_nombres, nombre == "Margaret", anio <= 1989 | anio >= 2005)
       
BBS <- c("Kevin", "Bryan", "Brian", "Brayan")

nombresBBs <- filter(registro_nombres, nombre %in% BBS)
View(nombresBBs)

#como encadenar funciones ----

# una primera opcion es hacer esto en 2 paso

#1 filtrar

margaret <- filter(registro_nombres, nombre == "Margaret")
View(margaret)
sum(margaret$n)

diana <- filter(registro_nombres, nombre == "Diana")
sum(diana$n)

# otra opcion es en 1 solo paso. "pipe" =ducto. Ctrl * Shif * M: %>%. Se lee como "luego"

registro_nombres %>%
  filter(nombre == "Diana") %>% 
  summarise(sum(n))

registro_nombres %>%
  filter(nombre == "Carolina") %>% 
  summarise(sum(n))

registro_nombres %>%
  filter(nombre == "Miguel") %>% 
  summarise(sum(n), min(n), max(n))

filter(registro_nombres, nombre == "Lenin")

# cuales fueron los tres nombres más populares durante 2019?

registro_nombres %>% 
  filter(anio == 2019) %>% 
  slice_max(n, n = 3)

registro_nombres %>% 
  group_by(sexo) %>% 
  filter(anio == 2019) %>% 
  slice_max(n, n = 4)

registro_nombres %>% 
  group_by(sexo) %>% 
  filter(anio == 2019) %>% 
  slice_min(n, n = 4)

registro_nombres %>% 
  group_by(anio, sexo) %>% 
  slice_max(n) %>%
  View()

# Importar otra base de datos ----

install.packages("readr")

inscripciones <- read_csv("inscripciones_registro_civil.csv")
inscripciones2 <- read.csv("inscripciones_registro_civil.csv")
inscripciones2
inscripciones

head(inscripciones)

# tenemos una base de datos con nombres y otra con el total de inscritos x año. Queremos agregar la columna total a nuestra 1era base y luego volverla frecuencia
# utilizar full_join(x, y), este buscará la columna común
# inner_join solo cuando todas las filas tienen info
# left_join le interesa que la columna de la izquierda quede completa, pero si no hay info da igual 
# right_join es lo mismo, solo cambia el orden de los objetos
# anti_join, quiero que me saque nos caso que son comunes (cuando hago una investigacion y tengo que hacer casos de inclusion)

# a nosotros nos convendría hacer un left_join, solo los elementos que coinciden de inscripciones

# Vamos a unir nuestros objetos entre registro_nombres e instricciones

registro_nombres <- left_join(registro_nombres, inscripciones)

head(registro_nombres)
tail(registro_nombres)

#crearemos una nueva columna con el numero/numero total del año, usando mutate

registro_nombres %>% 
  mutate(proporcion = n / inscritos_anio) %>% 
  select(anio, sexo, nombre, n, proporcion) # mencionar lo que quiero dejar

registro_nombres %>% 
  mutate(proporcion = n / inscritos_anio) %>% 
  select(-inscritos_anio) # indicar con un - lo que quiero sacar

registro_nombres <- registro_nombres %>% 
  mutate(proporcion = n / inscritos_anio) %>% 
  select(-inscritos_anio) # indicar con un - lo que quiero sacar

write_xlsx(registro_nombres, "nombres_completa.xlsx")
