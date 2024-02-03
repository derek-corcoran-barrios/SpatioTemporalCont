#' Calculate the proportion of each landuse in each polygon
#'
#' This function takes a categorical raster and a polygon, and generates a
#' dataframe of the proportion of each Polygon in each cell, considering only
#' non NA cells.
#'
#'
#' @param Rast A raster (class: SpatRaster).
#' @param Polygons a SpatVector object with the needed polygons.
#' @param Vars if not null, a character vector to select the variables in
#' which to use the function, see examples
#' @param verbose logical, if true (default), then messages of the progress is
#' written as messages in the function
#' @param type a character value, on of "Inside", "Both" or "Outside", if value
#' is Inside, the proportions will be calculated only inside the polygons, if
#' Both is selected it will be calculated in the polygons plus a buffer of
#' distance dist in meters
#' @param dist number in meters, only works if using type "Outside" or "Both"
#' @return A dataframe with  the proportions, where each row corresponds to the
#' each shapefile, and each column to the proportion of each category of the
#' original raster.
#' @seealso [terra::zonal][terra::levels]
#'
#' @examples
#' # Load necessary libraries and create a sample categorical raster
#' library(terra)
#' data(Polygons)
#' data("Landuse_DK")
#' Landuse <- terra::unwrap(Landuse_DK)
#'
#' v <- vect(Polygons, "polygons", crs = terra::crs(Landuse))
#' Test <- summarise_polygons(Rast = Landuse, Polygons = v,
#'                             Vars = c("Agriculture","Forest"))
#'
#' Test
#'# Example with type both
#'
#' TestBoth <- summarise_polygons(Rast = Landuse, Polygons = v,
#'   Vars = c("Agriculture","Forest"), type = "Both", dist = 200)
#' TestBoth
#' # Example with type outside
#'
#' TestOut <- summarise_polygons(Rast = Landuse, Polygons = v,
#'   Vars = c("Agriculture","Forest"), type = "Outside", dist = 200)
#' TestOut
#' @importFrom terra rast ifel is.factor crop mask zonal
#' @importFrom purrr reduce
#' @export

summarise_polygons <- function(Rast, Polygons, Vars, dist = NULL, type = "Inside", verbose = TRUE){
  if(!(class(Rast) %in% c("SpatRaster"))) {stop("the file has to be of SpatRaster class")}

  if(!terra::is.factor(Rast)) {stop("The spatrast has to be a categorical #raster")}
  # Copy the categorical raster
  Temp <- Rast
  if(type == "Inside"){
    message("Using option = inside")
    Temp <- Temp |>
      terra::crop(Polygons) |>
      terra::mask(Polygons)
  } else if(type == "Both"){
    message("Using option = Both")
    BufferPols <- terra::buffer(Polygons, dist)
    Temp <- Temp |>
      terra::crop(BufferPols) |>
      terra::mask(BufferPols)
  }
  else if(type == "Outside"){
    message("Using option = Outside")
    BufferPols <- terra::buffer(Polygons, dist)
    ErasedPols <- terra::erase(BufferPols, Polygons)
    Temp <- Temp |>
      terra::crop(ErasedPols) |>
      terra::mask(ErasedPols)
  }

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
  if(type == "Inside"){
    DF <- terra::zonal(Stack, Polygons, "mean")
  }else  if(type == "Both"){
    DF <- terra::zonal(Stack, BufferPols, "mean")
  }else  if(type == "Outside"){
    DF <- terra::zonal(Stack, ErasedPols, "mean")
  }
  return(DF)
}
