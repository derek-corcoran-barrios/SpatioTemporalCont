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

#' Landuse in denmark
#'
#' A subset of data from basemap 4 raster in denmark, as it is stated in its
#' website "Basemap is a national map of land use and land cover for Denmark.
#' Basemap combines publicly available spatial information into one map. Basemap
#' is a raster map with a cell size of 10 x 10 meter." In our case we have a
#' subset of the 4th version of basemap which was generated in 2021 and shows an
#' upscaled raster of 100 by 100 meter cells which show which cells are of class
#' Resource extraction, Unmapped, Agriculture, Built up, dry nature, Forest,
#' Recreation, Water body or wet nature in Denmark
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
"Landuse_DK"

#' Polygons
#'
#' A matrix to be used as polygons
#'
#'
#' @format ## `Polygons`
#' A matrix with 3 columns:
#' \describe{
#'   \item{id}{id of the polygon}
#'   \item{x}{easting}
#'   \item{y}{northing}
#'   ...
#' }
#' @example
#'
#' library(terra)
#' data(Polygons)
#' data("Landuse_DK")
#' Landuse <- terra::unwrap(Landuse_DK)
#'
#' v <- vect(Polygons, "polygons", crs = terra::crs(Landuse))
#' plot(v)
"Polygons"
