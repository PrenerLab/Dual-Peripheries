map_breaks <- function(.data, var, newvar, classes, style, breaks, clean_labels = TRUE, dig_lab = 10){
  
  # save parameters to list
  paramList <- as.list(match.call())
  
  # quote input variables
  if (!is.character(paramList$var)) {
    ref <- rlang::enquo(var)
  } else if (is.character(paramList$var)) {
    ref <- rlang::quo(!! rlang::sym(var))
  }
  
  refQ <- rlang::quo_name(rlang::enquo(ref))
  
  if (!is.character(paramList$newvar)) {
    new <- rlang::enquo(newvar)
  } else if (is.character(paramList$newvar)) {
    new <- rlang::quo(!! rlang::sym(newvar))
  }
  
  newQ <- rlang::quo_name(rlang::enquo(new))
  
  # calculate breaks and categories
  if (missing(breaks) == TRUE){
    breaks <- classInt::classIntervals(.data[[refQ]], n = classes, style = style)
  }
  
  categories <- cut(.data[[refQ]], breaks = c(breaks$brks), include.lowest = TRUE, dig.lab = dig_lab)
  
  # create new variable
  .data <- dplyr::mutate(.data, !!newQ := categories)
  
  # clean labels
  if (clean_labels == TRUE){
    
    .data[[newQ]] %>%
      forcats::fct_relabel(~ gsub(",", " - ", .x)) %>%
      forcats::fct_relabel(~ gsub("\\(", "", .x)) %>%
      forcats::fct_relabel(~ gsub("\\[", "", .x)) %>%
      forcats::fct_relabel(~ gsub("\\]", "", .x)) -> .data[[newQ]]
    
  }
  
  # return result
  return(.data)
  
}