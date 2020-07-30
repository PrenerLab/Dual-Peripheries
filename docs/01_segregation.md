02 - Historic Segregation in St. Louis
================
Your Name
(July 30, 2020)

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
library(ggplot2)
```

    ## Warning: package 'ggplot2' was built under R version 4.0.2

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

## Store Results

Next, we’ll store our spatial data:

``` r
tracts %>%
  st_transform(crs = 4326) %>%
  st_write(here::here("results", "STL_DEMOGRAPHY_ICE", "STL_DEMOGRAPHY_ICE.geojson"), delete_dsn = TRUE)
```

    ## Deleting source `/Users/prenercg/GitHub/PrenerLab/Dueling-Peripheries/results/STL_DEMOGRAPHY_ICE/STL_DEMOGRAPHY_ICE.geojson' using driver `GeoJSON'
    ## Writing layer `STL_DEMOGRAPHY_ICE' to data source `/Users/prenercg/GitHub/PrenerLab/Dueling-Peripheries/results/STL_DEMOGRAPHY_ICE/STL_DEMOGRAPHY_ICE.geojson' using driver `GeoJSON'
    ## Writing 305 features with 10 fields and geometry type Polygon.

## Create Map

``` r
counties <- st_read(here::here("data", "STL_BOUNDARY_Counties", "STL_BOUNDARY_Counties.geojson")) %>%
  st_transform(crs = 26915)
```

    ## Reading layer `STL_BOUNDARY_Counties' from data source `/Users/prenercg/GitHub/PrenerLab/Dueling-Peripheries/data/STL_BOUNDARY_Counties/STL_BOUNDARY_Counties.geojson' using driver `GeoJSON'
    ## Simple feature collection with 2 features and 2 fields
    ## geometry type:  MULTIPOLYGON
    ## dimension:      XY
    ## bbox:           xmin: -90.73653 ymin: 38.3883 xmax: -90.11771 ymax: 38.89118
    ## geographic CRS: WGS 84

``` r
symbolic_roads <- st_read(here::here("data", "STL_TRANS_Symbolic_Roads", "STL_TRANS_Symbolic_Roads.geojson")) %>%
  st_transform(crs = 26915) %>%
  filter(FULLNAME == "Delmar Blvd")
```

    ## Reading layer `STL_TRANS_Symbolic_Roads' from data source `/Users/prenercg/GitHub/PrenerLab/Dueling-Peripheries/data/STL_TRANS_Symbolic_Roads/STL_TRANS_Symbolic_Roads.geojson' using driver `GeoJSON'
    ## Simple feature collection with 29 features and 1 field
    ## geometry type:  LINESTRING
    ## dimension:      XY
    ## bbox:           xmin: -90.55852 ymin: 38.59567 xmax: -90.18193 ymax: 38.69641
    ## geographic CRS: NAD83

``` r
tracts %>%
  select(geoid, ice_1940, ice_1950, ice_1970, ice_1990, ice_2010, ice_2018) %>%
  gather("period", "ice", ice_1940:ice_2018) %>%
  select(geoid, period, ice) %>%
  mutate(period = case_when(
   period == "ice_1940" ~ "1940", 
   period == "ice_1950" ~ "1950",
   period == "ice_1970" ~ "1970",
   period == "ice_1990" ~ "1990",
   period == "ice_2010" ~ "2010",
   period == "ice_2018" ~ "2018"
  )) %>%
  mutate(ice = ifelse(ice > 1, 1, ice)) -> tracts_long

categories <- cut(tracts_long$ice, breaks = seq(-1, 1, length.out = 7), include.lowest = TRUE, dig.lab = 2)

tracts_long <- mutate(tracts_long, cat = categories)

tracts_long$cat %>%
  forcats::fct_relabel(~ gsub(",", " to ", .x)) %>%
  forcats::fct_relabel(~ gsub("\\(", "", .x)) %>%
  forcats::fct_relabel(~ gsub("\\[", "", .x)) %>%
  forcats::fct_relabel(~ gsub("\\]", "", .x)) -> tracts_long$cat

p <- ggplot(data = tracts_long, mapping = aes(fill = cat)) +
  geom_sf(size = .2) +
  geom_sf(data = counties, fill = NA, size = .6, color = "black") +
  geom_sf(data = symbolic_roads, fill = NA, size = 1, color = "white") +
  scale_fill_brewer(palette = "RdBu", name = "ICE") +
  cowplot::theme_map() +
  facet_wrap(~period, ncol = 2)

ggsave(here::here("results", "figures", "ice_multiples.png"), p, width = 7.5, height = 10.5, units = "in", dpi = 500)
```
