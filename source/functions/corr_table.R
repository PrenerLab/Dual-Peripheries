# Correlation Table Output

# Function for producing corrleation table output with statistical significance symbols

# Dependencies:
# the following packages must be installed within R - dplyr, Hmsic, rlang

# Parameters:
# .data - A tbl
# coef - Type of correlation coefficient to be calculated (Pearson's r or Spearman's rho)
# listwise - A logical scalar. Should listwise deletion be used? If FALSE, pairwise deletion used.
# round - Number of decimal places displayed
# pStar - A logical scalar. Should stars be added to the output?
# ... - Optional. One or more unquoted expressions separated by commas. You can treat variable names like they are positions. If you add variable names here, correlation output will be limited to those variables.

# Returns:
# A data frame (regardless of whether input was a data frame, tibble, or matrix). Data frame output is used to facilitate row naming, which is not available in tibbles.

# Notes:
# Pair with stargazer (using summary = FALSE) to create LaTeX formatted correlation tables.

# Function:
corr_table <-function(.data, coef = c("pearson", "spearman"), listwise = TRUE, round = 3, pStar = TRUE, ...){
  
  ## process dots
  if (rlang::dots_n(...) > 1) {
    .data <- dplyr::select(.data, ...)
  }
  
  ## listwise deletion
  if (listwise == TRUE) {
    .data <- na.omit(.data)
  }
  
  ## compute correlation matrix
  inputMatrix <- as.matrix(.data)
  corrMatrix <- Hmisc::rcorr(inputMatrix, type = coef)
  
  ## matrix of correlation coeficients
  rCoef <- corrMatrix$r
  
  # matrix of p-values
  pValues <- corrMatrix$P  
  
  ## round the correlation matrix values
  rCoef <- format(round(cbind(rep(-1.11, ncol(.data)), rCoef), round))[,-1]
  
  ## statistical significance stars
  if (pStar == TRUE) {
    
    ## Define notions for significance levels
    stars <- ifelse(pValues < .001, "***", 
                    ifelse(pValues < .01, "**", 
                           ifelse(pValues < .05, "*", "")))
    
    ## add apropriate stars
    rCoef <- matrix(paste(rCoef, stars, sep = ""), ncol = ncol(.data))    
  }
  
  ## remove upper triangle
  rCoef[upper.tri(rCoef, diag = FALSE)] <- ""
  diag(rCoef) <- formatC(1, digits = round, format = "f")
  
  ## final formatting
  rCoef <- as.data.frame(rCoef)
  rCoef <- dplyr::mutate_if(rCoef, is.factor, as.character)
  rownames(rCoef) <- colnames(.data)
  colnames(rCoef) <- paste(colnames(.data), "", sep = "")
  
  ## return data frame
  return(rCoef)
} 

# Sources:
# http://www.sthda.com/english/wiki/elegant-correlation-table-using-xtable-r-package
# http://myowelt.blogspot.fr/2008/04/beautiful-correlation-tables-in-r.html
# https://stat.ethz.ch/pipermail/r-help/2008-March/156583.html
# http://dplyr.tidyverse.org/reference/select.html