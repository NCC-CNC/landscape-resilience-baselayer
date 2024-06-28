#
# Author: Dan Wismer
#
# Date: May 13th, 2024
#
# Description: Normalizes variables and generate Landscape Resilience. Goal and
#              rivers variable is truncated at the 3rd Q to control for outliers.
#
# Inputs:  1. 01_get_variables.R
#
# Tested on R Versions: 4.3.0
#
#===============================================================================

library(terra)

# Start timer
start_time <- Sys.time()

# Source function
source("R/fct_normalize.R")

# Get input layers
layers_to_scale <- c(
  ch,              # critical habitat
  biod_goal,       # biodiversity goal
  end_goal,        # endemic goal
  sar_goal,        # species at risk goal
  biod_rich,       # biodiversity richness
  end_rich,        # endemic richness
  sar_rich,        # species at risk richness
  connect,         # connectivity 
  climate_c,       # climate centrality
  climate_r,       # climate refugia
  forest_lc,       # forest land cover, ha
  grass,           # grassland, ha
  wet,             # wetland, ha  
  river,           # rivers, km
  shore,           # shoreline, km
  climate_e,       # climate extremes, index
  hfi              # human footprint, index  
)

# Scale layers between 0 and 1
LR_READY <- lapply(layers_to_scale, function(x) {
  print(names(x))
  if (names(x) != "climate_e") {
    x <- ifel(x <= 0, NA, x) # remove 0's 
    if (names(x) %in% c("biod_goal", "end_goal", "sar_goal", "rivers")) {
      third_q <- global(x, quantile, probs=c(0.75), na.rm=TRUE)[[1]]
      x[x > third_q] <- third_q # truncate layer at third Q (control outliers)
    }
  }
  x <- normalize(x)           # normalize
  x <- round(x, 2)            # round to 2 decimal places
  mosaic(x, PU, fun="max")    # mosaic so raster is between 0-1
})

# Landscape Resilience positive variables
LR_POS <- (
    (LR_READY[[1]] * 1)  # ch
  + (LR_READY[[2]] * 1)  # biod_goal
  + (LR_READY[[3]] * 1)  # end_goal
  + (LR_READY[[4]] * 1)  # sar_goal
  + (LR_READY[[5]] * 1)  # biod_rich
  + (LR_READY[[6]] * 1)  # end_rich
  + (LR_READY[[7]] * 1)  # sar_rich
  + (LR_READY[[8]] * 1)  # connect
  + (LR_READY[[9]] * 1)  # climate_c
  + (LR_READY[[10]] * 1) # climate_r
  + (LR_READY[[11]] * 1) # forest_lc
  + (LR_READY[[12]] * 1) # grass
  + (LR_READY[[13]] * 1) # wet
  + (LR_READY[[14]] * 1) # river
  + (LR_READY[[15]] * 1) # shore
)

# Landscape Resilience negative variables
LR_NEG <- (
    (LR_READY[[16]] * 1)   # climate_e
  + (LR_READY[[17]] * 1)   # hfi
) 

# Landscape Resilience
LR <- LR_POS - LR_NEG

# Write Landscape Resilience to disk
writeRaster(LR, "Output/landr.tif", overwrite = TRUE)

# End timer
end_time <- Sys.time()
end_time - start_time
