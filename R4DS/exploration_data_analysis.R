####EXPLORATORY DATA ANALYSIS ----

#Ask yourself

#What type of variation occurs within my variables?
  
#What type of covariation occurs between my variables?


##VARIATION

#Visualizing distributions

#categorical or continous? 

#categorical: bar charts
ggplot(data = diamonds) +
  geom_bar(mapping = aes(x = cut))

#you can count this variance with count (table)
diamonds %>% 
  count(cut)


#CONTINOUS: histogram

ggplot(data = diamonds) +
  geom_histogram(mapping = aes(x = carat), binwidth = 0.5)

#You can compute this by hand by combining dplyr::count() and ggplot2::cut_width():

diamonds %>% 
  count(cut_width(carat, 0.5))

# explore with different binwidths

smaller <- diamonds %>% 
  filter(carat < 3)

ggplot(data = smaller, mapping = aes(x = carat)) +
  geom_histogram(binwidth = 0.1)

# If you wish to overlay multiple histograms in the same plot, 
#I recommend using geom_freqpoly() instead of geom_histogram(). 
#geom_freqpoly() performs the same calculation as geom_histogram(), but instead of displaying the counts with bars, uses lines instead. It’s much easier to understand overlapping lines than bars.

ggplot(data = smaller, mapping = aes(x = carat, colour = cut)) +
  geom_freqpoly(binwidth = 0.1)

#After this, begin asking yourself! The key to asking good follow-up questions will be to rely on your curiosity (What do you want to learn more about?) as well as your skepticism (How could this be misleading?).

#Typical values:

  #Which values are the most common? Why?
  
  #Which values are rare? Why? Does that match your expectations?
  
  #Can you see any unusual patterns? What might explain them?
  
#IN case of subgroup, or clusters

  #How are the observations within each cluster similar to each other?
  
  #How are the observations in separate clusters different from each other?
  
  #How can you explain or describe the clusters?
  
  #Why might the appearance of clusters be misleading?

#whats up with this 2 groups of eruptions?

ggplot(data = faithful, mapping = aes(x = eruptions)) + 
  geom_histogram(binwidth = 0.25)
  
#Unusual values

#outliers, data entry errors or new science. They could be difficult to se in an histogram (maybe points?)

ggplot(diamonds) + 
  geom_histogram(mapping = aes(x = y), binwidth = 0.5)

ggplot(diamonds) + 
  geom_histogram(mapping = aes(x = y), binwidth = 0.5) +
  coord_cartesian(ylim = c(0, 50))

ggplot(data = diamonds) +
  geom_histogram(mapping = aes(x = price), binwidth = 1)

#Missing values

#1 Drop the entire row with the strange values:

diamonds2 <- diamonds %>% 
  filter(between(y, 3, 20))

# or 2 Replace unussual values with missing values
diamonds2 <- diamonds %>% 
  mutate(y = ifelse(y < 3 | y > 20, NA, y))

#The easiest way to do this is to use mutate() to replace the variable with a modified copy. You can use the ifelse() function to replace unusual values with NA:

diamonds2 <- diamonds %>% 
  mutate(y = ifelse(y < 3 | y > 20, NA, y))
#ifelse() has three arguments. The first argument test should be a logical vector. The result will contain the value of the second argument, yes, when test is TRUE, and the value of the third argument, no, when it is false. Alternatively to ifelse, use dplyr::case_when(). case_when() is particularly useful inside mutate when you want to create a new variable that relies on a complex combination of existing variables.
#ggplot tells that there are values missing
ggplot(data = diamonds2, mapping = aes(x = x, y = y)) + 
  geom_point()

#To suppress that warning, set na.rm = TRUE:

ggplot(data = diamonds2, mapping = aes(x = x, y = y)) + 
  geom_point(na.rm = TRUE)


## COVARIATION ----

# A categorical and continuous variable

#freqpoly

ggplot(data = diamonds, mapping = aes(x = price)) + 
  geom_freqpoly(mapping = aes(colour = cut), binwidth = 500)

ggplot(diamonds) + 
  geom_bar(mapping = aes(x = cut))

#para uniformar la gran diferencia, se pide la densidad

ggplot(data = diamonds, mapping = aes(x = price, y = ..density..)) + 
  geom_freqpoly(mapping = aes(colour = cut), binwidth = 500)

#BOXPLOT

ggplot(data = diamonds, mapping = aes(x = cut, y = price)) +
  geom_boxplot() # diamantes de mayor calidad valen casi lo mismo que los normales

library(tidyverse)
library(ggplot2)

ggplot(data = mpg, mapping = aes(x = class, y = hwy)) +
  geom_boxplot() # pickup son los con peor hwy, seguido de suv

#reordenamos con el valor medio de hwy: reorder

ggplot(data = mpg) +
  geom_boxplot(mapping = aes(x = reorder(class, hwy, FUN = median), y = hwy))

#reordenar
ggplot(data = mpg) +
  geom_boxplot(mapping = aes(x = reorder(class, hwy, FUN = median), y = hwy)) +
  coord_flip()
?diamonds

ggplot(data = diamonds) +
  geom_lv(mapping = aes(x = reorder(cut, price, FUN = median), y = price))


#TWO CATEGORICAL VARIABLES

ggplot(data = diamonds) +
  geom_count(mapping = aes(x = cut, y = color))

diamonds %>% 
  count(color, cut)

diamonds %>% 
  count(color, cut) %>%  
  ggplot(mapping = aes(x = color, y = cut)) +
  geom_tile(mapping = aes(fill = n))

#TWO CONTINOUS VARIABLES

#scatterplot
ggplot(data = diamonds) +
  geom_point(mapping = aes(x = carat, y = price))

ggplot(data = diamonds) + 
  geom_point(mapping = aes(x = carat, y = price), alpha = 1 / 100)

ggplot(data = smaller) +
  geom_bin2d(mapping = aes(x = carat, y = price))

install.packages("hexbin")
library(hexbin)
ggplot(data = smaller) +
  geom_hex(mapping = aes(x = carat, y = price))

#bin carat?? divides x into bins of width
ggplot(data = smaller, mapping = aes(x = carat, y = price)) + 
  geom_boxplot(mapping = aes(group = cut_width(carat, 0.1)))

#we don't know how many points each boxplot summarizes, we do this to make the proporcionate size
ggplot(data = smaller, mapping = aes(x = carat, y = price)) + 
  geom_boxplot(mapping = aes(group = cut_number(carat, 20)))

#PATTERNS AND MODELS 

  #Could this pattern be due to coincidence (i.e. random chance)?
  
  #How can you describe the relationship implied by the pattern?
  
  #How strong is the relationship implied by the pattern?
  
  #What other variables might affect the relationship?
  
  #Does the relationship change if you look at individual subgroups of the data?
  
ggplot(data = faithful) + 
  geom_point(mapping = aes(x = eruptions, y = waiting))


library(modelr)

mod <- lm(log(price) ~ log(carat), data = diamonds)

diamonds2 <- diamonds %>% 
  add_residuals(mod) %>% 
  mutate(resid = exp(resid))

ggplot(data = diamonds2) + 
  geom_point(mapping = aes(x = carat, y = resid))

ggplot(data = diamonds2) + 
  geom_boxplot(mapping = aes(x = cut, y = resid))

##GGPLOT CALLS

ggplot(data = faithful, mapping = aes(x = eruptions)) + 
  geom_freqpoly(binwidth = 0.25)


ggplot(faithful, aes(eruptions)) + 
  geom_freqpoly(binwidth = 0.25)


diamonds %>% 
  count(cut, clarity) %>% 
  ggplot(aes(clarity, cut, fill = n)) + 
  geom_tile()



####WORKFLOW -----
getwd()


library(tidyverse)

ggplot(diamonds, aes(carat, price)) + 
  geom_hex()
ggsave("diamonds.pdf")

write_csv(diamonds, "diamonds.csv")
