install.packages("tidyverse")
install.packages("rmarkdown")
install.packages("kableExtra")
install.packages("gghighlight")
install.packages("na.tools")
tinytex::install_tinytex()

library(tidyverse)
library(dplyr)
library(ggplot2)
library(readr)
library(gghighlight)
library(na.tools)

votos_plebiscito <- read.csv2("VW_VOTARON_2020PLEB_Datos completos.csv") 

?read_csv

str(votos_plebiscito)

summary(votos_plebiscito)

votos_plebiscito%>%
  filter( Region == "Del Biobio")%>%
  filter( Votaron == 1 ) %>%
  ggplot(aes(x = Provincia, y = Edad)) +
  geom_boxplot()

votos_plebiscito%>%
  filter( Votaron == 1 ) %>%
  ggplot(aes(x = Edad)) +
  geom_histogram()


votos_plebiscito <- votos_plebiscito%>%
  filter( Comuna == "San Pedro De La Paz")

votos_plebiscito%>%
ggplot(aes(x = Rango.Edad)) +
  geom_bar() +
  coord_flip()


votos_plebiscito%>%
  ggplot(aes(x = Sexo)) +
  geom_bar()


votos_plebiscito%>%
 ggplot(aes(x = Sufragio)) +
  geom_bar()




write.csv(votos_plebiscito, file = "votos_sanpedro.csv")

votos_plebiscito <- read_csv("votos_sanpedro.csv", locale = locale(encoding = "Latin1"))




votos_plebiscito%>%
  ggplot(aes(x = Partido)) +
  geom_bar() +
  coord_flip()

# RANGO EDAD


votos_plebiscito%>%
  ggplot(aes(x = Rango.Edad, fill = Sufragio)) +
  geom_bar(position = "dodge") +
  theme_minimal() +
  coord_flip() + 
  labs (x = "Rango etario", 
        y = " ", 
        fill = "Participación",
        title = "Participación por rango etario en el Plebiscito Nacional Constituyente 2020",
        subtitle = "San Pedro de la Paz. Padrón total: 87.799",
        caption = "Fuente de los datos: www.servel.cl") +
  geom_text(aes(label = scales::percent(round((..count..)/sum(..count..),3)),
                y= ((..count..)/sum(..count..))), stat="count", position = position_dodge(width = 1),
            vjust = .1, hjust = -15, size = 2.6) + 
  scale_y_continuous(limits = c(0, 6000), breaks = c(0, 1500, 3000, 4500, 6000))


# GENERO

votos_plebiscito%>%
  ggplot(aes(x = Sexo, fill = Sufragio)) +
  geom_bar(position = "dodge") +
  labs (x = "", 
        y = " ", 
        fill = "Participación",
        title = "Sufragio femenino y masculino para Plebiscito Nacional Constituyente 2020",
        subtitle = "San Pedro de la Paz. Padrón total: 87.799",
        caption = "Fuente de los datos: www.servel.cl")  +
  geom_text(aes(label = scales::percent((..count..)/sum(..count..)),
                y= ((..count..)/sum(..count..))), stat="count", position = position_dodge(width = 1),
            vjust = 1, size = 3.5)

#PROBANDO ÑEÑES ----- 

votos_plebiscito%>%
  ggplot(aes(x = Sexo, fill = Sufragio)) +
  geom_bar(position = "dodge") +
  labs (x = "", 
        y = " ", 
        fill = "Participación",
        title = "Sufragio femenino y masculino para Plebiscito Nacional Constituyente 2020",
        subtitle = "San Pedro de la Paz. Padrón total: 87.799",
        caption = "Fuente de los datos: www.servel.cl") + 
  geom_text(aes(label = scales::percent((..count..)/sum(..count..)),
                y= ((..count..)/sum(..count..))), stat="count",
            vjust = 0.5, hjust = 0.5, size = 3)


votos_plebiscito%>%
  ggplot(aes(x = Sexo, fill = Sufragio)) +
  geom_bar(position = "dodge") +
  labs (x = "", 
        y = " ", 
        fill = "Participación",
        title = "Sufragio femenino y masculino para Plebiscito Nacional Constituyente 2020",
        subtitle = "San Pedro de la Paz. Padrón total: 87.799",
        caption = "Fuente de los datos: www.servel.cl") 

votos_plebiscito%>%
  ggplot(aes(x = Rango.Edad, fill = Sufragio)) +
  geom_bar(position = "dodge") +
  theme_minimal() +
  coord_flip() + 
  labs (x = "Rango etario", 
        y = " ", 
        fill = "Participación",
        title = "Participación por rango etario en el Plebiscito Nacional Constituyente 2020",
        subtitle = "San Pedro de la Paz. Padrón total: 87.799",
        caption = "Fuente de los datos: www.servel.cl") +
  geom_text(aes(label = scales::percent(round((..count..)/sum(..count..),3)),
                y= ((..count..)/sum(..count..))), stat="count", position = position_dodge(width = 1),
            vjust = .1, hjust = -14, size = 2.6)


count(votos_plebiscito$Rango.Edad)%>%
  View()

?levels

str(votos_plebiscito)

levels(votos_plebiscito$Rango.Edad,)

any_na(votos_plebiscito)

votos_plebiscito%>%
  summarise(total = )
