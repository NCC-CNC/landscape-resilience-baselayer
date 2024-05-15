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

# Set path 
WTW_DATA <- "C:/Data/PRZ/WTW_DATA/WTW_NAT_DATA_20240124"

# Get NCC PU
PU <- rast(file.path(WTW_DATA, "nat_pu", "NCC_1KM_PU.tif"))
PU[PU==1] <- 0

# Critical Habitat
ch <- rast(file.path(WTW_DATA, "biodiversity", "ECCC_CH_ALL_HA_SUM.tif"))
names(ch) <- "ch"

# Biodiversity Species Goal
biod_goal <- rast(file.path(WTW_DATA, "biodiversity", "goals", "BOID_SUM_GOAL.tif"))
names(biod_goal) <- "biod_goal"

# Endemic Species Goal
end_goal <- rast(file.path(WTW_DATA, "biodiversity", "goals", "NSC_END_SUM_GOAL.tif"))
names(end_goal) <- "end_goal"

# Species at Risk Goal
sar_goal <- rast(file.path(WTW_DATA, "biodiversity", "goals", "ECCC_SAR_SUM_GOAL.tif"))
names(sar_goal) <- "sar_goal"

# Biodiversity Species Richness
biod_rich <- rast(file.path(WTW_DATA, "biodiversity", "richness", "BOID_COUNT.tif"))
names(biod_rich) <- "biod_rich"

# Endemic Species Richness
end_rich <- rast(file.path(WTW_DATA, "biodiversity", "richness", "NSC_END_COUNT.tif"))
names(end_rich) <- "end_rich"

# Species at Risk Richness
sar_rich <- rast(file.path(WTW_DATA, "biodiversity", "richness", "ECCC_SAR_COUNT.tif"))
names(sar_rich) <- "sar_rich"

# Connectivity
connect <- rast(file.path(WTW_DATA, "connectivity", "Connectivity_Pither_Current_Density.tif"))
names(connect) <- "connect"

# Climate centrality
climate_c <- rast(file.path(WTW_DATA, "climate", "Climate_FwdShortestPath_2080_RCP85.tif"))
names(climate_c) <- "climate_c"

# Climate Extremes
climate_e <- rast(file.path(WTW_DATA, "climate", "Climate_LaSorte_ExtremeHeatEvents.tif"))
names(climate_e) <- "climate_e"

# Climate Refugia
climate_r <- rast(file.path(WTW_DATA, "climate", "Climate_Refugia_2080_RCP85.tif"))
names(climate_r) <- "climate_r"

# Forest land cover
forest <- rast(file.path(WTW_DATA, "habitat", "FOREST_LC_COMPOSITE_1KM.tif"))
names(forest) <- "forest"

# Grassland
grass <- rast(file.path(WTW_DATA, "habitat", "Grassland_AAFC_LUTS_Total_Percent.tif"))
names(grass) <- "grass"

# Wetland
wet <- rast(file.path(WTW_DATA, "habitat", "Wetland_comb_proj_diss_90m_Arc.tif"))
wet <- round(wet,2) # easier to work with, original data has a min of 0.00111111,
names(wet) <- "wet"

# Rivers
river <- rast(file.path(WTW_DATA, "habitat", "grid_1km_water_linear_flow_length_1km.tif"))
river <- round(river, 2) # easier to work with
names(river) <- "river"

# Shoreline
shore <- rast(file.path(WTW_DATA, "habitat", "Shoreline.tif"))
names(shore) <- "shore"

# Human Footprint Index
hfi <- rast(file.path(WTW_DATA, "threats", "CDN_HF_cum_threat_20221031_NoData.tif"))
names(hfi) <- "hfi"

# NON LR Variables -------------------------------------------------------------

# Carbon Potential
carbon_p <- rast(file.path(WTW_DATA, "carbon", "Carbon_Potential_NFI_2011_CO2e_t_year.tif"))
names(carbon_p) <- "carbon_p"

# Carbon Storage
carbon_s <- rast(file.path(WTW_DATA, "carbon", "Carbon_Mitchell_2021_t.tif"))
names(carbon_s) <- "carbon_s"

# Existing Conservation
parks <- rast(file.path(WTW_DATA, "protection", "CPCAD_NCC_FS_CA_HA.tif"))
terra::NAflag(parks) <- 128
names(parks) <- "parks"

# Recreation
rec <- rast(file.path(WTW_DATA, "eservices", "rec_pro_1a_norm.tif"))
names(rec) <- "rec"

# Freshwater Provision
freshw <- rast(file.path(WTW_DATA, "eservices", "water_provision_2a_norm.tif"))
names(freshw) <- "freshw"
