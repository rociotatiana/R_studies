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


# 5. ¿Cuáles son los cinco países con mayor población en las Américas en el año 2007?

desarrollo %>% 
  filter(anio == 2007, continente == "Américas") %>% 
  group_by(pais) %>% 
  slice_max(poblacion, n = 5)

str(desarrollo)
# 6. ¿Cuáles son los dos países con menor esperanza de vida en en el año 2007, según continente? (*los resultados de Oceanía no son representativos, ya que esta base solo contiene datos de Nueva Zelanda y Australia)

desarrollo %>% 
  filter(anio == 2007) %>% 
  group_by(continente) %>% 
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

# Si quisieras explorar otras variables, solo tendrías que cambiar lo que va en el eje "y".


# Si tienes cualquier duda, coméntala en Slack para que la resolvamos. 

