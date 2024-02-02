#' Generate Dummy Variable Stack from Categorical Raster
#'
#' This function takes a categorical raster and generates a stack of rasters with
#' dummy variables, where each layer corresponds to one of the categorical variables.
#'
#' @param Rast A categorical raster (class: SpatRaster) representing landcover.
#' @return A stack of rasters with dummy variables, where each layer
#' corresponds to a unique category in the input raster.
#' @param Vars if not null, a character vector to select the variables in
#' which to use the function, see examples
#' @seealso [terra::levels]
#'
#' @examples
#' # Load necessary libraries and create a sample categorical raster
#' library(terra)
#'
#' # Generate dummy variable stack
#' data("Landuse_DK")
#' Nature <- terra::unwrap(Landuse_DK)
#' dummy_stack <- generate_dummy_stack(Nature)
#'
#' plot(dummy_stack, colNA = "black")
#'
#'# Selecting only some variables
#'
#'  dummy_stack2 <- generate_dummy_stack(Nature,
#'         Vars = c("Agriculture", "Forest"))
#'  plot(dummy_stack2, colNA = "black")
#' @importFrom terra rast ifel is.factor
#' @importFrom purrr reduce
#'
#' @export
generate_dummy_stack <- function(Rast, Vars = NULL){
  if(!(class(Rast) %in% c("SpatRaster"))) {stop("the file has to be of SpatRaster class")}

  if(!terra::is.factor(Rast)) {stop("The spatrast has to be a categorical #raster")}
  # Copy the categorical raster
  Temp <- Rast
  #Get the dataframe of the levels
  Levels <- terra::levels(Rast)[[1]]
  colnames(Levels)[2] <- "cover"
  if(!is.null(Vars)){
    Levels <- Levels[Levels$cover %in% Vars,]
  }
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
