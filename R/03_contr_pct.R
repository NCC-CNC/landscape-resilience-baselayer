#
# Author: Dan Wismer
#
# Date: May 13th, 2022
#
# Description: Generates the contribution % of each variable.
#
# Inputs:  1. run 01_get_variables.R
#          2. run 02_build_baselayer.R
#
# Outputs: 1. Contribution % .tif for each variable
#
# Tested on R Versions: 4.3.0
#
#===============================================================================

# Contribution percentage function
contribution_pct <- function(normalized_var_rast, LR_sum_rast) {
  cpct <- round(abs((normalized_var_rast / LR_sum_rast) * 100),2)
  return(cpct)
}

# Calculate contribution percentage (positive variables)
CONTR_PCT_POS <- lapply(LR_READY[1:15], function(x){
  return(contribution_pct(x, LR))
})

# Calculate contribution percentage (positive variables)
CONTR_PCT_NEG <- lapply(LR_READY[16:17], function(x){
  browser()
  return(contribution_pct(x, LR_NEG))
})

# Merge lists 
CONTR_PCT <- c(CONTR_PCT_POS, CONTR_PCT_NEG)

# Save layers to disk
for (i in seq_along(CONTR_PCT)) {
  writeRaster(
    CONTR_PCT[[i]], 
    paste0("Output/contr_pct/", names(CONTR_PCT[[i]]), ".tif"), 
    overwrite = TRUE
  )
}
