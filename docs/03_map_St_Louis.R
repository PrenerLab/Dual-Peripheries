
# tidyverse packages
library(dplyr)
library(ggplot2)

# spatial packages
library(sf)

# other packages
library(ggrepel)

source(here::here("source", "functions", "get_coords.R"))

counties <- st_read(here::here("data", "STL_BOUNDARY_Counties", "STL_BOUNDARY_Counties.geojson")) %>%
  st_transform(crs = 26915)

counties_centroids <- counties %>%
  st_centroid() %>%
  get_coords(crs = 26915)

munis <- st_read(here::here("data", "STL_BOUNDARY_Munis", "STL_BOUNDARY_Munis.geojson")) %>%
  st_transform(crs = 26915)

munis_centroids <- munis %>%
  st_centroid() %>%
  get_coords(crs = 26915)

rivers <- st_read(here::here("data", "STL_HYDRO_Major_Rivers", "STL_HYDRO_Major_Rivers.geojson")) %>%
  st_transform(crs = 26915)

rivers_centroids <- rivers %>%
  st_centroid() %>%
  get_coords(crs = 26915)

highways <- st_read(here::here("data", "STL_TRANS_Highways", "STL_TRANS_Highways.geojson")) %>%
  st_transform(crs = 26915)

symbolic_roads <- st_read(here::here("data", "STL_TRANS_Symbolic_Roads", "STL_TRANS_Symbolic_Roads.geojson")) %>%
  st_transform(crs = 26915) %>%
  filter(FULLNAME == "Delmar Blvd")

symbolic_roads_centroids <- symbolic_roads %>%
  st_centroid() %>%
  get_coords(crs = 26915)

symbolic_roads_centroids <- slice(symbolic_roads_centroids, 1)

highway_label <- distinct(highways, FULLNAME)

p <- ggplot() +
  geom_sf(data = counties, fill = "white", size = 1) +
  geom_sf(data = rivers, fill = "light blue") +
  geom_sf(data = munis, fill = "white") +
  geom_text_repel(data = counties_centroids, mapping = aes(x = x, y = y, label = NAMELSAD),
                  size = 4,
                  fontface = 'bold',
                  nudge_x = c(-30000, 7000),
                  nudge_y = c(20000, -15000)) +
  geom_sf_label(data = rivers, mapping = aes(label = FULLNAME),
                nudge_x = c(-2800, -3500),
                nudge_y = c(-20000, 3000)) +
  cowplot::theme_map()

ggsave(here::here("results", "figures", "st_louis.png"), p, width = 7.5, height = 10.5, units = "in", dpi = 500)

