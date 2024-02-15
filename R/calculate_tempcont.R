#' Calculate the temporal continuity of each landuse in each cell of a raster
#'
#' This function takes a stack of categorical rasters and generates a
#' layer of spatial continutiy of landuse in each cell, considering
#' only non NA cells.
#' The resulting output is a raster layer where each cell represents
#' the temporal continuity of land use. The function assesses
#' continuity by comparing consecutive layers of the raster stack.
#' Without specifying years, the continuity is based on changes in land
#' use categories, creating a categorical
#' scale where 0 indicates discontinuity and positive integers indicate
#' the duration of continuity. When specifying years, the function
#' considers the temporal aspect, calculating the difference in years
#' between consecutive layers and providing insights into the duration
#' of consistent land use over time.
#'
#' @param Rast A raster stack (class: SpatRaster), ordered from the
#' oldest to the newest
#' @param years numeric vector of the same number of layers
#' corresponding to the years, default is NULL
#'
#' @examples
#' # Load necessary libraries and create a sample categorical raster
#' library(terra)
#'
#' data(corine)
#' corine <- terra::unwrap(corine)
#' Tempcont <- calculate_tempcont(Rast = corine)
#'
#' plot(Tempcont, colNA = "black")
#'
#' # Use years
#'
#' TempcontNum <- calculate_tempcont(Rast = corine,
#'                            years = c(1990, 2000, 2006, 2012, 2018))
#'
#' plot(TempcontNum, colNA = "black")
#'
#' @importFrom terra values ifel nlyr
#' @export

calculate_tempcont <- function(Rast, years = NULL){
  Temp <- Rast[[1]]
  # make a Temp Raster with NA to fill
  terra::values(Temp) <- NA
  # If the last layer of rast (The most resent one) is different from the one just before that one there is no continuity
  if(is.null(years)){
    Temp <- terra::ifel(Rast[[terra::nlyr(Rast)]] != Rast[[terra::nlyr(Rast) - 1]], 0, Temp)
    # If the last layer of rast (The most resent one) is equal from the one just before that one there is a continuity of at least one
    Temp <- terra::ifel(Rast[[terra::nlyr(Rast)]] == Rast[[terra::nlyr(Rast) - 1]], 1, Temp)
    # If the last one is true, then we can keep going, if it is at least 1 in continuity, and layer terra::nlyr(Rast) - 1 is equal to terra::nlyr(Rast) - 2, then we have a continuity of 2
    for(i in 2:(nlyr(Rast) -1)){
      Temp <- terra::ifel(Temp == (i - 1) & (Rast[[terra::nlyr(Rast) - (i -1)]] == Rast[[terra::nlyr(Rast) - i]]), i, Temp)
    }} else if(!is.null(years)){
      Temp <- terra::ifel(Rast[[terra::nlyr(Rast)]] != Rast[[terra::nlyr(Rast) - 1]], 0, Temp)
      # If the last layer of rast (The most resent one) is equal from the one just before that one there is a continuity of at least one
      Temp <- terra::ifel(Rast[[terra::nlyr(Rast)]] == Rast[[terra::nlyr(Rast) - 1]], (years[terra::nlyr(Rast)] - years[terra::nlyr(Rast) - 1]), Temp)
      # If the last one is true, then we can keep going, if it is at least 1 in continuity, and layer terra::nlyr(Rast) - 1 is equal to terra::nlyr(Rast) - 2, then we have a continuity of 2
      for(i in 2:(nlyr(Rast) -1)){
        Temp <- terra::ifel(Temp == years[terra::nlyr(Rast)] -years[terra::nlyr(Rast) - (i -1)] & (Rast[[terra::nlyr(Rast) - (i -1)]] == Rast[[terra::nlyr(Rast) - i]]), (years[terra::nlyr(Rast)] - years[terra::nlyr(Rast) - (i)]), Temp)
      }

  }

  return(Temp)
}
