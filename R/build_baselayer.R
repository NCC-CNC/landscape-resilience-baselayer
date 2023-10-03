library(terra)

# Start timer
start_time <- Sys.time()

# Source script and function
source("R/get_variables.R")
source("R/fct_normalize.R")

# Get input layers
layers_to_scale <- c(
  kba,
  ch,
  biod_goal,
  end_goal,
  sar_goal,
  biod_rich,
  end_rich,
  sar_rich,
  connect,
  climate_c,
  climate_r,
  forest,
  grass,
  wet,
  river,
  shore,
  parks,
  climate_e,
  hfi
)

# Scale layers between 0 and 1
LR_READY <- lapply(layers_to_scale, normalize)

# Landscape Resilience Equation
LR <- (
    (LR_READY[[1]]  * 1) # + kba
  + (LR_READY[[2]] * 1)  # + ch
  + (LR_READY[[3]] * 1)  # + biod_goal
  + (LR_READY[[4]] * 1)  # + end_goal
  + (LR_READY[[5]] * 1)  # + sar_goal
  + (LR_READY[[6]] * 1)  # + biod_rich
  + (LR_READY[[7]] * 1)  # + end_rich
  + (LR_READY[[8]] * 1)  # + sar_rich
  + (LR_READY[[9]] * 1)  # + connect
  + (LR_READY[[10]] * 1)  # + climate_c
  + (LR_READY[[11]] * 1) # + climate_r
  + (LR_READY[[12]] * 1) # + forest
  + (LR_READY[[13]] * 1) # + grass
  + (LR_READY[[14]] * 1) # + wet
  + (LR_READY[[15]] * 1) # + river
  + (LR_READY[[16]] * 1) # + shore
  + (LR_READY[[17]] * 1) # + parks
  - (LR_READY[[18]] * 1) # - climate_e
  - (LR_READY[[19]] * 1) # - hfi
)

# Write Landscape Resilience Baselayer to disk
writeRaster(LR, "LRBL.tif", overwrite = TRUE)
writeRaster(normalize(LR), "LRBL_SCALED.tif", overwrite = TRUE)

# End timer
end_time <- Sys.time()
end_time - start_time
