#' Calculate the proportion of each landuse in each cell of a raster
#'
#' This function takes a categorical raster and generates a stack of rasters
#' with and a desired radius and generates a stack of the proportion of each
#' landuse in each cell, considering only non NA cells.
#'
#' @param Rast A raster (class: SpatRaster).
#' @param Radius A Radius in the units of the raster, to generate the
#' proprotion.
#' @return A stack of rasters with proportions, where each layer corresponds
#' to the proportion of each category of the raster.
#' @seealso \code{\link{SpatRaster}}, \code{\link{terra::focal}}
#'
#' @examples
#' # Load necessary libraries and create a sample categorical raster
#' library(terra)
#'
#' data(dry_wet_nature)
#' nature <- terra::unwrap(dry_wet_nature)
#' proportions <- calculate_prop(Rast = nature, Radius = 200)
#'
#' plot(proportions, colNA = "black")
#'
#' @importFrom terra focal
#' @export

calculate_prop <- function(Rast, Radius){
  dummy_stack <- SpatioTemporalCont::generate_dummy_stack(Rast = Rast)
  weights <- SpatioTemporalCont::calculate_matrix(Rast = Rast, Radius = Radius)
  FinalStack <- terra::focal(dummy_stack, w=circle_matrix, fun="weights")
  return(FinalStack)
}
