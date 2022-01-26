### Ejercicios para practicar lo aprendido estas semanas

# Los datos a utilizar son parte del proyecto Gampminder (gapminder.org), que recopila datos históricos sobre variables que se suelen utilizar para medir el desarrollo de un país. 

# Antes de partir, es necesario que instales un paquete que se llama "tidyverse". Es un paquete que tiene en su interior otros paquetes, por lo que tomará un par de minutos en instalarse. Para instalarlo, elimina el "#" en la siguiente línea para que el código pueda ejecutarse. Luego de instalar el paquete, vuelve a agregarle el # al inicio (ese es solo por precaución, para no volver a ejecutar esa línea por error)

# install.packages("tidyverse")
install.packages("tidyverse")
# En lo que queda de este script, reemplaza las líneas ___ con las funciones, los argumentos o los nombres de objetos que correspondan para hacer que cada bloque de código funcione. En todas las líneas en que hay que hacer algún cambio aparece actualmente una cruz roja al lado del número de línea.


# 1. Carga los paquetes readr, dplyr y ggplot2

library(readr)
library(dplyr)
library(ggplot2)


# 2. Importa los datos que utilizaremos a un objeto que se llame "desarrollo"

desarrollo <- read_csv("https://bit.ly/32eTtrM");
View(desarrollo)
# 3. Mirar los datos

# Revisa la estructura de la tabla de datos contenida en nuestro objeto "desarrolloR
str(desarrollo)
# una muy parecida es glimpse
glimpse(desarrollo)
summary(desarrollo)
skim(desarrollo)#arroja error pq no hay un paquete activo
skimr::skim(desarrollo)

# Revisa las 14 primeras líneas del objeto "desarrollo" y luego las 14 últimas

head(desarrollo, n = 14) #fijarse en la base de datos cual es la unidad de observación, en este caso son 12 casos por país
tail(desarrollo, n = 14)

# 4. Haz un resumen de datos ---
# Crea una tabla que muestre el mínimo, el máximo y el promedio del pib per cápita para el año 2007, según continente:


desarrollo %>%
  filter(anio == 2007) %>%
  group_by(continente) %>%
  summarise(min_pib = min(pib_per_capita),
      max_pib = max(pib_per_capita),
      media_pib = mean(pib_per_capita)
  )
#dos formas de guardar el resultado de esta tabla
# 1: agregar 1 linea de codigo que 
desarrollo %>%
  filter(anio == 2007) %>%
  group_by(continente) %>%
  summarise(min_pib = min(pib_per_capita),
            max_pib = max(pib_per_capita),
            media_pib = mean(pib_per_capita)
  ) %>% 
  write_csv("pib_continentes_2007.csv")

tabla_pib <- desarrollo %>%
  filter(anio == 2007) %>%
  group_by(continente) %>%
  summarise(min_pib = min(pib_per_capita),
            max_pib = max(pib_per_capita),
            media_pib = mean(pib_per_capita)
  )
writexl::write_xlsx(tabla_pib, "pib_continenetes_2007.xlsx")

# 5. ¿Cuáles son los cinco países con mayor población en las Américas en el año 2007?

desarrollo %>% 
  filter(anio == 2007, continente == "Américas") %>% 
  slice_max(poblacion, n = 5)

desarrollo %>% 
  filter(anio == 2007, continente == "Américas") %>% 
  arrange(poblacion) %>% 
  slice(1:5, 21:25) #si quisiera al mismo tiempo las 5 primeras y 5 ultimas filas
#guardar resultados y despues unir

max_poblacion <- desarrollo %>% 
  filter(anio == 2007, continente == "Américas") %>% 
  slice_max(poblacion, n = 5)

min_población <- desarrollo %>% 
  filter(anio == 2007, continente == "Américas") %>% 
  slice_min(poblacion, n = 5)

bind_rows(max_población, min_población)

str(desarrollo)
# 6. ¿Cuáles son los dos países con menor esperanza de vida en en el año 2007, según continente? (*los resultados de Oceanía no son representativos, ya que esta base solo contiene datos de Nueva Zelanda y Australia)

desarrollo %>% 
  filter(anio == 2007) %>% 
  group_by(continente) %>% 
  slice_min(esperanza_de_vida, n = 2)

desarrollo %>% 
  filter(anio == 2007, continente == "África") %>% 
  slice_min(esperanza_de_vida, n = 2)

# 7. Filtra los datos correspondientes a Chile y guárdalos en un objeto llamado "chile"

chile <- filter(desarrollo, pais == "Chile") 
write_excel_csv(desarrollo, "Chile")
#readr::write_csv(desarrollo, "Chile")

# 8. Bono: crear un gráfico :)
# A continuación encontrarás un bloque de código que permite crear un gráfico. No es algo que hayamos hecho antes, así que si no te resulta, no es problema. 
# Lo que queremos en este caso es poner en el eje x la variable "anio" y en el eje "y" la variable "pib_per_capita". Es necesario haber creado el objeto "chile" para que funcione ;)


ggplot(chile, aes(x = anio, y = pib_per_capita)) +
  geom_line()

ggplot(chile) # solo me sale un recuadro gris
ggplot(chile, aes(x = anio, y= pib_per_capita)) #acá agregamos los ejes

ggplot(chile, aes(x = anio, y= pib_per_capita)) +
  geom_line()

ggplot(chile, aes(x = anio, y= pib_per_capita)) +
  geom_col()

#agregar color, pueden revisar color ejecutando colors()

ggplot(chile, aes(x = anio, y= pib_per_capita)) +
  geom_col(fill = "hotpink3")

#es lo mismo  uw lo siguientes

desarrollo %>% 
  filter(pais == "Chile") %>% 
  ggplot(aes(x = anio, y = pib_per_capita)) +
  geom_col(fill ="violetred4") +
  theme_minimal () +
  labs(title = "Evolución del PIB en Chile", 
       subtitle = "1952 - 2007", 
       x = NULL, y = "PIB en dólares",
       caption = "Fuente de los datos: gapminder.org")

# Vamos a compararar el PIB de Chile con el de otro países
# haiti, finanldandia, promedio latam

desarrollo %>% 
  filter(pais %in% c("Chile", "Haití", "Finlandia")) %>% 
  ggplot(aes(anio, pib_per_capita, color = pais)) + 
  geom_line(size = 3) + 
  labs(title = "Comparación del PIB de Chile, Haití y Finlandia",
       subtitle = "1952 - 2007",
       x = NULL, 
       y = "PIB per cápita en dólares",
       color = "país", 
       caption = "Fuente de los datos: gapminder.org")

ggsave("grafico-comparacion-2.png", height = 7, width = 10)

#se usa color y no fill, porque fill es para superficices, color es para puntos y lineas
# Si quisieras explorar otras variables, solo tendrías que cambiar lo que va en el eje "y".

#escribir colors() en la consola para ver los colores que soporta R

https://www.w3schools.com/colors/colors_picker.asp
https://www.color-hex.com/

# Si tienes cualquier duda, coméntala en Slack para que la resolvamos. 

install.packages("skimr")




#7 de mayo 2021

ggplot(chile, aes(x = anio, y= pib_per_capita)) +
  geom_line() +
  geom_point() #puede usarse mas de 1 caracteristica


# Para hacer un grafico animado vamos a instalar 3 paquetes
install.packages(c("gganimate", "png", "gifski"))
library("gganimate")
#vamos a crear un histograma

desarrollo %>%
  filter(anio == 2002) %>%
  ggplot(aes(x = pib_per_capita)) +
  geom_histogram()
#si quisieramos solo los datos de los años 1952 y 2007, podemos hacerlo de todas estas formas



desarrollo %>%
  filter(anio == 2007 | anio ==1952 )

desarrollo %>%
  filter(anio %in% c(1952, 2007))

desarrollo %>%
  filter(anio == c(1952, 2007))

desarrollo %>%
  filter(anio == 2007 | anio == 1952 ) %>%
  ggplot(aes(x = pib_per_capita)) +
  geom_histogram() +
  facet_wrap(~anio) # muy útil cuando quiero generar comparaciones dentro de una variable


#un grafico de punto
#para explora la relación entre pib per capita y esperanza de vida

ggplot(desarrollo, aes(x = pib_per_capita, y = esperanza_de_vida, size = poblacion, color = continente)) +
  geom_point(alpha = 0.4, show.legend = FALSE)+  #estan todos los años en la grafica, aplha define la opacidad de los puntos
  scale_x_log10(labels = scales::dollar) +
  scale_size(range = c(2, 12)) +
  facet_wrap(~continente) + 
  theme_minimal() +
  labs(title = "Relación de la esperanza de vida y el pib per cápita por año: {as.integer(frame_time)}", 
       subtitle = "Cada punto representa un país en un determinado año",
       x = "PIB per cápita en dolares",
       y = "Esperanza de vida al nacer") + 
  gganimate::transition_time(anio) +
  ease_aes("linear")
  
anim_save("pib-esperanza-vida.gif")

anim_save("pib-esperanza-vida.mp4") #nofunciona u.u

## Creación de variables categóricas ----

# opcion 1: quiero crea 1 nueva variable con dos valores

# importa la lista de paises ocde

ocde <- read_csv("paises_ocde.csv")

View(ocde)

#vamos a crear una nueva variable a partir de una condición. Nuestra variables se va a llamar "ocde_2021" si un país de nuetra base "desarrollo" esta en la lista (ocde), esa variable dice "país OCDE", y si no está, diga "país no ocde"

desarrollo <- desarrollo %>%
  mutate(ocde_2021 = if_else(condition = pais %in% ocde$pais_ocde,
                             true = "país OCDE",
                             false = "país no OCDE"))

ggplot(desarrollo, aes(pib_per_capita)) +
  geom_histogram() +
  facet_wrap(~ocde_2021)

