#### Relational Data ----

#To work with relational data you need verbs that work with pairs of tables. There are three families of verbs designed to work with relational data:
  
  #Mutating joins, which add new variables to one data frame from matching observations in another.

  #Filtering joins, which filter observations from one data frame based on whether or not they match an observation in the other table.

#Set operations, which treat observations as if they were set elements.

library(tidyverse)
library(nycflights13)

airlines
#> # A tibble: 16 x 2
#>   carrier name                    
#>   <chr>   <chr>                   
#> 1 9E      Endeavor Air Inc.       
#> 2 AA      American Airlines Inc.  
#> 3 AS      Alaska Airlines Inc.    
#> 4 B6      JetBlue Airways         
#> 5 DL      Delta Air Lines Inc.    
#> 6 EV      ExpressJet Airlines Inc.
#> # … with 10 more rows

airports
#> # A tibble: 1,458 x 8
#>   faa   name                          lat   lon   alt    tz dst   tzone         
#>   <chr> <chr>                       <dbl> <dbl> <dbl> <dbl> <chr> <chr>         
#> 1 04G   Lansdowne Airport            41.1 -80.6  1044    -5 A     America/New_Y…
#> 2 06A   Moton Field Municipal Airp…  32.5 -85.7   264    -6 A     America/Chica…
#> 3 06C   Schaumburg Regional          42.0 -88.1   801    -6 A     America/Chica…
#> 4 06N   Randall Airport              41.4 -74.4   523    -5 A     America/New_Y…
#> 5 09J   Jekyll Island Airport        31.1 -81.4    11    -5 A     America/New_Y…
#> 6 0A9   Elizabethton Municipal Air…  36.4 -82.2  1593    -5 A     America/New_Y…
#> # … with 1,452 more rows


airports
#> # A tibble: 1,458 x 8
#>   faa   name                          lat   lon   alt    tz dst   tzone         
#>   <chr> <chr>                       <dbl> <dbl> <dbl> <dbl> <chr> <chr>         
#> 1 04G   Lansdowne Airport            41.1 -80.6  1044    -5 A     America/New_Y…
#> 2 06A   Moton Field Municipal Airp…  32.5 -85.7   264    -6 A     America/Chica…
#> 3 06C   Schaumburg Regional          42.0 -88.1   801    -6 A     America/Chica…
#> 4 06N   Randall Airport              41.4 -74.4   523    -5 A     America/New_Y…
#> 5 09J   Jekyll Island Airport        31.1 -81.4    11    -5 A     America/New_Y…
#> 6 0A9   Elizabethton Municipal Air…  36.4 -82.2  1593    -5 A     America/New_Y…
#> # … with 1,452 more rows


planes
#> # A tibble: 3,322 x 9
#>   tailnum  year type           manufacturer   model  engines seats speed engine 
#>   <chr>   <int> <chr>          <chr>          <chr>    <int> <int> <int> <chr>  
#> 1 N10156   2004 Fixed wing mu… EMBRAER        EMB-1…       2    55    NA Turbo-…
#> 2 N102UW   1998 Fixed wing mu… AIRBUS INDUST… A320-…       2   182    NA Turbo-…
#> 3 N103US   1999 Fixed wing mu… AIRBUS INDUST… A320-…       2   182    NA Turbo-…
#> 4 N104UW   1999 Fixed wing mu… AIRBUS INDUST… A320-…       2   182    NA Turbo-…
#> 5 N10575   2002 Fixed wing mu… EMBRAER        EMB-1…       2    55    NA Turbo-…
#> 6 N105UW   1999 Fixed wing mu… AIRBUS INDUST… A320-…       2   182    NA Turbo-…
#> # … with 3,316 more rows

weather
#> # A tibble: 26,115 x 15
#>   origin  year month   day  hour  temp  dewp humid wind_dir wind_speed wind_gust
#>   <chr>  <int> <int> <int> <int> <dbl> <dbl> <dbl>    <dbl>      <dbl>     <dbl>
#> 1 EWR     2013     1     1     1  39.0  26.1  59.4      270      10.4         NA
#> 2 EWR     2013     1     1     2  39.0  27.0  61.6      250       8.06        NA
#> 3 EWR     2013     1     1     3  39.0  28.0  64.4      240      11.5         NA
#> 4 EWR     2013     1     1     4  39.9  28.0  62.2      250      12.7         NA
#> 5 EWR     2013     1     1     5  39.0  28.0  64.4      260      12.7         NA
#> 6 EWR     2013     1     1     6  37.9  28.0  67.2      240      11.5         NA
#> # … with 26,109 more rows, and 4 more variables: precip <dbl>, pressure <dbl>,
#> #   visib <dbl>, time_hour <dttm>


          # For nycflights13:
  
# flights connects to planes via a single variable, tailnum.

# flights connects to airlines through the carrier variable.

# flights connects to airports in two ways: via the origin and dest variables.

# flights connects to weather via origin (the location), and year, month, day and hour (the time).


      # KEYS

# The variables used to connect each pair of tables are called keys. A key is a variable (or set of variables) that uniquely identifies an observation. 

# two types of keys:
  
  # A primary key uniquely identifies an observation in its own table. For example, planes$tailnum is a primary key because it uniquely identifies each plane in the planes table.

  # A foreign key uniquely identifies an observation in another table. For example, flights$tailnum is a foreign key because it appears in the flights table where it matches each flight to a unique plane.


#Once you’ve identified the primary keys in your tables, it’s good practice to verify that they do indeed uniquely identify each observation. One way to do that is to count() the primary keys and look for entries where n is greater than one:

planes %>% 
  count(tailnum) %>% 
  filter(n > 1)
#> # A tibble: 0 x 2
#> # … with 2 variables: tailnum <chr>, n <int>

weather %>% 
  count(year, month, day, hour, origin) %>% 
  filter(n > 1)
#> # A tibble: 3 x 6
#>    year month   day  hour origin     n
#>   <int> <int> <int> <int> <chr>  <int>
#> 1  2013    11     3     1 EWR        2
#> 2  2013    11     3     1 JFK        2
#> 3  2013    11     3     1 LGA        2


flights %>% 
  count(year, month, day, flight) %>% 
  filter(n > 1)
#> # A tibble: 29,768 x 5
#>    year month   day flight     n
#>   <int> <int> <int>  <int> <int>
#> 1  2013     1     1      1     2
#> 2  2013     1     1      3     2
#> 3  2013     1     1      4     2
#> 4  2013     1     1     11     3
#> 5  2013     1     1     15     2
#> 6  2013     1     1     21     2
#> # … with 29,762 more rows

flights %>% 
  count(year, month, day, tailnum) %>% 
  filter(n > 1)
#> # A tibble: 64,928 x 5
#>    year month   day tailnum     n
#>   <int> <int> <int> <chr>   <int>
#> 1  2013     1     1 N0EGMQ      2
#> 2  2013     1     1 N11189      2
#> 3  2013     1     1 N11536      2
#> 4  2013     1     1 N11544      3
#> 5  2013     1     1 N11551      2
#> 6  2013     1     1 N12540      2
#> # … with 64,922 more rows


# If a table lacks a primary key, it’s sometimes useful to add one with mutate() and row_number(). 
# That makes it easier to match observations if you’ve done some filtering and want to check 
# back in with the original data. This is called a surrogate key.

# A primary key and the corresponding foreign key in another table form a relation. 


#For example, in this data there’s a many-to-many relationship between airlines and airports: each airline flies to many airports; each airport hosts many airlines.



        # MUTATING JOINS -----

# A mutating join allows you to combine variables from two tables. It first matches observations by their keys, then copies across variables from one table to the other.

flights2 <- flights %>% 
  select(year:day, hour, origin, dest, tailnum, carrier)
flights2
#> # A tibble: 336,776 x 8
#>    year month   day  hour origin dest  tailnum carrier
#>   <int> <int> <int> <dbl> <chr>  <chr> <chr>   <chr>  
#> 1  2013     1     1     5 EWR    IAH   N14228  UA     
#> 2  2013     1     1     5 LGA    IAH   N24211  UA     
#> 3  2013     1     1     5 JFK    MIA   N619AA  AA     
#> 4  2013     1     1     5 JFK    BQN   N804JB  B6     
#> 5  2013     1     1     6 LGA    ATL   N668DN  DL     
#> 6  2013     1     1     5 EWR    ORD   N39463  UA     
#> # … with 336,770 more rows

      # Imagine you want to add the full airline name to the flights2 data. You can combine the airlines and flights2 data frames with left_join():

flights2 %>%
  select(-origin, -dest) %>% 
  left_join(airlines, by = "carrier")
#> # A tibble: 336,776 x 7
#>    year month   day  hour tailnum carrier name                  
#>   <int> <int> <int> <dbl> <chr>   <chr>   <chr>                 
#> 1  2013     1     1     5 N14228  UA      United Air Lines Inc. 
#> 2  2013     1     1     5 N24211  UA      United Air Lines Inc. 
#> 3  2013     1     1     5 N619AA  AA      American Airlines Inc.
#> 4  2013     1     1     5 N804JB  B6      JetBlue Airways       
#> 5  2013     1     1     6 N668DN  DL      Delta Air Lines Inc.  
#> 6  2013     1     1     5 N39463  UA      United Air Lines Inc. 
#> # … with 336,770 more rows

    #this is why it could be called mutated join, its the same as the below

flights2 %>%
  select(-origin, -dest) %>% 
  mutate(name = airlines$name[match(carrier, airlines$carrier)])
#> # A tibble: 336,776 x 7
#>    year month   day  hour tailnum carrier name                  
#>   <int> <int> <int> <dbl> <chr>   <chr>   <chr>                 
#> 1  2013     1     1     5 N14228  UA      United Air Lines Inc. 
#> 2  2013     1     1     5 N24211  UA      United Air Lines Inc. 
#> 3  2013     1     1     5 N619AA  AA      American Airlines Inc.
#> 4  2013     1     1     5 N804JB  B6      JetBlue Airways       
#> 5  2013     1     1     6 N668DN  DL      Delta Air Lines Inc.  
#> 6  2013     1     1     5 N39463  UA      United Air Lines Inc. 
#> # … with 336,770 more rows




x <- tribble(
  ~key, ~val_x,
  1, "x1",
  2, "x2",
  3, "x3"
)
y <- tribble(
  ~key, ~val_y,
  1, "y1",
  2, "y2",
  4, "y3"
)


    # inner join

# An inner join matches pairs of observations whenever their keys are equal


x %>% 
  inner_join(y, by = "key")
#> # A tibble: 2 x 3
#>     key val_x val_y
#>   <dbl> <chr> <chr>
#> 1     1 x1    y1   
#> 2     2 x2    y2

    # unmatched rows are not included in the result. This means that generally inner joins are usually not appropriate for use in analysis because it’s too easy to lose observations.


        # Outer joins

# An outer join keeps observations that appear in at least one of the tables.


    # A left join keeps all observations in x.
    # A right join keeps all observations in y.
    # A full join keeps all observations in x and y.

        # Duplicate keys
x <- tribble(
  ~key, ~val_x,
  1, "x1",
  2, "x2",
  2, "x3",
  1, "x4"
)
y <- tribble(
  ~key, ~val_y,
  1, "y1",
  2, "y2"
)
left_join(x, y, by = "key")
#> # A tibble: 4 x 3
#>     key val_x val_y
#>   <dbl> <chr> <chr>
#> 1     1 x1    y1   
#> 2     2 x2    y2   
#> 3     2 x3    y2   
#> 4     1 x4    y1

# 1 table has duplicate keys


x <- tribble(
  ~key, ~val_x,
  1, "x1",
  2, "x2",
  2, "x3",
  3, "x4"
)
y <- tribble(
  ~key, ~val_y,
  1, "y1",
  2, "y2",
  2, "y3",
  3, "y4"
)
left_join(x, y, by = "key")
#> # A tibble: 6 x 3
#>     key val_x val_y
#>   <dbl> <chr> <chr>
#> 1     1 x1    y1   
#> 2     2 x2    y2   
#> 3     2 x2    y3   
#> 4     2 x3    y2   
#> 5     2 x3    y3   
#> 6     3 x4    y4

# both tables have duplicate keys


## Definig the key columns 

  # The default, by = NULL, uses all variables that appear in both tables, the so called natural join.

flights2 %>% 
  left_join(weather)
#> Joining, by = c("year", "month", "day", "hour", "origin")
#> # A tibble: 336,776 x 18
#>    year month   day  hour origin dest  tailnum carrier  temp  dewp humid
#>   <int> <int> <int> <dbl> <chr>  <chr> <chr>   <chr>   <dbl> <dbl> <dbl>
#> 1  2013     1     1     5 EWR    IAH   N14228  UA       39.0  28.0  64.4
#> 2  2013     1     1     5 LGA    IAH   N24211  UA       39.9  25.0  54.8
#> 3  2013     1     1     5 JFK    MIA   N619AA  AA       39.0  27.0  61.6
#> 4  2013     1     1     5 JFK    BQN   N804JB  B6       39.0  27.0  61.6
#> 5  2013     1     1     6 LGA    ATL   N668DN  DL       39.9  25.0  54.8
#> 6  2013     1     1     5 EWR    ORD   N39463  UA       39.0  28.0  64.4
#> # … with 336,770 more rows, and 7 more variables: wind_dir <dbl>,
#> #   wind_speed <dbl>, wind_gust <dbl>, precip <dbl>, pressure <dbl>,
#> #   visib <dbl>, time_hour <dttm>

  # A character vector, by = "x". This is like a natural join, but uses only some of the common variables.

flights2 %>% 
  left_join(planes, by = "tailnum")
#> # A tibble: 336,776 x 16
#>   year.x month   day  hour origin dest  tailnum carrier year.y type 
#>    <int> <int> <int> <dbl> <chr>  <chr> <chr>   <chr>    <int> <chr>
#> 1   2013     1     1     5 EWR    IAH   N14228  UA        1999 Fixe…
#> 2   2013     1     1     5 LGA    IAH   N24211  UA        1998 Fixe…
#> 3   2013     1     1     5 JFK    MIA   N619AA  AA        1990 Fixe…
#> 4   2013     1     1     5 JFK    BQN   N804JB  B6        2012 Fixe…
#> 5   2013     1     1     6 LGA    ATL   N668DN  DL        1991 Fixe…
#> 6   2013     1     1     5 EWR    ORD   N39463  UA        2012 Fixe…
#> # … with 336,770 more rows, and 6 more variables: manufacturer <chr>,
#> #   model <chr>, engines <int>, seats <int>, speed <int>, engine <chr>

    # A named character vector: by = c("a" = "b"). This will match variable a in table x to variable b in table y. The variables from x will be used in the output.

flights2 %>% 
  left_join(airports, c("dest" = "faa"))
#> # A tibble: 336,776 x 15
#>    year month   day  hour origin dest  tailnum carrier name    lat   lon   alt
#>   <int> <int> <int> <dbl> <chr>  <chr> <chr>   <chr>   <chr> <dbl> <dbl> <dbl>
#> 1  2013     1     1     5 EWR    IAH   N14228  UA      Geor…  30.0 -95.3    97
#> 2  2013     1     1     5 LGA    IAH   N24211  UA      Geor…  30.0 -95.3    97
#> 3  2013     1     1     5 JFK    MIA   N619AA  AA      Miam…  25.8 -80.3     8
#> 4  2013     1     1     5 JFK    BQN   N804JB  B6      <NA>   NA    NA      NA
#> 5  2013     1     1     6 LGA    ATL   N668DN  DL      Hart…  33.6 -84.4  1026
#> 6  2013     1     1     5 EWR    ORD   N39463  UA      Chic…  42.0 -87.9   668
#> # … with 336,770 more rows, and 3 more variables: tz <dbl>, dst <chr>,
#> #   tzone <chr>

flights2 %>% 
  left_join(airports, c("origin" = "faa"))
#> # A tibble: 336,776 x 15
#>    year month   day  hour origin dest  tailnum carrier name    lat   lon   alt
#>   <int> <int> <int> <dbl> <chr>  <chr> <chr>   <chr>   <chr> <dbl> <dbl> <dbl>
#> 1  2013     1     1     5 EWR    IAH   N14228  UA      Newa…  40.7 -74.2    18
#> 2  2013     1     1     5 LGA    IAH   N24211  UA      La G…  40.8 -73.9    22
#> 3  2013     1     1     5 JFK    MIA   N619AA  AA      John…  40.6 -73.8    13
#> 4  2013     1     1     5 JFK    BQN   N804JB  B6      John…  40.6 -73.8    13
#> 5  2013     1     1     6 LGA    ATL   N668DN  DL      La G…  40.8 -73.9    22
#> 6  2013     1     1     5 EWR    ORD   N39463  UA      Newa…  40.7 -74.2    18
#> # … with 336,770 more rows, and 3 more variables: tz <dbl>, dst <chr>,
#> #   tzone <chr>


      ## FILTERING JOINS ----

# Filtering joins match observations in the same way as mutating joins, but affect the observations, not the variables. There are two types:

    #semi_join(x, y) keeps all observations in x that have a match in y.
    #anti_join(x, y) drops all observations in x that have a match in y.

# Semi-joins are useful for matching filtered summary tables back to the original rows. For example, imagine you’ve found the top ten most popular destinations:
  
  top_dest <- flights %>%
  count(dest, sort = TRUE) %>%
  head(10)
top_dest
#> # A tibble: 10 x 2
#>   dest      n
#>   <chr> <int>
#> 1 ORD   17283
#> 2 ATL   17215
#> 3 LAX   16174
#> 4 BOS   15508
#> 5 MCO   14082
#> 6 CLT   14064
#> # … with 4 more rows

# Now you want to find each flight that went to one of those destinations. You could construct a filter yourself:

flights %>% 
  filter(dest %in% top_dest$dest)
#> # A tibble: 141,145 x 19
#>    year month   day dep_time sched_dep_time dep_delay arr_time sched_arr_time
#>   <int> <int> <int>    <int>          <int>     <dbl>    <int>          <int>
#> 1  2013     1     1      542            540         2      923            850
#> 2  2013     1     1      554            600        -6      812            837
#> 3  2013     1     1      554            558        -4      740            728
#> 4  2013     1     1      555            600        -5      913            854
#> 5  2013     1     1      557            600        -3      838            846
#> 6  2013     1     1      558            600        -2      753            745
#> # … with 141,139 more rows, and 11 more variables: arr_delay <dbl>,
#> #   carrier <chr>, flight <int>, tailnum <chr>, origin <chr>, dest <chr>,
#> #   air_time <dbl>, distance <dbl>, hour <dbl>, minute <dbl>, time_hour <dttm>


# magine that you’d found the 10 days with highest average delays. How would you construct the filter statement that used year, month, and day to match it back to flights?

# Instead you can use a semi-join, which connects the two tables like a mutating join, but instead of adding new columns, only keeps the rows in x that have a match in y:
  
flights %>% 
  semi_join(top_dest)
#> Joining, by = "dest"
#> # A tibble: 141,145 x 19
#>    year month   day dep_time sched_dep_time dep_delay arr_time sched_arr_time
#>   <int> <int> <int>    <int>          <int>     <dbl>    <int>          <int>
#> 1  2013     1     1      542            540         2      923            850
#> 2  2013     1     1      554            600        -6      812            837
#> 3  2013     1     1      554            558        -4      740            728
#> 4  2013     1     1      555            600        -5      913            854
#> 5  2013     1     1      557            600        -3      838            846
#> 6  2013     1     1      558            600        -2      753            745
#> # … with 141,139 more rows, and 11 more variables: arr_delay <dbl>,
#> #   carrier <chr>, flight <int>, tailnum <chr>, origin <chr>, dest <chr>,
#> #   air_time <dbl>, distance <dbl>, hour <dbl>, minute <dbl>, time_hour <dttm>

# Anti-joins are useful for diagnosing join mismatches. For example, when connecting flights and planes, you might be interested to know that there are many flights that don’t have a match in planes:


flights %>%
  anti_join(planes, by = "tailnum") %>%
  count(tailnum, sort = TRUE)
#> # A tibble: 722 x 2
#>   tailnum     n
#>   <chr>   <int>
#> 1 <NA>     2512
#> 2 N725MQ    575
#> 3 N722MQ    513
#> 4 N723MQ    507
#> 5 N713MQ    483
#> 6 N735MQ    396
#> # … with 716 more rows