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
#' @param Vars if not null, a character vector to select the
#' variables in which to use the function, see examples
#'
#' @examples
#' # Load necessary libraries and create a sample categorical raster
#' library(terra)
#'
#' data(corine)
#' corine <- terra::unwrap(corine)
#' # see the dataset
#'
#' plot(corine, legend = FALSE, col = "black")
#'
#' Tempcont <- calculate_tempcont(Rast = corine)
#'
#' plot(Tempcont, colNA = "black")
#'
#' # Use years
#'
#' TempcontNum <- calculate_tempcont(Rast = corine,
#'                            years = c(1990, 2000, 2006, 2012, 2018
#'                            ))
#'
#' plot(TempcontNum, colNA = "black")
#'
#' # use years and vars
#'
#' TempcontNum <- calculate_tempcont(Rast = corine,
#'                                  years = c(1990, 2000, 2006, 2012, 2018),
#'                                  Vars = c("Coniferous forest" ,"Mixed forest"))
#'
#'plot(TempcontNum, colNA = "black")
#'
#' @import terra
#' @importFrom terra values ifel nlyr
#' @export

calculate_tempcont <- function(Rast, years = NULL, Vars = NULL){
  Temp <- Rast[[1]]
  # make a Temp Raster with NA to fill
  terra::values(Temp) <- NA
  # If the last layer of rast (The most resent one) is different from the one just before that one there is no continuity
  if(is.null(Vars)){
    # If all Variables are used then calculate changes for everything
    Temp <- terra::ifel(Rast[[terra::nlyr(Rast)]] != Rast[[terra::nlyr(Rast) - 1]], 0, Temp)
  } else if(!is.null(Vars)){
    Temp <- terra::ifel(Rast[[terra::nlyr(Rast)]] != Rast[[terra::nlyr(Rast) - 1]] | !(Rast[[terra::nlyr(Rast)]] %in% Vars), 0, Temp)

  }

  if(is.null(years)){
    # If the last layer of rast (The most resent one) is equal from the one just before that one there is a continuity of at least one
    Temp <- terra::ifel(Rast[[terra::nlyr(Rast)]] == Rast[[terra::nlyr(Rast) - 1]] & is.na(Temp), 1, Temp)
    # If the last one is true, then we can keep going, if it is at least 1 in continuity, and layer terra::nlyr(Rast) - 1 is equal to terra::nlyr(Rast) - 2, then we have a continuity of 2
    for(i in 2:(nlyr(Rast) -1)){
      Temp <- terra::ifel(Temp == (i - 1) & (Rast[[terra::nlyr(Rast) - (i -1)]] == Rast[[terra::nlyr(Rast) - i]]), i, Temp)
    }} else if(!is.null(years)){
      # If the last layer of rast (The most resent one) is equal from the one just before that one there is a continuity of at least one
      Temp <- terra::ifel(Rast[[terra::nlyr(Rast)]] == Rast[[terra::nlyr(Rast) - 1]] & is.na(Temp), (years[terra::nlyr(Rast)] - years[terra::nlyr(Rast) - 1]), Temp)
      # If the last one is true, then we can keep going, if it is at least 1 in continuity, and layer terra::nlyr(Rast) - 1 is equal to terra::nlyr(Rast) - 2, then we have a continuity of 2
      for(i in 2:(nlyr(Rast) -1)){
        Temp <- terra::ifel(Temp == years[terra::nlyr(Rast)] -years[terra::nlyr(Rast) - (i -1)] & (Rast[[terra::nlyr(Rast) - (i -1)]] == Rast[[terra::nlyr(Rast) - i]]), (years[terra::nlyr(Rast)] - years[terra::nlyr(Rast) - (i)]), Temp)
      }

    }
  Temp[is.na(Rast[[1]])] <- NA

  return(Temp)
}
