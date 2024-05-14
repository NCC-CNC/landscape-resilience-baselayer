#
# Author: Dan Wismer
#
# Date: May 13th, 2024
#
# Description: Imports national 1km raster .tifs. Layers are held in-memory and
#              used to calculate landscape resilience. 
#
# Inputs:  1. WTW_NAT_DATA folder
#
# Tested on R Versions: 4.3.0
#
#===============================================================================

# THIS SCRIPT GETS RAN IN 02_build_baselayer.R

library(terra)

# Set path ----
WTW_DATA <- "C:/Data/PRZ/WTW_DATA/WTW_NAT_DATA_20240124"
# Get NCC PU
PU <- rast(file.path(WTW_DATA, "nat_pu", "NCC_1KM_PU.tif"))
PU[PU==1] <- 0

## critical habitat
ch <- rast(file.path(WTW_DATA, "biodiversity", "ECCC_CH_ALL_HA_SUM.tif"))
ch <- mosaic(ch, PU, fun = "max")
names(ch) <- "ch"

## goals
### biodiversity species goal
biod_goal <- rast(file.path(WTW_DATA, "biodiversity", "goals", "BOID_SUM_GOAL.tif"))
biod_goal <- mosaic(biod_goal, PU, fun = "max")
names(biod_goal) <- "biod_goal"

### endemic species goal
end_goal <- rast(file.path(WTW_DATA, "biodiversity", "goals", "NSC_END_SUM_GOAL.tif"))
end_goal <- mosaic(end_goal, PU, fun = "max")
names(end_goal) <- "end_goal"

### species at risk goal
sar_goal <- rast(file.path(WTW_DATA, "biodiversity", "goals", "ECCC_SAR_SUM_GOAL.tif"))
sar_goal <- mosaic(sar_goal, PU, fun = "max")
names(sar_goal) <- "sar_goal"

## richness
### biodiversity species richness
biod_rich <- rast(file.path(WTW_DATA, "biodiversity", "richness", "BOID_COUNT.tif"))
biod_rich <- mosaic(biod_rich, PU, fun = "max")
names(biod_rich) <- "biod_rich"

### endemic species richness
end_rich <- rast(file.path(WTW_DATA, "biodiversity", "richness", "NSC_END_COUNT.tif"))
end_rich <- mosaic(end_rich, PU, fun = "max")
names(end_rich) <- "end_rich"

### species at risk richness
sar_rich <- rast(file.path(WTW_DATA, "biodiversity", "richness", "ECCC_SAR_COUNT.tif"))
sar_rich <- mosaic(sar_rich, PU, fun = "max")
names(sar_rich) <- "sar_rich"

# Get Connectivity Data ----
## connectivity
connect <- rast(file.path(WTW_DATA, "connectivity", "Connectivity_Pither_Current_Density.tif"))
connect <- mosaic(connect, PU, fun = "max")
names(connect) <- "connect"

# Get Climate Data ----
## centrality
climate_c <- rast(file.path(WTW_DATA, "climate", "Climate_FwdShortestPath_2080_RCP85.tif"))
climate_c <- mosaic(climate_c, PU, fun = "max")
names(climate_c) <- "climate_c"

## extremes
climate_e <- rast(file.path(WTW_DATA, "climate", "Climate_LaSorte_ExtremeHeatEvents.tif"))
climate_e <- mosaic(climate_e, PU, fun = "max")
names(climate_e) <- "climate_e"

## refugia
climate_r <- rast(file.path(WTW_DATA, "climate", "Climate_Refugia_2080_RCP85.tif"))
climate_r <- mosaic(climate_r, PU, fun = "max")
names(climate_r) <- "climate_r"

# Get Habitat Data ----
## forest landcover
forest <- rast(file.path(WTW_DATA, "habitat", "FOREST_LC_COMPOSITE_1KM.tif"))
forest <- mosaic(forest, PU, fun = "max")
names(forest) <- "forest"

## grassland
grass <- rast(file.path(WTW_DATA, "habitat", "Grassland_AAFC_LUTS_Total_Percent.tif"))
grass <- mosaic(grass, PU, fun = "max")
names(grass) <- "grass"

## wetland
wet <- rast(file.path(WTW_DATA, "habitat", "Wetland_comb_proj_diss_90m_Arc.tif"))
wet <- round(wet,2) # original data has a min of 0.00111111,
wet <- mosaic(wet, PU, fun = "max")
names(wet) <- "wet"

## rivers
river <- rast(file.path(WTW_DATA, "habitat", "grid_1km_water_linear_flow_length_1km.tif"))
river <- round(river, 2)
river[river > 50] <- 50 # truncate to 3rd Q
river <- mosaic(river, PU, fun = "max")
names(river) <- "river"

## shoreline
shore <- rast(file.path(WTW_DATA, "habitat", "Shoreline.tif"))
shore <- mosaic(shore, PU, fun = "max")
names(shore) <- "shore"

# Get Threat Data ----
## human footprint index
hfi <- rast(file.path(WTW_DATA, "threats", "CDN_HF_cum_threat_20221031_NoData.tif"))
hfi <- mosaic(hfi, PU, fun = "max")
names(hfi) <- "hfi"
