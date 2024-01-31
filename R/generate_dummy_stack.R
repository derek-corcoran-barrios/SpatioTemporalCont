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
    Stack[[i]] <- ifel(Temp == Levels$cover[i], 1, 0)
    names(Stack[[i]]) <- Levels$cover[i]
  }
  Stack <- purrr::reduce(Stack, c)
  return(Stack)
}
