#INTRODUCCION LIBRO ----

install.packages("tidyverse")

#Para descargar packages ver esta pag: https://cloud.r-project.org/

library(tidyverse)
tidyverse_update()
install.packages(c("dplyr", "haven", "hms", "pillar", "rlang", "tibble"))
install.packages(c("nycflights13", "gapminder", "Lahman"))

# Si tienes dudas respecto al programa, revisa este link: https://stackoverflow.com/
# https://blog.rstudio.com/ ; https://www.r-bloggers.com/ ; https://twitter.com/search?q=%23rstats 

# Data Visualization ----

# Para mayor info: http://vita.had.co.nz/papers/layered-grammar.pdf
library(tidyverse)
library(ggplot2)

#Si hay que ser explicitos con el origen de una función, y esta no está en ningun lado, usar package::function()

#Veamos tipos de autos, basedatos online

?mpg

#Creando un ggplot
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy))

ggplot(data = mpg) + 
  geom_point(aes(x = displ, y = hwy)) #probé este y se ve igual...

# Each geom function in ggplot2 takes a mapping argument. Mapping argumento always paired with aes()


# template

#ggplot(data = <DATA>) + 
#  <GEOM_FUNCTION>(mapping = aes(<MAPPINGS>))

ggplot(data = mpg) +
  geom_point(aes (x = hwy, y = cyl))

ggplot(data = mpg) +
  geom_point(aes (x = class, y = drv)) # este no nos sirve, es MUY disperso

# en los de displ vs hwy hay unos outliers dando vuelta a la derecha arriba. Podemos cambiar la estética del punto para ver si son hibridos
# esta vez diferenciamos color x clase

ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy, color = class))

# también se puede intentar por tamaño. pero no se lo recomienda con variables discretas

ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy, size = class))

# transparencia = alpha
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy, alpha = class))

# forma = shape 
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy, shape = class))

# manejando el color de tu grafico
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy), color = "red")

# por qué no es azul??

ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy, color = "blue")) #observen el ) extra!!

# manejando el color de tu grafico
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy), color = "red")

ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy, shape = fl))

# shape, size & color se comportan de mala manera con variables continuas, lo mejor es usarlos en variables discretas.

?geom_point

# Learn more about setting these aesthetics in vignette("ggplot2-specs").



ggplot(mtcars, aes(wt, mpg)) +
  geom_point(shape = 21, colour = "black", fill = "white", size = 5, stroke = 5)

p <- ggplot(mtcars, aes(mpg, wt, shape = factor(cyl)))

p + geom_point(aes(colour = factor(cyl)), size = 4) +
  geom_point(colour = "grey90", size = 1.5)

p + geom_point(colour = "black", size = 4.5) +
  geom_point(colour = "pink", size = 4) +
  geom_point(aes(shape = factor(cyl)))

mtcars2 <- transform(mtcars, mpg = ifelse(runif(32) < 0.2, NA, mpg))
ggplot(mtcars2, aes(wt, mpg)) + geom_point()
ggplot(mtcars2, aes(wt, mpg)) + geom_point(na.rm = TRUE)

# If you’re still stuck, try the help. You can get help about any R function by running ?function_name in the console

# Facets

ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy)) + 
  facet_wrap(~ class, nrow = 2)

#Facet grid
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy)) + 
  facet_grid(drv ~ cyl)

ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy)) + 
  facet_grid(. ~ cyl)

ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy)) + 
  facet_wrap( ~ hwy) #en variables continuas el grid se va a la chucha

ggplot(data = mpg) + 
  geom_point(mapping = aes(x = drv, y = cyl)) +
  facet_grid(drv ~ cyl)

ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy)) + 
  facet_wrap(~ class, nrow = 2)
?facet_wrap

## GEOMETRIC OBJECTS ----

# A geom is the geometrical object that a plot uses to represent data. 


ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy))

ggplot(data = mpg) + 
  geom_smooth(mapping = aes(x = displ, y = hwy))
# Lineas = geom_smooth(mapping = aes(x, y))

# ggplot2 provides over 40 geoms, and extension packages provide even more
# (see https://exts.ggplot2.tidyverse.org/gallery/ for a sampling)
# cheatsheet (http://rstudio.com/resources/cheatsheets)

ggplot(data = mpg) +
  geom_smooth(mapping = aes(x = displ, y = hwy))

ggplot(data = mpg) +
  geom_smooth(mapping = aes(x = displ, y = hwy, group = drv))

ggplot(data = mpg) +
  geom_smooth(
    mapping = aes(x = displ, y = hwy, color = drv),
    show.legend = FALSE
  )

#To display multiple geoms in the same plot, add multiple geom functions to ggplot()
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy)) +
  geom_smooth(mapping = aes(x = displ, y = hwy))

#tambien expresado así
ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) + 
  geom_point() + 
  geom_smooth()

#al agregar mappings a geom functions, SOLO funcionan para ese geom, por lo que se puede jugar con distintos geom y mappings por separado para un mismo grafico

ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) + 
  geom_point(mapping = aes(color = class)) + 
  geom_smooth()

ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) + 
  geom_point(mapping = aes(color = class)) + 
  geom_smooth(data = filter(mpg, class == "subcompact"), se = FALSE)

ggplot(data = mpg, mapping = aes(x = displ, y = hwy, color = drv)) + 
  geom_point() + 
  geom_smooth(se = FALSE)

#exercises
ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) + 
  geom_point() + 
  geom_area()


#STATISTICAL TRANSFORMATION
ggplot(data = diamonds) + 
  geom_bar(mapping = aes(x = cut))

ggplot(data = diamonds) + 
  stat_count(mapping = aes(x = cut))

ggplot(data = diamonds) + 
  stat_summary(
    mapping = aes(x = cut, y = depth),
    fun.min = min,
    fun.max = max,
    fun = median
  )

#amononarlo
ggplot(data = diamonds) + 
  geom_bar(mapping = aes(x = cut, colour = cut)) #bordes de colores

ggplot(data = diamonds) + 
  geom_bar(mapping = aes(x = cut, fill = cut)) #colorear

ggplot(data = diamonds) + 
  geom_bar(mapping = aes(x = cut, fill = clarity)) #trasponer color

## position = "identity" will place each object exactly where it falls in the context of the graph. This is not very useful for bars, because it overlaps them. 
##The identity position adjustment is more useful for 2d geoms, like points, where it is the default.

ggplot(data = diamonds, mapping = aes(x = cut, fill = clarity)) + 
  geom_bar(alpha = 1/5, position = "identity") # color + trasparencia

ggplot(data = diamonds, mapping = aes(x = cut, colour = clarity)) +
  geom_bar(fill = NA, position = "identity") # espacios transparentes y borde de color

## position = "fill" works like stacking, but makes each set of stacked bars the same height. 
##Facil para comparar PROPORCIONES ENTRE GRUPOS.

ggplot(data = diamonds) + 
  geom_bar(mapping = aes(x = cut, fill = clarity), position = "fill")

## position = "dodge" places overlapping objects directly beside one another. 
## This makes it easier to compare individual values.

ggplot(data = diamonds) + 
  geom_bar(mapping = aes(x = cut, fill = clarity), position = "dodge")

## Jitter
#útil para scatterplot, le agrega ruido a los puntos para que el overlap sea menor
ggplot(data = mpg) + 
 geom_point(mapping = aes(x = displ, y = hwy), position = "jitter")

ggplot(data = mpg) + 
  geom_jitter(mapping = aes(x = displ, y = hwy), color = "hotpink")

# To learn more about a position adjustment, look up the help page associated with each adjustment: 
# ?position_dodge, ?position_fill, ?position_identity, ?position_jitter, and ?position_stack.

?position_dodge
?position_fill

ggplot(data = mpg, mapping = aes(x = cty, y = hwy)) + 
  geom_point(position = "jitter")

ggplot(diamonds, aes (price, fill = cut)) + 
  geom_histogram(position = "dodge2")

ggplot(diamonds, aes(price, fill = cut)) +
  geom_bar(position = position_dodge2(preserve = "single"))

ggplot(diamonds, aes(price, color = cut)) +
  geom_freqpoly()

ggplot(data = mpg, mapping = aes(x = , y = hwy)) + 
  geom_boxplot()


##Coordinate systems

#coord_flip() switches the x and y axes. 
#This is useful (for example), if you want horizontal boxplots.

ggplot(data = mpg, mapping = aes(x = class, y = hwy)) + 
  geom_boxplot()
ggplot(data = mpg, mapping = aes(x = class, y = hwy)) + 
  geom_boxplot() +
  coord_flip()


#coord_quickmap() sets the aspect ratio correctly for maps. 
install.packages(maps) #no encuentra el package uwu
nz <- map_data("nz")

ggplot(nz, aes(long, lat, group = group)) +
  geom_polygon(fill = "white", colour = "black")

ggplot(nz, aes(long, lat, group = group)) +
  geom_polygon(fill = "white", colour = "black") +
  coord_quickmap()

#coord_polar() uses polar coordinates. 
#Polar coordinates reveal an interesting connection between a bar chart and a Coxcomb chart.

bar <- ggplot(data = diamonds) + 
  geom_bar(
    mapping = aes(x = cut, fill = cut), 
    show.legend = FALSE,
    width = 1
  ) + 
  theme(aspect.ratio = 1) +
  labs(x = NULL, y = NULL)

bar + coord_flip()
bar + coord_polar()

ggplot (data = mpg) +
  geom_bar (mapping = aes(class, color = class) + 
              coord_polar()
  
  
  ggplot(data = mpg, mapping = aes(x = cty, y = hwy)) +
    geom_point()
  
  ggplot(data = mpg, mapping = aes(x = cty, y = hwy)) +
    geom_point() + 
    geom_abline() +
    coord_fixed()
  
?coord_fixed
  
## Layered grammar of graphics
  
  ggplot(data = <DATA>) + 
    <GEOM_FUNCTION>(
      mapping = aes(<MAPPINGS>),
      stat = <STAT>, 
      position = <POSITION>
    ) +
    <COORDINATE_FUNCTION> +
    <FACET_FUNCTION>
    

##### TEMPLATES ----
ggplot(data = <DATA>) + 
  <GEOM_FUNCTION>(mapping = aes(<MAPPINGS>))

  
  
 # ggplot(data = <DATA>) + 
  #  <GEOM_FUNCTION>(
   #   mapping = aes(<MAPPINGS>),
    #  stat = <STAT>, 
     # position = <POSITION>
  #  ) +
   # <COORDINATE_FUNCTION> +
    #<FACET_FUNCTION> 