#
# Author: Dan Wismer
#
# Date: May 13th, 2024
#
# Description: Imports national 1km raster .tifs. Layers are held in-memory and
#              used to calculate landscape resilience. 
#
# Inputs:  1. NAT_1KM folder
#
# Tested on R Versions: 4.3.0
#
#===============================================================================

library(terra)

# Set path 
NAT_1KM <- "C:/Data/PRZ/NAT_DATA/NAT_1KM_20240626"

# Get NCC PU
PU <- rast(file.path(NAT_1KM, "_1km", "const.tif"))
PU[PU==1] <- 0

# Critical Habitat
ch <- rast(file.path(NAT_1KM, "biod", "ch.tif"))
names(ch) <- "ch"

# Biodiversity Species Goal
biod_goal <- rast(file.path(NAT_1KM, "biod", "goals", "biod_goal.tif"))
names(biod_goal) <- "biod_goal"

# Endemic Species Goal
end_goal <- rast(file.path(NAT_1KM, "biod", "goals", "end_goal.tif"))
names(end_goal) <- "end_goal"

# Species at Risk Goal
sar_goal <- rast(file.path(NAT_1KM, "biod", "goals", "sar_goal.tif"))
names(sar_goal) <- "sar_goal"

# Biodiversity Species Richness
biod_rich <- rast(file.path(NAT_1KM, "biod", "rich", "biod_rich.tif"))
names(biod_rich) <- "biod_rich"

# Endemic Species Richness
end_rich <- rast(file.path(NAT_1KM, "biod", "rich", "end_rich.tif"))
names(end_rich) <- "end_rich"

# Species at Risk Richness
sar_rich <- rast(file.path(NAT_1KM, "biod", "rich", "sar_rich.tif"))
names(sar_rich) <- "sar_rich"

# Connectivity
connect <- rast(file.path(NAT_1KM, "connect", "connect.tif"))
names(connect) <- "connect"

# Climate centrality
climate_c <- rast(file.path(NAT_1KM, "climate", "climate_c.tif"))
names(climate_c) <- "climate_c"

# Climate Extremes
climate_e <- rast(file.path(NAT_1KM, "climate", "climate_e.tif"))
names(climate_e) <- "climate_e"

# Climate Refugia
climate_r <- rast(file.path(NAT_1KM, "climate", "climate_r.tif"))
names(climate_r) <- "climate_r"

# Forest land cover
forest_lc <- rast(file.path(NAT_1KM, "habitat", "forest_lc.tif"))
names(forest_lc) <- "forest_lc"

# Grassland
grass <- rast(file.path(NAT_1KM, "habitat", "grass.tif"))
names(grass) <- "grass"

# Wetland
wet <- rast(file.path(NAT_1KM, "habitat", "wet.tif"))
names(wet) <- "wet"

# Rivers
river <- rast(file.path(NAT_1KM, "habitat", "river.tif"))
names(river) <- "river"

# Shoreline
shore <- rast(file.path(NAT_1KM, "habitat", "shore.tif"))
names(shore) <- "shore"

# Human Footprint Index
hfi <- rast(file.path(NAT_1KM, "threats", "hfi.tif"))
names(hfi) <- "hfi"

# NON LR Variables -------------------------------------------------------------

# Carbon Potential
carbon_p <- rast(file.path(NAT_1KM, "carbon", "carbon_p.tif"))
names(carbon_p) <- "carbon_p"

# Carbon Storage
carbon_s <- rast(file.path(NAT_1KM, "carbon", "carbon_s.tif"))
names(carbon_s) <- "carbon_s"

# Existing Conservation
parks <- rast(file.path(NAT_1KM, "cons", "cons_ha.tif"))
terra::NAflag(parks) <- 128
names(parks) <- "parks"

# Recreation
rec <- rast(file.path(NAT_1KM, "eservices", "rec.tif"))
names(rec) <- "rec"

# Freshwater Provision
freshw <- rast(file.path(NAT_1KM, "eservices", "freshw.tif"))
names(freshw) <- "freshw"

# Lakes
lakes <- rast(file.path(NAT_1KM, "habitat", "lakes.tif"))
names(lakes) <- "lakes"

# Forest land use
forest_lu <- rast(file.path(NAT_1KM, "habitat", "forest_lu.tif"))
names(forest_lu) <- "forest_lu"