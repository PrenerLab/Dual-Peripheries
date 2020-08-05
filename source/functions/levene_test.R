levene_test <- function(.data, var){
  
  f <- as.formula(paste(var, "red_cat", sep = " ~ "))
  
  result <- car::leveneTest(f, data = .data)
  
  out <- dplyr::tibble(
    var = var,
    df = result$Df[1],
    F = result$`F value`[1],
    p = result$`Pr(>F)`[1]
  )
  
  out <- dplyr::mutate(out, sig = ifelse(p < .05, TRUE, FALSE))
  
  return(out)
}