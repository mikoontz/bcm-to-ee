library(gdalUtils)
library(tidyverse)
library(sf)
library(raster)


base_url <- "https://cida.usgs.gov/thredds/fileServer/CA-BCM-2014/HST/Monthly/"

vars <- c("tmx", "cwd")
years <- 2004:2005

for (i in seq_along(vars)) {
  for (j in seq_along(years)) {
    this_var <- vars[i]
    this_year <- years[j]
    this_file <- paste0("CA_BCM_HST_Monthly_", this_var, "_", this_year, ".nc")
    this_url <- paste0(base_url, this_file)
    
    if(!dir.exists("data/data_output")) {
      dir.create("data/data_output", recursive = TRUE)
    }
    
    download.file(url = this_url, 
                  destfile = paste0("data/data_output/", this_file))
  }
}

r <- raster::brick(paste0("data/data_output/", this_file))
crs(r) <- st_crs(3310)$proj4string


# velox



r[[1]]
plot(r[[1]], col = viridis::viridis(100))
