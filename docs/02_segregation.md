02 - Historic Segregation in St. Louis
================
Your Name
(July 29, 2020)

## Introduction

This notebook maps calculates segregation measures for each time period
within the study.

## Dependencies

This notebook requires the following packages:

``` r
# tidyverse packages
library(dplyr)
```

    ## 
    ## Attaching package: 'dplyr'

    ## The following objects are masked from 'package:stats':
    ## 
    ##     filter, lag

    ## The following objects are masked from 'package:base':
    ## 
    ##     intersect, setdiff, setequal, union

``` r
library(tidyr)

# spatial packages
library(sf)
```

    ## Warning: package 'sf' was built under R version 4.0.2

    ## Linking to GEOS 3.8.1, GDAL 3.1.1, PROJ 6.3.1

``` r
# other packages
library(DBI)
```

## Load Data

All of the historical data are stored in a SQLite database stored in
this repository as a submodule. In addition, we’ll need our census tract
boundary data.

``` r
## establish SQLite connection
con <- dbConnect(RSQLite::SQLite(), here::here("data", "STL_DEMOGRAPHY_TractPop", "data", "STL_CITY_COUNTY_Database.sqlite"))

## tracts
tracts <- st_read(here::here("data", "STL_BOUNDARY_Tracts_2010", "STL_BOUNDARY_Tracts_2010.geojson")) %>%
  st_transform(crs = 26915) %>%
  rename(geoid = GEOID)
```

    ## Reading layer `STL_BOUNDARY_Tracts_2010' from data source `/Users/prenercg/GitHub/PrenerLab/Dueling-Peripheries/data/STL_BOUNDARY_Tracts_2010/STL_BOUNDARY_Tracts_2010.geojson' using driver `GeoJSON'
    ## Simple feature collection with 305 features and 1 field
    ## geometry type:  POLYGON
    ## dimension:      XY
    ## bbox:           xmin: -90.73653 ymin: 38.3883 xmax: -90.11771 ymax: 38.89118
    ## geographic CRS: WGS 84

## Calculate Segregation

### 1940

In order to calculate the segregation measure ICE, we need to extract
data on race out of the SQL database:

``` r
## collect value
tbl(con, "population") %>%
  filter(year == "1940") %>%
  collect() -> pop

## collect race
tbl(con, "race") %>%
  filter(year == "1940") %>%
  collect() -> race
```

The data are in “long” form, so we need to convert them to “wide” data
before proceeding:

``` r
race <- pivot_wider(race, names_from = "category", values_from = "value") %>%
  select(-year)
```

Finally, we’ll calculate ICE and then join it with our tract master
object:

``` r
left_join(pop, race, by = "geoid") %>%
  mutate(ice_1940 = (white-black)/value) %>%
  select(geoid, ice_1940) %>%
  left_join(tracts, ., by = "geoid") -> tracts
```

### 1950

We’ll repeat the process for 1950:

``` r
## collect value
tbl(con, "population") %>%
  filter(year == "1950") %>%
  collect() -> pop

## collect race
tbl(con, "race") %>%
  filter(year == "1950") %>%
  collect() -> race

## pivot
race <- pivot_wider(race, names_from = "category", values_from = "value") %>%
  select(-year)

## calculate ice
left_join(pop, race, by = "geoid") %>%
  mutate(ice_1950 = (white-black)/value) %>%
  select(geoid, ice_1950) %>%
  left_join(tracts, ., by = "geoid") -> tracts
```

### 1960

We’ll repeat the process for 1960:

``` r
## collect value
tbl(con, "population") %>%
  filter(year == "1960") %>%
  collect() -> pop

## collect race
tbl(con, "race") %>%
  filter(year == "1960") %>%
  collect() -> race

## pivot
race <- pivot_wider(race, names_from = "category", values_from = "value") %>%
  select(-year)

## calculate ice
left_join(pop, race, by = "geoid") %>%
  mutate(ice_1960 = (white-black)/value) %>%
  select(geoid, ice_1960) %>%
  left_join(tracts, ., by = "geoid") -> tracts
```

### 1970

We’ll repeat the process for 1970:

``` r
## collect value
tbl(con, "population") %>%
  filter(year == "1970") %>%
  collect() -> pop

## collect race
tbl(con, "race") %>%
  filter(year == "1970") %>%
  collect() -> race

## pivot
race <- pivot_wider(race, names_from = "category", values_from = "value") %>%
  select(-year)

## calculate ice
left_join(pop, race, by = "geoid") %>%
  mutate(ice_1970 = (white-black)/value) %>%
  select(geoid, ice_1970) %>%
  left_join(tracts, ., by = "geoid") -> tracts
```

### 1980

We’ll repeat the process for 1980:

``` r
## collect value
tbl(con, "population") %>%
  filter(year == "1980") %>%
  collect() -> pop

## collect race
tbl(con, "race") %>%
  filter(year == "1980") %>%
  collect() -> race

## pivot
race <- pivot_wider(race, names_from = "category", values_from = "value") %>%
  select(-year)

## calculate ice
left_join(pop, race, by = "geoid") %>%
  mutate(ice_1980 = (white-black)/value) %>%
  select(geoid, ice_1980) %>%
  left_join(tracts, ., by = "geoid") -> tracts
```

### 1990

We’ll repeat the process for 1990:

``` r
## collect value
tbl(con, "population") %>%
  filter(year == "1990") %>%
  collect() -> pop

## collect race
tbl(con, "race") %>%
  filter(year == "1990") %>%
  collect() -> race

## pivot
race <- pivot_wider(race, names_from = "category", values_from = "value") %>%
  select(-year)

## calculate ice
left_join(pop, race, by = "geoid") %>%
  mutate(ice_1990 = (white-black)/value) %>%
  select(geoid, ice_1990) %>%
  left_join(tracts, ., by = "geoid") -> tracts
```

### 2000

We’ll repeat the process for 2000:

``` r
## collect value
tbl(con, "population") %>%
  filter(year == "2000") %>%
  collect() -> pop

## collect race
tbl(con, "race") %>%
  filter(year == "2000") %>%
  collect() -> race

## pivot
race <- pivot_wider(race, names_from = "category", values_from = "value") %>%
  select(-year)

## calculate ice
left_join(pop, race, by = "geoid") %>%
  mutate(ice_2000 = (white-black)/value) %>%
  select(geoid, ice_2000) %>%
  left_join(tracts, ., by = "geoid") -> tracts
```

### 2010

We’ll repeat the process for 2010:

``` r
## collect value
tbl(con, "population") %>%
  filter(year == "2010") %>%
  collect() -> pop

## collect race
tbl(con, "race") %>%
  filter(year == "2010") %>%
  collect() -> race

## pivot
race <- pivot_wider(race, names_from = "category", values_from = "value") %>%
  select(-year)

## calculate ice
left_join(pop, race, by = "geoid") %>%
  mutate(ice_2010 = (white-black)/value) %>%
  select(geoid, ice_2010) %>%
  left_join(tracts, ., by = "geoid") -> tracts
```

### 2018

We’ll repeat the process for 2018:

``` r
## collect value
tbl(con, "population") %>%
  filter(year == "2018") %>%
  collect() -> pop

## collect race
tbl(con, "race") %>%
  filter(year == "2018") %>%
  collect() -> race

## pivot
race <- pivot_wider(race, names_from = "category", values_from = "value") %>%
  select(-year)

## calculate ice
left_join(pop, race, by = "geoid") %>%
  mutate(ice_2018 = (white-black)/value) %>%
  select(geoid, ice_2018) %>%
  left_join(tracts, ., by = "geoid") -> tracts
```

## Issues

value and race out of whack for 1950, 1960; totally missing for 1970;
1990 and 2000 have something weird going on with a tract each

2017 has more observations for pop than race?

2018 is missing
