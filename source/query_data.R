
# dependencies ####

library(dplyr)
library(DBI)

# load data ####
## establish connection
con <- dbConnect(RSQLite::SQLite(), "data/STL_DEMOGRAPHY_TractPop/data/STL_CITY_COUNTY_Database.sqlite")

## collection records
tbl(con, "population") %>%
  filter(year == "1940") %>%
  collect() -> pop40
