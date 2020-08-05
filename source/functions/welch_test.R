welch_test <- function(.data, var){
  
  f <- as.formula(paste(var, "red_cat", sep = " ~ "))
  
  result <- stats::oneway.test(f, data = .data)
  
  out <- dplyr::tibble(
    var = var,
    df_num = result$parameter[1],
    df_denom = result$parameter[2],
    F = result$statistic,
    p = result$p.value
  )
  
  out <- dplyr::mutate(out, sig = ifelse(p < .05, TRUE, FALSE))
  
  return(out)
}

wide_welch <- function(.data){
  
  # subset
  out <- dplyr::select(.data, var, F, p)
  
  # create output value
  out <- dplyr::mutate(out, p = dplyr::case_when(
    p >= .05 ~ "",
    p < .05 & p >= .01 ~ "*",
    p < .01 & p >= .001 ~ "**",
    p < .001 ~ "***"
  ))
  
  out <- dplyr::mutate(out, val = paste0(round(F, digits = 3), p))
  
  # pivot
  out <- dplyr::select(out, var, val)
  out <- tidyr::pivot_wider(out, names_from = "var", values_from = "val")
  
  # create empty space for red_cat
  out <- dplyr::mutate(out, red_cat = NA_character_)
  out <- dplyr::select(out, red_cat, dplyr::everything())
  
  # 
  return(out)
  
}