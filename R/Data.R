#' Dry and wet nature in denmark
#'
#' A subset of data from basemap 4 raster in denmark, as it is stated in its
#' website "Basemap is a national map of land use and land cover for Denmark.
#' Basemap combines publicly available spatial information into one map. Basemap
#' is a raster map with a cell size of 10 x 10 meter." In our case we have a
#' subset of the 4th version of basemap which was generated in 2021 and shows
#' which cells are dry nature or wet nature in Denmark
#'
#'
#' @format ## `dry_wet_nature`
#' A wrapped SpatRaster with a 10 by 10 meeter resolution:
#' \describe{
#'   \item{Nature}{dry nature or wet nature}
#'   \item{year}{Year}
#'   ...
#' }
#' @source <https://envs.au.dk/en/research-areas/society-environment-and-resources/land-use-and-gis/basemap>
"dry_wet_nature"
