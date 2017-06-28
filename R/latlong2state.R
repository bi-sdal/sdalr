library(sp)
library(maps)
library(maptools)

#' Return a data.frame of states of lat lon values
latlong2state <- function(pointsDF) {
    us_states <- tigris::states()
    pointsDF_sp <- SpatialPoints(pointsDF)
    proj4string(pointsDF_sp) <- proj4string(us_states)
    indices <- over(pointsDF_sp, us_states)
    data.frame(STATE_NAME=indices$NAME)
}

latlong2county <- function(pointsDF, state_FIPS) {
  state_counties <- tigris::counties(state = state_FIPS)
  pointsDF_sp <- SpatialPoints(pointsDF)
  proj4string(pointsDF_sp) <- proj4string(state_counties)
  indices <- over(pointsDF_sp, state_counties)
  data.frame(COUNTYFP=indices$COUNTYFP, STATEFP=indices$STATEFP)
}
