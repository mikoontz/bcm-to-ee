library(gdalUtils)
library(tidyverse)
library(sf)
library(raster)
library(terra)


base_url <- "https://cida.usgs.gov/thredds/fileServer/CA-BCM-2014/HST/Monthly/"

vars <- c("cwd")
years <- 1980:2010

if(!dir.exists("data/raw/monthly")) {
  dir.create("data/raw/monthly", recursive = TRUE)
}

for (i in seq_along(vars)) {
  for (j in seq_along(years)) {
    this_var <- vars[i]
    this_year <- years[j]
    this_file <- paste0("CA_BCM_HST_Monthly_", this_var, "_", this_year, ".nc")
    this_url <- paste0(base_url, this_file)
    
    if(!file.exists(paste0("data/raw/monthly/", this_file))) {
      download.file(url = this_url, 
                    destfile = paste0("data/raw/monthly/", this_file))
    }
  }
}