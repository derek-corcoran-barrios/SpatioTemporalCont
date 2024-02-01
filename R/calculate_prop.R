#' Calculate the proportion of each landuse in each cell of a raster
#'
#' This function takes a categorical raster and generates a stack of rasters
#' with and a desired radius and generates a stack of the proportion of each
#' landuse in each cell, considering only non NA cells.
#'
#' @param Rast A raster (class: SpatRaster).
#' @param Radius A Radius in the units of the raster, to generate the
#' proprotion.
#' @param verbose logical, if true (default), then messages of the progress is
#' written as messages in the function
#' @return A stack of rasters with proportions, where each layer corresponds
#' to the proportion of each category of the raster.
#' @seealso [terra::focal][terra::levels]
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

calculate_prop <- function(Rast, Radius, verbose = TRUE){
  if(verbose){
    message("Starting to generate dummy stack [1/3]")
  }
  dummy_stack <- SpatioTemporalCont::generate_dummy_stack(Rast = Rast)
  if(verbose){
    message("Calculating the weight matrix [2/3]")
  }
  weights <- SpatioTemporalCont::calculate_matrix(Rast = Rast, Radius = Radius)
  if(verbose){
    message("Generating final stack [3/3]")
  }
  FinalStack <- terra::focal(dummy_stack, w=weights, fun="mean", na.policy = "omit")

  return(FinalStack)
}
