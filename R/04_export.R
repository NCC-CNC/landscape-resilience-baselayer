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
