# Start timer
start_time <- Sys.time()

library(sf)
library(terra)
library(exactextractr)
library(rlist)
library(dplyr)

start_time <- Sys.time()

# Get polygon
POLYGON <- read_sf("C:/Data/PRZ/RI_PROJECTS/PRAIRIES/AB_SK_PRAIRIES.shp")

# Read-in normalized variables
LR_READY <- list.files(
  path = "C:/Github/landscape-resilience-baselayer/Output/LR_READY", 
  pattern = ".tif$", 
  full.names = TRUE
)
LR_READY <- lapply(LR_READY, rast)

# Read-in raw variables
LR_RAW <- list.files(
  path = "C:/Github/landscape-resilience-baselayer/Output/LR_RAW", 
  pattern = ".tif$", 
  full.names = TRUE
)
## sum
LR_RAW_MAX <- lapply(LR_RAW, function(x) {
  if (tools::file_path_sans_ext(basename(x)) %in% c("biod_rich", "end_rich", "sar_rich")) {
    return(rast(x))
  }
})

## max
LR_RAW_SUM <- lapply(LR_RAW, function(x) {
  if (!(tools::file_path_sans_ext(basename(x)) %in% c("biod_rich", "end_rich", "sar_rich"))) {
    return(rast(x))
  }
})

## remove NULL
LR_RAW_SUM <- Filter(Negate(is.null), LR_RAW_SUM)
LR_RAW_MAX <- Filter(Negate(is.null), LR_RAW_MAX)

# Extract normalized layers
landr_values <- exact_extract(rast(LR_READY), POLYGON, fun = "sum", force_df = TRUE)
# Extract raw layers
landr_sum <- exact_extract(rast(LR_RAW_SUM), POLYGON, fun = "sum", force_df = TRUE)
landr_max <- exact_extract(rast(LR_RAW_MAX), POLYGON, fun = "max", force_df = TRUE)
# Extract LandR Raster
landr_rast <- exact_extract(rast("Output/LandR_TEST.tif"), POLYGON, fun = "sum", force_df = TRUE)

# Calculate landscape resilience
landr <- landr_values %>%
  mutate(
    landr_pos =
      sum.ch +
      sum.biod_goal + sum.end_goal + sum.sar_goal + 
      sum.biod_rich + sum.end_rich + sum.sar_rich +
      sum.climate_c + sum.climate_r +
      sum.connect +
      sum.forest_lc + sum.grass + sum.wet + sum.shore
    ) %>%
  mutate(landr_neg = sum.climate_e + sum.hfi) %>%
  mutate(landr_abs = landr_pos + landr_neg) %>%
  mutate(landr = landr_pos - landr_neg)

# Calculate contribution %
landr <- landr %>%
  mutate(ch_pct = (sum.ch / landr_abs) * 100) %>%
  mutate(pbiod_goal = (sum.biod_goal / landr_abs) * 100) %>%
  mutate(pnd_goal = (sum.end_goal / landr_abs) * 100) %>%
  mutate(psar_goal = (sum.sar_goal / landr_abs) * 100) %>%
  mutate(pbiod_rich = (sum.biod_rich / landr_abs) * 100) %>%
  mutate(pend_rich = (sum.end_rich / landr_abs) * 100) %>%
  mutate(psar_rich = (sum.sar_rich / landr_abs) * 100) %>%
  mutate(pclimate_c = (sum.climate_c / landr_abs) * 100) %>%
  mutate(pclimate_r = (sum.climate_r / landr_abs) * 100) %>%
  mutate(pconnect = (sum.connect / landr_abs) * 100) %>%
  mutate(pforest_lc = (sum.forest_lc / landr_abs) * 100) %>%
  mutate(pgrass = (sum.grass / landr_abs) * 100) %>%
  mutate(pwet = (sum.wet / landr_abs) * 100) %>%
  mutate(pshore = (sum.shore / landr_abs) * 100) %>%
  mutate(pclimate_e = (sum.climate_e / landr_abs) * 100) %>%
  mutate(phfi = (sum.hfi / landr_abs) * 100) 

# End timer
end_time <- Sys.time()
end_time - start_time