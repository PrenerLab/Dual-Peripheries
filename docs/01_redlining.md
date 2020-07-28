01 - Redlining in St. Louis
================
Your Name
(July 28, 2020)

## Introduction

This notebook maps redlining boundaries to contemporary census tracts in
St. Louis City and County.

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
# spatial packages
library(sf)
```

    ## Warning: package 'sf' was built under R version 4.0.2

    ## Linking to GEOS 3.8.1, GDAL 3.1.1, PROJ 6.3.1

``` r
# other packages
library(measurements)
```

    ## Warning: package 'measurements' was built under R version 4.0.2

## Load Data

This notebook requires redlining boundary data as well as the 2010 U.S.
Census tract boundaries:

``` r
## tracts
tracts <- st_read(here::here("data", "STL_BOUNDARY_Tracts_2010", "STL_BOUNDARY_Tracts_2010.geojson")) %>%
  st_transform(crs = 26915)
```

    ## Reading layer `STL_BOUNDARY_Tracts_2010' from data source `/Users/prenercg/GitHub/PrenerLab/Dueling-Peripheries/data/STL_BOUNDARY_Tracts_2010/STL_BOUNDARY_Tracts_2010.geojson' using driver `GeoJSON'
    ## Simple feature collection with 305 features and 1 field
    ## geometry type:  POLYGON
    ## dimension:      XY
    ## bbox:           xmin: -90.73653 ymin: 38.3883 xmax: -90.11771 ymax: 38.89118
    ## geographic CRS: WGS 84

``` r
## redlining
redlining_37 <- st_read(here::here("data", "STL_BOUNDARY_Redlining", "STL_BOUNDARY_Redlining_1937.geojson")) %>%
  st_transform(crs = 26915)
```

    ## Reading layer `STL_BOUNDARY_Redlining_1937' from data source `/Users/prenercg/GitHub/PrenerLab/Dueling-Peripheries/data/STL_BOUNDARY_Redlining/STL_BOUNDARY_Redlining_1937.geojson' using driver `GeoJSON'
    ## Simple feature collection with 126 features and 2 fields
    ## geometry type:  MULTIPOLYGON
    ## dimension:      XY
    ## bbox:           xmin: -90.39657 ymin: 38.52386 xmax: -90.1863 ymax: 38.75682
    ## geographic CRS: WGS 84

``` r
redlining_40 <- st_read(here::here("data", "STL_BOUNDARY_Redlining", "STL_BOUNDARY_Redlining_1940.geojson")) %>%
  st_transform(crs = 26915)
```

    ## Reading layer `STL_BOUNDARY_Redlining_1940' from data source `/Users/prenercg/GitHub/PrenerLab/Dueling-Peripheries/data/STL_BOUNDARY_Redlining/STL_BOUNDARY_Redlining_1940.geojson' using driver `GeoJSON'
    ## Simple feature collection with 155 features and 2 fields
    ## geometry type:  MULTIPOLYGON
    ## dimension:      XY
    ## bbox:           xmin: -90.45203 ymin: 38.5243 xmax: -90.18705 ymax: 38.75694
    ## geographic CRS: WGS 84

## Geoprocess Tracts

In order to determine the percent of each tract redlined, we need to
know the total area of each tract. We’ll calculate the area in square
meters (based on the projected coordinate system in use), then convert
it to square kilometers.

``` r
tracts %>%
  mutate(total_area = st_area(geometry)) %>%
  mutate(total_area = as.vector(conv_unit(total_area, from = "m2", to = "km2"))) %>%
  select(GEOID, total_area) -> tracts
```

The square kilometers conversion isn’t strictly speaking necessary for
this application, but is included in-case it is needed later.

## Geoprocess 1937 Data

Next, we’ll calculate the percent of tracts redlined in 1937. First, we
need to figure out which tract each redlined area for the “C” and “D”
grades falls into, and then combine adjacent areas within the same
tract. Next, we’ll repeat the workflow above for calculating the sqare
kilometers redlined.

``` r
redlining_37 %>%  
  filter(grade %in% c("C", "D")) %>%
  st_intersection(., tracts) %>%
  group_by(GEOID) %>%
  summarise() %>%
  st_collection_extract(type = "POLYGON") %>%
  mutate(red_area = st_area(geometry)) %>%
  mutate(red_area = as.vector(conv_unit(red_area, from = "m2", to = "km2"))) %>%
  select(GEOID, red_area) -> redlining_37
```

    ## Warning: attribute variables are assumed to be spatially constant throughout all
    ## geometries

    ## `summarise()` ungrouping output (override with `.groups` argument)

With these calculations complete, we’ll remove the geometry from the
redlining data:

``` r
st_geometry(redlining_37) <- NULL
```

Finally, we’ll merge our tract data with the 1937 redlining data, and
convert the measurement data into a percentage:

``` r
tracts %>%
  left_join(., redlining_37, by = "GEOID") %>%
  mutate(pct_red_37 = red_area/total_area*100) %>%
  select(GEOID, pct_red_37) %>%
  mutate(pct_red_37 = ifelse(is.na(pct_red_37) == TRUE, 0, pct_red_37)) -> redlining_37
```

## Geoprocess 1940 Data

We’ll use an identical workflow for the 1940 data:

``` r
## step 1
redlining_40 %>%  
  filter(grade %in% c("C", "D")) %>%
  st_intersection(., tracts) %>%
  group_by(GEOID) %>%
  summarise() %>%
  st_collection_extract(type = "POLYGON") %>%
  mutate(red_area = st_area(geometry)) %>%
  mutate(red_area = as.vector(conv_unit(red_area, from = "m2", to = "km2"))) %>%
  select(GEOID, red_area) -> redlining_40
```

    ## Warning: attribute variables are assumed to be spatially constant throughout all
    ## geometries

    ## `summarise()` ungrouping output (override with `.groups` argument)

``` r
## step 2
st_geometry(redlining_40) <- NULL

## step 3
tracts %>%
  left_join(., redlining_40, by = "GEOID") %>%
  mutate(pct_red_40 = red_area/total_area*100) %>%
  select(GEOID, pct_red_40) %>%
  mutate(pct_red_40 = ifelse(is.na(pct_red_40) == TRUE, 0, pct_red_40)) -> redlining_40
```

## Store Geoprocessed Data

Next, we’ll store these as separate `.geojson` files:

``` r
## 1937
redlining_37 %>%
  st_transform(crs = 4326) %>%
  st_write(here::here("data", "STL_BOUNDARY_Redlining", "STL_BOUNDARY_Tracts_1937.geojson"), delete_dsn = TRUE)
```

    ## Deleting source `/Users/prenercg/GitHub/PrenerLab/Dueling-Peripheries/data/STL_BOUNDARY_Redlining/STL_BOUNDARY_Tracts_1937.geojson' using driver `GeoJSON'
    ## Writing layer `STL_BOUNDARY_Tracts_1937' to data source `/Users/prenercg/GitHub/PrenerLab/Dueling-Peripheries/data/STL_BOUNDARY_Redlining/STL_BOUNDARY_Tracts_1937.geojson' using driver `GeoJSON'
    ## Writing 305 features with 2 fields and geometry type Polygon.

``` r
## 1940
redlining_40 %>%
  st_transform(crs = 4326) %>%
  st_write(here::here("data", "STL_BOUNDARY_Redlining", "STL_BOUNDARY_Tracts_1940.geojson"), delete_dsn = TRUE)
```

    ## Deleting source `/Users/prenercg/GitHub/PrenerLab/Dueling-Peripheries/data/STL_BOUNDARY_Redlining/STL_BOUNDARY_Tracts_1940.geojson' using driver `GeoJSON'
    ## Writing layer `STL_BOUNDARY_Tracts_1940' to data source `/Users/prenercg/GitHub/PrenerLab/Dueling-Peripheries/data/STL_BOUNDARY_Redlining/STL_BOUNDARY_Tracts_1940.geojson' using driver `GeoJSON'
    ## Writing 305 features with 2 fields and geometry type Polygon.

## Combine Into A Single File

Finally, for analysis, we’ll combine these two percentages into a single
object:

``` r
## remove geometry
st_geometry(redlining_40) <- NULL

## combine and calculate percent change
left_join(redlining_37, redlining_40, by = "GEOID") %>%
  mutate(pct_change = (pct_red_40-pct_red_37)/pct_red_37*100) %>%
  st_transform(crs = 4326) %>%
  st_write(here::here("data", "STL_BOUNDARY_Redlining", "STL_BOUNDARY_Tracts_Combined.geojson"), delete_dsn = TRUE)
```

    ## Deleting source `/Users/prenercg/GitHub/PrenerLab/Dueling-Peripheries/data/STL_BOUNDARY_Redlining/STL_BOUNDARY_Tracts_Combined.geojson' failed
    ## Writing layer `STL_BOUNDARY_Tracts_Combined' to data source `/Users/prenercg/GitHub/PrenerLab/Dueling-Peripheries/data/STL_BOUNDARY_Redlining/STL_BOUNDARY_Tracts_Combined.geojson' using driver `GeoJSON'
    ## Writing 305 features with 4 fields and geometry type Polygon.

    ## Warning in CPL_write_ogr(obj, dsn, layer, driver,
    ## as.character(dataset_options), : GDAL Message 1: NaN of Infinity value found.
    ## Skipped
