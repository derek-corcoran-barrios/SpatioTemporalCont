#' Generate Dummy Variable Stack from Categorical Raster
#'
#' This function takes a categorical raster and generates a stack of rasters with
#' dummy variables, where each layer corresponds to one of the categorical variables.
#'
#' @param Rast A categorical raster (class: SpatRaster) representing landcover.
#' @return A stack of rasters with dummy variables, where each layer corresponds to a
#'         unique category in the input raster.
#' @seealso \code{\link{SpatRaster}}, \code{\link{terra::ifel}}, \code{\link{purrr::reduce}}
#'
#' @examples
#' # Load necessary libraries and create a sample categorical raster
#' library(terra)
#' sample_raster <- rast(matrix(sample(letters[1:5], 100, replace = TRUE), 10, 10))
#' # Generate dummy variable stack
#' dummy_stack <- generate_dummy_stack(sample_raster)
#'
#' @importFrom terra rast ifel
#' @importFrom purrr reduce
#'
#' @export
generate_dummy_stack <- function(Rast){
  if(!(class(Rast) %in% c("SpatRaster"))) {stop("the file has to be of SpatRaster class")}

  if(!is.factor(Rast)) {stop("The spatrast has to be a categorical raster")}
  # Copy the categorical raster
  Temp <- Rast
  #Get the dataframe of the levels
  Levels <- terra::levels(Rast)[[1]]
  # Calculate the number of levels in the categorical raster
  n_levels <- nrow(Levels)
  Stack <- list()
  for(i in 1:n_levels){
    Stack[[i]] <- Temp
    Stack[[i]] <- terra::ifel(Temp == Levels$cover[i], 1, 0)
    names(Stack[[i]]) <- Levels$cover[i]
  }
  Stack <- purrr::reduce(Stack, c)
  return(Stack)
}
