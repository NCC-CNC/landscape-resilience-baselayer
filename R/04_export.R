#
# Author: Dan Wismer
#
# Date: May 14th, 2024
#
# Description: Exports normalized and raw variables. 
#
# Inputs:  1. LR_READY (list of normalized rasters used to calculate LR)
#
# Tested on R Versions: 4.3.0
#
#===============================================================================
# Convert 0 to NA and mask to LR
LR_READY_EXPORT <- lapply(LR_READY, function(x) {
  r <- ifel(x <= 0, NA, x)
  mask(r, LR)
})

# Save layers to disk
for (i in seq_along(LR_READY_EXPORT)) {
  writeRaster(
    LR_READY_EXPORT[[i]], 
    paste0("Output/LR_READY/", names(LR_READY_EXPORT[[i]]), ".tif"), 
    overwrite = TRUE
  )
}

# Raw layers for impact metrics
LR_RAW <- c(
  "biod_rich" = biod_rich, 
  "end_rich" = end_rich, 
  "sar_rich" = sar_rich,
  "carbon_p" = carbon_p,
  "carbon_s" = carbon_s,
  "climate_c" = climate_c,
  "climate_e" = climate_e,
  "claimte_r" = climate_r,
  "connect" = connect,
  "forest_lc" = forest_lc,
  "forest_lu" = forest_lu,
  "grass" = grass,
  "wet" = wet,
  "shore" = shore,
  "river" = river,
  "hfi" = hfi,
  "rec" = rec,
  "parks" = parks,
  "freshw" = freshw,
  "lakes" = lakes
  )

# Convert 0 to NA and mask to LR
LR_RAW <- lapply(LR_RAW, function(x) {
  if(names(x) != "climate_e") { # climate_e ranges between -0.0153367 to 0.0256083
    x <- ifel(x <= 0, NA, x)
  } 
  mask(x, LR)
})

# Save layers to disk
for (i in seq_along(LR_RAW)) {
  writeRaster(
    LR_RAW[[i]], 
    paste0("Output/LR_RAW/", names(LR_RAW[[i]]), ".tif"), 
    overwrite = TRUE
  )
}
