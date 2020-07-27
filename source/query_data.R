
query_data <- function(category, year){
  
  ## establish connection
  con <- DBI::dbConnect(RSQLite::SQLite(), "data/STL_DEMOGRAPHY_TractPop/data/STL_CITY_COUNTY_Database.sqlite")
  
  ## identify table
  if (category == "population"){
    db <- dplyr::tbl(con, "population")
  } else if (category == "race"){
    db <- dplyr::tbl(con, "race")
  }
  
  ## query
  out <- dplyr::filter(db, year == year)
  out <- dplyr::collect(out)
  
  ## disconnect from database
  DBI::dbDisconnect(con)
  
  ## return output
  return(out)
  
}
