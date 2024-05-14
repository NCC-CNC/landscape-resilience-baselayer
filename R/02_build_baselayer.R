#
# Author: Dan Wismer
#
# Date: May 13th, 2022
#
# Description: Generates landscape resilience.
#
# Inputs:  1. 01_get_variables.R
#
# Tested on R Versions: 4.3.0
#
#===============================================================================

library(terra)

# Start timer
start_time <- Sys.time()

# Source script and function
source("R/01_get_variables.R")
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
  forest,          # forest land cover, ha
  grass,           # grassland, ha
  wet,             # wetland, ha  
  river,           # rivers, km
  shore,           # shoreline, km
  climate_e,       # climate extremes, index
  hfi              # human footprint, index  
)

# Scale layers between 0 and 1
LR_READY <- lapply(layers_to_scale, normalize)

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
  + (LR_READY[[11]] * 1) # forest
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
writeRaster(LR_POS, "Output/LandR_POS.tif", overwrite = TRUE)
writeRaster(LR_NEG, "Output/LandR_NEG.tif", overwrite = TRUE)
writeRaster(LR, "Output/LandR.tif", overwrite = TRUE)

# End timer
end_time <- Sys.time()
end_time - start_time
