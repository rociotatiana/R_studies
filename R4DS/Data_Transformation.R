# https://exts.ggplot2.tidyverse.org/gallery/

###WORKFLOW BASICS -----

# Coding basics

1 / 200 * 30
(59 + 73 + 2) / 3
sin(pi / 2)

#you can create new objects

x <- 3 * 4
# object_name <- value
#shortcut = Alt + -

this_is_a_really_long_name <- 3.5

this_is_a_really_long_name

r_rocks <- 2 ^ 3
seq()

seq(1, 10)

x <- "hello world"
x <- "hello"

y <- seq(1, 10, length.out = 5)
y

y <- seq(1, 10, length.out = 5)
y

library(tidyverse)

ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy)) + 
  filter(mpg, cyl = 8) + 
  filter(diamond, carat > 3)

#Alt + Shift + K : SHORTCUTSSS

###DATA TRANSFORMATION------

library(nycflights13)
library(tidyverse)
library(dplyr)
?flights

flights

#tibbles son datas frames adecuadas para trabajar mejor en el tidyverse
#int stands for integers.
#dbl stands for doubles, or real numbers.
#chr stands for character vectors, or strings.
#dttm stands for date-times (a date + a time).
#lgl stands for logical, vectors that contain only TRUE or FALSE.
#fctr stands for factors, which R uses to represent categorical variables with fixed possible values.
#date stands for dates.

#PRINCIPALES FUNCIONES DE DPLYR

#Pick observations by their values (filter()).
#Reorder the rows (arrange()).
#Pick variables by their names (select()).
#Create new variables with functions of existing variables (mutate()).
#Collapse many values down to a single summary (summarise()).

#FILTER

filter(flights, month == 1, day == 1)

jan1 <- filter(flights, month == 1, day == 1)

(dec25 <- filter(flights, month == 12, day == 25))

#COMPARISONS

#standard suite: >, >=, <, <=, != (not equal), and == (equal).
filter(flights, month = 1) #atentos al error de poner 1 (=) en vez de 2 (==)

#floating points numbers? no entiendo, pero quizás se refiere a numeros casi infinitos.
sqrt(2) ^ 2 == 2
1 / 49 * 49 == 1

#SOLUCION: usar near en vez de ==

near(sqrt(2) ^ 2,  2)
near(1 / 49 * 49, 1)

#Logical operators

#Boolean operators: & is “and”, | is “or”, and ! is “not”

filter(flights, month == 11 | month == 12)

#NO USAR filter(flights, month == (11 | 12)), porque lo entiende como todos los meses que equivalen a 11|12, que se evalúa como TRUE y entonces se entiende como 1.
#solución x %in% y

nov_dec <- filter(flights, month %in% c(11, 12))

#De Morgan’s law: !(x & y) is the same as !x | !y, and !(x | y) is the same as !x & !y

#Para buscar aviones que no se retrasaron más de 2 horas

filter(flights, !(arr_delay > 120 | dep_delay > 120))
filter(flights, arr_delay <= 120, dep_delay <= 120)

#MISSING VALUES
#Evitarlos dentro de lo posible porque complican mucho la interpretación

is.na(x) #determinar si es un valor perdido
View(flights)

filter (flights, arr_delay >= 120)
filter (flights, dest %in% c(IAH, HOU))

?flights
filter (flights, dep_time %in% c(month == 7 | month == 8 | month == 10))

filter (flights, arr_time > 120 & dep_delay <= 0)

filter (flights, arr_delay >= 60 & air_time > 30)

filter (flights, hour >= 0 & hour <= 6)

?between
#shortcut for x >= left & x <= right
# between(1:12, 7, 9)

filter (flights, between (hour, 0, 6))

## PIPE -> %>%

by_dest <- group_by(flights, dest)
delay <- summarise(by_dest,
                   count = n(),
                   dist = mean(distance, na.rm = TRUE),
                   delay = mean(arr_delay, na.rm = TRUE)
)
delay
 #> `summarise()` ungrouping output (override with `.groups` argument)
delay <- filter(delay, count > 20, dest != "HNL")

# It looks like delays increase with distance up to ~750 miles 
# and then decrease. Maybe as flights get longer there's more 
# ability to make up delays in the air?
ggplot(data = delay, mapping = aes(x = dist, y = delay)) +
  geom_point(aes(size = count), alpha = 1/3) +
  geom_smooth(se = FALSE)
#> `geom_smooth()` using method = 'loess' and formula 'y ~ x'

group_by(flights, dest)

ggplot(data = by_dest, aes(month)) +
         geom_bar(fill = "hot pink", color = "green")
       
       
#WHATS UP WITH MISSING VALUES?

flights %>% 
  group_by(year, month, day) %>% 
  summarise(mean = mean(dep_delay))
#in this operation, we get a lot of NA because of the preexistence of NA. To solve this, we must put na.rm
#(it removes them)

flights %>% 
  group_by(year, month, day) %>% 
  summarise(mean = mean(dep_delay, na.rm = TRUE))

not_cancelled <- flights %>% 
  filter(!is.na(dep_delay), !is.na(arr_delay)) # hacer una variable q no tenga NA

not_cancelled %>% 
  group_by(year, month, day) %>% 
  summarise(mean = mean(dep_delay))

###COUNTS
#para no tomar conclusiones basandose en datos muy reducidos 

delays <- not_cancelled %>% 
  group_by(tailnum) %>% 
  summarise(
    delay = mean(arr_delay)
  )
#> `summarise()` ungrouping output (override with `.groups` argument)

ggplot(data = delay, mapping = aes(x = delay)) + 
  geom_freqpoly(binwidth = 10)

delays <- not_cancelled %>% 
  group_by(tailnum) %>% 
  summarise(
    delay = mean(arr_delay, na.rm = TRUE),
    n = n()
  )
ggplot(data = delays, mapping = aes(x = n, y = delay)) + 
  geom_point(alpha = 1/10)


delays %>% 
  filter(n > 25) %>% 
  ggplot(mapping = aes(x = n, y = delay)) + 
  geom_point(alpha = 1/10)


#baseball... or some shit

batting <- as_tibble(Lahman::Batting)

batters <- batting %>% 
  group_by(playerID) %>% 
  summarise(
    ba = sum(H, na.rm = TRUE) / sum(AB, na.rm = TRUE),
    ab = sum(AB, na.rm = TRUE)
  )
View(batting)

batters %>% 
  filter(ab > 100) %>% 
  ggplot(mapping = aes(x = ab, y = ba)) +
  geom_point() + 
  geom_smooth(se = FALSE)

###Useful summary functions

#measures of location: mean and median

not_cancelled %>% 
  group_by(year, month, day) %>% 
  summarise(
    avg_delay1 = mean(arr_delay),
    avg_delay2 = mean(arr_delay[arr_delay > 0]) # the average positive delay
  )
# Measures of spread: sd(x), IQR(x), mad(x). The root mean squared deviation, 
#or standard deviation sd(x), is the standard measure of spread. 
#The interquartile range IQR(x) and median absolute deviation mad(x) 
#are robust equivalents that may be more useful if you have outliers.

# Why is distance to some destinations more variable than to others?
not_cancelled %>% 
  group_by(dest) %>% 
  summarise(distance_sd = sd(distance)) %>% 
  arrange(desc(distance_sd))

#Measures of rank: min(x), quantile(x, 0.25), max(x). Quantiles are a generalisation of the 
#median. For example, quantile(x, 0.25) will find a value of x that is greater than 25% of 
#the values, and less than the remaining 75%.

# When do the first and last flights leave each day?
not_cancelled %>% 
  group_by(year, month, day) %>% 
  summarise(
    first = min(dep_time),
    last = max(dep_time)
  )


#Measures of position: first(x), nth(x, 2), last(x). These work similarly to x[1], x[2], and x[length(x)] but let you set a default value if that position does not exist (i.e. you’re trying to get the 3rd element from a group that only has two elements). For example, we can find the first and last departure for each day:
    
not_cancelled %>% 
  group_by(year, month, day) %>% 
  summarise(
    first_dep = first(dep_time), 
    last_dep = last(dep_time)
  )

#filtering on ranks

not_cancelled %>% 
  group_by(year, month, day) %>% 
  mutate(r = min_rank(desc(dep_time))) %>% 
  filter(r %in% range(r))

##Counts: You’ve seen n(), which takes no arguments, and returns the size of the current group. To count the number of non-missing values, use sum(!is.na(x)). To count the number of distinct (unique) values, use n_distinct(x).

# Which destinations have the most carriers?
not_cancelled %>% 
  group_by(dest) %>% 
  summarise(carriers = n_distinct(carrier)) %>% 
  arrange(desc(carriers))

#Counts are so useful that dplyr provides a simple helper if all you want is a count:

not_cancelled %>% 
  count(dest)

#You can optionally provide a weight variable. For example, you could use this to “count” (sum) the total number of miles a plane flew:

not_cancelled %>% 
  count(tailnum, wt = distance)

#Counts and proportions of logical values: sum(x > 10), mean(y == 0). When used with numeric functions, TRUE is converted to 1 and FALSE to 0. This makes sum() and mean() very useful: sum(x) gives the number of TRUEs in x, and mean(x) gives the proportion.

# How many flights left before 5am? (these usually indicate delayed
# flights from the previous day)
not_cancelled %>% 
  group_by(year, month, day) %>% 
  summarise(n_early = sum(dep_time < 500))

# What proportion of flights are delayed by more than an hour?
not_cancelled %>% 
  group_by(year, month, day) %>% 
  summarise(hour_prop = mean(arr_delay > 60))



## GROUPING BY MULTIPLE VARIABLES 

daily <- group_by(flights, year, month, day)
(per_day <- summarise(daily, flights = n()))

(per_month <- summarise(per_day, flights = sum(flights)))

(per_year  <- summarise(per_month, flights = sum(flights)))


## UNGROUPING

daily %>% 
  ungroup() %>%             # no longer grouped by date
  summarise(flights = n())  # all flights


##GROUP MUTATES
#Grouping is most useful in conjunction with summarise(), but you can also do convenient operations with mutate() and filter():

#Find the worst members of each group:
  
  flights_sml %>% 
  group_by(year, month, day) %>%
  filter(rank(desc(arr_delay)) < 10)
  
  
#Find all groups bigger than a threshold:
    
    popular_dests <- flights %>% 
    group_by(dest) %>% 
    filter(n() > 365)
  popular_dests
  
#Standardise to compute per group metrics:
    
    popular_dests %>% 
    filter(arr_delay > 0) %>% 
    mutate(prop_delay = arr_delay / sum(arr_delay)) %>% 
    select(year:day, dest, arr_delay, prop_delay)