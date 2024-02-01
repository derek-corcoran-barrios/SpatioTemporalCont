#' Calculate the matrix weight for a focal mean
#'
#' This function takes a raster and a desired radius and generates a circular
#' matrix with ones and NA to be later used in a focal function.
#'
#' @param Rast A raster (class: SpatRaster).
#' @param Radius A Radius in the units of the raster, to generate the weight.
#' @return A square matrix with the weights to be used in a focal function
#' @seealso [terra::focal][terra::levels]
#'
#' @examples
#' # Load necessary libraries and create a sample categorical raster
#' library(terra)
#'
#' data(dry_wet_nature)
#' DRY <- terra::unwrap(dry_wet_nature)
#' circle_matrix <- calculate_matrix(Rast = DRY, Radius = 2000)
#'
#'plot(terra::rast(circle_matrix), colNA = "black")
#'
#' @importFrom terra res
#'
#' @export

calculate_matrix <- function(Rast, Radius){
  side <- terra::res(Rast)[1]
  squares <- ceiling(Radius/side)
  size <- (squares*2) + 1
  # Create an empty matrix filled with zeros
  mat <- matrix(NA, nrow = size, ncol = size)

  # Calculate the center of the matrix
  center <- (size + 1) / 2

  # Create a circle pattern
  for (i in 1:size) {
    for (j in 1:size) {
      # Check if the current position is within the circle
      if (sqrt((i - center)^2 + (j - center)^2) <= center) {
        mat[i, j] <- 1
      }
    }
  }
  return(mat)
}
