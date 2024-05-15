#
# Author: Dan Wismer
#
# Date: May 13th, 2024
#
# Description: Generates the contribution % of each variable to the absolute 
#              Landscape Resilience.
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
  cpct <- round(((normalized_var_rast / LR_sum_rast) * 100),2)
  return(cpct)
}

# Get absolute LR 
LR_ABS <- LR_POS + abs(LR_NEG)

# Calculate contribution percentage of each variable to the absolute LR
CONTR_PCT <- lapply(LR_READY, function(x){
  print(names(x))
  return(contribution_pct(x, LR_ABS))
})

# Save layers to disk
for (i in seq_along(CONTR_PCT)) {
  print(names(CONTR_PCT[[i]]))
  r <- ifel(CONTR_PCT[[i]] <= 0, NA, CONTR_PCT[[i]])
  writeRaster(
    r, 
    paste0("Output/contr_pct/", names(CONTR_PCT[[i]]), "_pct.tif"), 
    overwrite = TRUE
  )
}

