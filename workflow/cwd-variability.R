library(sf)
library(terra)
library(viridis)
library(USAboundaries)

monthly_cwd <- list.files("data/raw/monthly", full.names = TRUE)
annual_mean_cwd <- lapply(X = monthly_cwd[-1], FUN = function(cwd) {
  r <- terra::mean(terra::rast(cwd))
  r
}
)

interannual_variation_of_cwd <- terra::stdev(terra::rast(annual_mean_cwd))

dir.create("data/out", showWarnings = FALSE)

terra::writeRaster(x = interannual_variation_of_cwd, filename = "data/out/interannual_variation_of_cwd.tiff")

ca <- USAboundaries::us_boundaries(type = "county", states = "California")
ca <- sf::st_transform(ca, 3310)

plot(interannual_variation_of_cwd, col = viridis::viridis(100))
plot(sf::st_geometry(ca), add = TRUE)


annual_stdev_cwd <- lapply(X = monthly_cwd[-1], FUN = function(cwd) {
  r <- terra::stdev(terra::rast(cwd))
  r
}
)

intraannual_variation_of_cwd <- terra::mean(terra::rast(annual_stdev_cwd))

terra::writeRaster(x = intraannual_variation_of_cwd, filename = "data/out/intraannual_variation_of_cwd.tiff", overwrite = TRUE)

dir.create("figs", showWarnings = FALSE)
png("figs/intraannual_variation_of_cwd.png", res = 200, width = 5, height = 6, units = "in")
plot(intraannual_variation_of_cwd, col = viridis::viridis(100), main = "Average intraannual variation\nof CWD from 1981 to 2010")
plot(sf::st_geometry(ca), add = TRUE)
dev.off()



mean_cwd <- 
  lapply(X = monthly_cwd[-1], FUN = terra::rast) %>% 
  terra::rast() %>% 
  terra::mean()

terra::writeRaster(x = mean_cwd, filename = "data/out/mean_cwd.tiff")

plot(mean_cwd, col = viridis::viridis(100))
plot(sf::st_geometry(ca), add = TRUE)
