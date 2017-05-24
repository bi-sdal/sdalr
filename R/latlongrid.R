library(geosphere)

#' Create a grid for a specified state
#'
#' @param box_lower_left_lon longitude for lower left corner
#' @param box_lower_left_lat latitude for lower left cornet
#' @param box_upper_right_lon longitude for upper right corner
#' @param box_upper_right_lat latitude for upper right corner
#' @param lon_bearing distance to move lon (in feet?)
#' @param lat_bearing distance to move lat (in feet?)
#' @param distance distance
#' @param state state
#'
#' @export
latlongrid <- function(box_lower_left_lon, box_lower_left_lat,
                       box_upper_right_lon, box_upper_right_lat,
                       lon_bearing,
                       lat_bearing,
                       distance,
                       state){
    # define box
    #lower_left <- data.frame(cbind(-83.913574, 36.474307))
    lower_left <- data.frame(cbind(box_lower_left_lon, box_lower_left_lat))
    #upper_right <- data.frame(cbind(-75.058594, 39.690281))
    upper_right <- data.frame(cbind(box_upper_right_lon, box_upper_right_lat))

    #define bearings and distance
    #lon_bearing <- 90
    lon_bearing <- lon_bearing

    #lat_bearing <- 0
    lat_bearing <- lat_bearing

    #dis <- 1000
    dis <- distance

    #define State
    #state <- "virginia"
    state <- state

    # generate lats
    lon <- lower_left[,1]
    lat <- lower_left[,2]
    dt_lats <- data.table(Lat=c(lat))
    while (lat < upper_right[,2]) {
        p <- cbind(lon, lat)
        d <- destPoint(p, lat_bearing, dis)
        dt_lats <- rbindlist(list(dt_lats, list(d[,2])))
        lon <- d[,1]
        lat <- d[,2]
    }

    # generate lons
    lon <- lower_left[,1]
    lat <- lower_left[,2]
    dt_lons <- data.table(Lon=c(lon))
    while (lon < upper_right[,1]) {
        p <- cbind(lon, lat)
        d <- destPoint(p, lon_bearing, dis)
        dt_lons <- rbindlist(list(dt_lons, list(d[,1])))
        lon <- d[,1]
        lat <- d[,2]
    }

    # generate lon, lat cross join
    dt_lons_lats <- data.table::CJ(Lon=dt_lons[,Lon], Lat=dt_lats[,Lat])

    # add State name for all points
    dt_lons_lats[,State:=latlong2state(dt_lons_lats)]

    # select only chosen State
    dt_lons_lats_state <- dt_lons_lats[State==state, .(Lon, Lat)]
}
