library(sp)
library(maps)
library(maptools)

#' Return a state for a data.frame of lat lon values

#' @param pointsdF data.frame in which:
#' column 1 contains the longitude in degrees (negative in the US) AND
#' column 2 contains the latitude in degrees
#'
#' @export
latlong2state <- function(pointsDF) {
    us_states <- tigris::states()
    pointsDF_sp <- SpatialPoints(pointsDF)
    proj4string(pointsDF_sp) <- proj4string(us_states)
    indices <- over(pointsDF_sp, us_states)
    data.frame(STATE_NAME = indices$NAME)
}
