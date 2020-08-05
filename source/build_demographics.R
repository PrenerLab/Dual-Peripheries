# build contemporary data #### 

# dependencies ####
library(dplyr)
library(readr)
library(tidycensus)

# household income segregation ####
get_acs(table = "B19001", geography = "tract", state = 29, county = c(189, 510), output = "wide") %>%
  select(GEOID, ends_with("E")) %>%
  select(GEOID, B19001_001E:B19001_005E, B19001_015E:B19001_017E) %>%
  mutate(
    income_lowq = B19001_002E+B19001_003E+B19001_004E+B19001_005E,
    income_highq = B19001_015E+B19001_016E+B19001_017E
  ) %>%
  mutate(ice_income = (income_highq-income_lowq)/B19001_001E) %>%
  select(GEOID, ice_income) -> ice_income

# household median income ####
get_acs(variable = "B19013_001", geography = "tract", state = 29, county = c(189, 510), output = "wide") %>%
  select(GEOID, B19013_001E) %>%
  rename(median_inc = B19013_001E) -> median_inc

# median value of owner occupied housing ####
get_acs(variable = "B25077_001", geography = "tract", state = 29, county = c(189, 510), output = "wide") %>%
  select(GEOID, B25077_001E) %>%
  rename(owner_occ_value = B25077_001E) -> owner_occ_value

# proportion below poverty line ####
get_acs(table = "B17001", geography = "tract", state = 29, county = c(189, 510), output = "wide") %>%
  select(GEOID, B17001_001E, B17001_002E) %>%
  mutate(poverty_pct = B17001_002E/B17001_001E*100) %>%
  select(GEOID, poverty_pct) -> poverty_pct

# proportion vacant ####
get_acs(variable = "B25001_001", geography = "tract", state = 29, county = c(189, 510), output = "wide") %>%
  select(GEOID, B25001_001E) -> total_housing_units

get_acs(variable = "B25004_001", geography = "tract", state = 29, county = c(189, 510), output = "wide") %>%
  select(GEOID, B25004_001E) %>%
  left_join(total_housing_units, ., by = "GEOID") %>%
  mutate(vacant_pct = B25004_001E/B25001_001E*100) %>%
  select(GEOID, vacant_pct) -> vacant_pct

rm(total_housing_units)

# owner occupied ####
get_acs(table = "B25008", geography = "tract", state = 29, county = c(189, 510), output = "wide") %>%
  select(GEOID, B25008_001E, B25008_002E) %>%
  mutate(owner_occ_pct = B25008_002E/B25008_001E*100) %>%
  select(GEOID, owner_occ_pct) -> owner_occ_pct

# labor force participation ####
get_acs(table = "B23025", geography = "tract", state = 29, county = c(189, 510), output = "wide") %>%
  select(GEOID, B23025_001E, B23025_002E) %>%
  mutate(labor_pct = B23025_002E/B23025_001E*100) %>%
  select(GEOID, labor_pct) -> labor_pct

# join ####
left_join(ice_income, median_inc, by = "GEOID") %>%
  left_join(., poverty_pct, by = "GEOID") %>%
  left_join(., labor_pct, by = "GEOID") %>%
  left_join(., owner_occ_pct, by = "GEOID") %>%
  left_join(., owner_occ_value, by = "GEOID") %>%
  left_join(., vacant_pct, by = "GEOID") -> demographics

# write ####
write_csv(demographics, "data/STL_DEMOGRAPHY_Current/STL_DEMOGRAPHY_Current.csv")

## clean-up
rm(ice_income, median_inc, poverty_pct, labor_pct, owner_occ_pct, owner_occ_value, vacant_pct)
