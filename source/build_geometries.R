# Build Geometric Files for Mapping and Analysis

# dependencies ####
library(dplyr)
library(sf)
library(tigris)

# counties ####
## download and process (leave object for later use)
counties(state = 29, class = "sf") %>%
  filter(GEOID %in% c("29189", "29510")) %>%
  select(GEOID, NAMELSAD) %>%
  st_transform(crs = 4326) -> counties

## save
st_write(counties, "data/STL_BOUNDARY_Counties/STL_BOUNDARY_Counties.geojson", delete_dsn = TRUE)

# places ###
places(state = 29, class = "sf") %>%
  filter(GEOID %in% c("2923986", "2917272", "2954650", "2938972", "2906004")) %>%
  select(GEOID, NAME) %>%
  st_transform(crs = 4326) %>%
  st_write("data/STL_BOUNDARY_Munis/STL_BOUNDARY_Munis.geojson", delete_dsn = TRUE)

# census tracts ####
tracts(state = 29, county = c(189, 510), class = "sf") %>%
  select(GEOID) %>%
  st_transform(crs = 4326) %>%
  st_write("data/STL_BOUNDARY_Tracts_2010/STL_BOUNDARY_Tracts_2010.geojson", delete_dsn = TRUE)

# symbolic boundaries ####
roads(state = 29, county = c(189, 510), class = "sf") %>%
  filter(FULLNAME %in% c("Olive Blvd", "Delmar Blvd", "Page Ave") == TRUE) %>%
  select(FULLNAME) %>%
  st_write("data/STL_TRANS_Symbolic_Roads/STL_TRANS_Symbolic_Roads.geojson", delete_dsn = TRUE)

# interstates ####
counties <- st_transform(counties, crs = 26915)

primary_secondary_roads(state = 29) %>%
  filter(FULLNAME %in% c("I- 55", "I- 70", "I- 64", "I- 170", "I- 270", "I- 44")) %>%
  st_transform(crs = 26915) %>%
  st_intersection(., counties) %>%
  st_collection_extract(type = "LINESTRING") %>%
  select(FULLNAME) %>%
  st_transform(crs = 4326) %>%
  st_write("data/STL_TRANS_Highways/STL_TRANS_Highways.geojson", delete_dsn = TRUE)

# water ####
## download MO area water features
area_water(state = 29, county = c("099", "183", "189", "510"), class = "sf") %>%
  filter(FULLNAME %in% c("Mississippi Riv", "Missouri Riv")) -> mo_water

## download IL area water features
area_water(state = 17, county = c(133, 163, 119), class = "sf") %>%
  filter(FULLNAME == "Mississippi Riv") %>%
  filter(HYDROID != 110454107724) -> il_water

## combine area water features
rbind(mo_water, il_water) %>%
  group_by(FULLNAME) %>%
  summarise() %>%
  st_transform(crs = 26915) -> water

## geoprocess
counties %>%
  mutate(state = "29") %>%
  group_by(state) %>%
  summarise() %>%
  st_buffer(dist = 2400) %>%
  st_intersection(water, .) %>%
  select(-state) %>%
  st_collection_extract(type = "POLYGON") -> water

## save
water %>%
  st_transform(crs = 4326) %>%
  st_write("data/STL_HYDRO_Major_Rivers/STL_HYDRO_Major_Rivers.geojson", delete_dsn = TRUE)
