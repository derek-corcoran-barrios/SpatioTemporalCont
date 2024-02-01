## code to prepare `Landuse_DK` dataset goes here

library(terra)
library(BDRUtils)
library(foreign)
library(dplyr)
library(stringr)

basemap <- terra::rast("o:/Nat_BDR-data/BiodiversityCouncilUpdate/Basemaps04/Basemap_04_2011_2016_2018_2021/lu_agg_2021.tif") |>
  as.numeric()
rat <- read.dbf("o:/Nat_BDR-data/BiodiversityCouncilUpdate/Basemaps04/Basemap_04_2011_2016_2018_2021/lu_agg_2021.tif.vat.dbf")  |>
  dplyr::mutate(C_03 = case_when(str_detect(C_03, "Nature, dry") ~ "dry nature",
                                 str_detect(C_03, "Nature, wet") ~ "wet nature",
                                 str_detect(C_03, "Build") ~ "Built up",
                                 str_detect(C_03, "built") ~ "Built up",
                                 str_detect(C_03, "Railway") ~ "Built up",
                                 str_detect(C_03, "Airport") ~ "Built up",
                                 str_detect(C_03, "Road") ~ "Built up",
                                 str_detect(C_03, "City") ~ "Built up",
                                 str_detect(C_03, "Industry") ~ "Built up",
                                 str_detect(C_03, "Forest") ~ "Forest",
                                 str_detect(C_03, "Agriculture") ~ "Agriculture",
                                 str_detect(C_03, "Lake") ~ "Water body",
                                 str_detect(C_03, "Stream") ~ "Water body",
                                 str_detect(C_03, "Recreation") ~ "Recreation",
                                 TRUE ~ C_03
                                 )) |>
  dplyr::mutate(C_03 = tm::removeNumbers(C_03),
                new_id = as.numeric(as.factor(C_03)))

basemap <- terra::ifel(basemap %in% c(999999, 420000), NA, basemap)

for(i in 1:nrow(rat)){
  basemap <- ifel(basemap == rat$VALUE[i], rat$new_id[i], basemap)
  message(paste(i, "of", nrow(rat), "Ready!", Sys.time()))
}

key <- rat %>% dplyr::select(new_id, C_03) %>% distinct() |> dplyr::arrange(new_id) |>
  dplyr::mutate(C_03 = str_trim(C_03)) |> dplyr::rename(Landuse = C_03) |>
  dplyr::filter(!(Landuse %in% c("Germany", "Sea")))

basemap_d <- basemap


levels(basemap_d) <- key

basemap_d <- terra::aggregate(basemap_d, 10, fun = "modal")

Landuse_DK <- terra::wrap(basemap_d)


usethis::use_data(Landuse_DK, overwrite = TRUE)
