## code to prepare `corine` dataset goes here

library(terra)
library(geodata)

Denmark <- geodata::gadm(country = "denmark", level = 0, getwd())

corine_1990 <- terra::rast("o:/Nat_Sustain-proj/_user/derekCorcoran_au687614/Ecogenetics_Site_Selection/u2000_clc1990_v2020_20u1_raster100m/DATA/U2000_CLC1990_V2020_20u1.tif")

Denmark <- terra::project(Denmark, terra::crs(corine_1990))

corine_1990 <- corine_1990 |>
  terra::crop(Denmark) |>
  terra::mask(Denmark)

corine_2000 <- terra::rast("o:/Nat_Sustain-proj/_user/derekCorcoran_au687614/Ecogenetics_Site_Selection/u2006_clc2000_v2020_20u1_raster100m/DATA/U2006_CLC2000_V2020_20u1.tif") |>
  terra::crop(Denmark) |>
  terra::mask(Denmark)

corine_2006 <- terra::rast("o:/Nat_Sustain-proj/_user/derekCorcoran_au687614/Ecogenetics_Site_Selection/u2012_clc2006_v2020_20u1_raster100m/DATA/U2012_CLC2006_V2020_20u1.tif") |>
  terra::crop(Denmark) |>
  terra::mask(Denmark)

corine_2012 <- terra::rast("o:/Nat_Sustain-proj/_user/derekCorcoran_au687614/Ecogenetics_Site_Selection/u2018_clc2012_v2020_20u1_raster100m/DATA/U2018_CLC2012_V2020_20u1.tif") |>
  terra::crop(Denmark) |>
  terra::mask(Denmark)

corine_2018 <- terra::rast("o:/Nat_Sustain-proj/_user/derekCorcoran_au687614/Ecogenetics_Site_Selection/u2018_clc2018_v2020_20u1_raster100m/DATA/U2018_CLC2018_V2020_20u1.tif") |>
  terra::crop(Denmark) |>
  terra::mask(Denmark)


corine <- c(corine_1990, corine_2000, corine_2006, corine_2012, corine_2018)
names(corine) <- c("Cor_1990","Cor_2000", "Cor_2006", "Cor_2012", "Cor_2018")

dir.create("inst")

BDRUtils::write_cog(corine, "inst/Corine.tif")

corine <- terra::aggregate(corine, fact = 2, fun = "modal")

corine <- terra::wrap(corine)

usethis::use_data(corine, overwrite = TRUE)


