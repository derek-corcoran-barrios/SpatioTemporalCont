## code to prepare `dry_nature` dataset goes here



library(terra)
library(BDRUtils)
library(foreign)
library(dplyr)
library(stringr)

Basemap <- terra::rast("o:/Nat_BDR-data/BiodiversityCouncilUpdate/Basemaps04/Basemap_04_2011_2016_2018_2021/lu_agg_2021.tif")
rat <- read.dbf("o:/Nat_BDR-data/BiodiversityCouncilUpdate/Basemaps04/Basemap_04_2011_2016_2018_2021/lu_agg_2021.tif.vat.dbf") |>
  dplyr::select(VALUE, C_03) |>
  dplyr::mutate(C_03 = case_when(str_detect(C_03, "Nature, dry") ~ "dry nature",
                                 str_detect(C_03, "Nature, wet") ~ "wet nature"))

rat_d <- rat |> mutate(C_03 = as.numeric(as.factor(C_03)))

rclmat_d <- as.matrix(rat_d)
Basemap<- classify(Basemap,rclmat_d)

cl <- data.frame(id = c(1,2), Nature = c("dry nature", "wet nature"))

levels(Basemap) <- cl

dry_wet_nature <- terra::aggregate(5, fun = "modal")

dry_wet_nature <- terra::wrap(Basemap)

usethis::use_data(dry_wet_nature, overwrite = TRUE)
