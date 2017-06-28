library(geosphere)
library(tigris)

#' Create a grid for a specified state
#'
#' @param lon_bearing distance to move lon (in feet?)
#' @param lat_bearing distance to move lat (in feet?)
#' @param distance distance
#' @param state_fips state FIPS code
#'
#' @export
latlongrid <- function(#box_lower_left_lon, box_lower_left_lat,
                       #box_upper_right_lon, box_upper_right_lat,
                       lon_bearing = 90,
                       lat_bearing = 0,
                       distance = 1000,
                       state_fips){
    # define box
    #lower_left <- data.frame(cbind(-83.913574, 36.474307))

    us_states <- states()
    chosen_state <- us_states[us_states@data$STATEFP==state_fips,]
    lower_left <- data.frame(cbind(chosen_state@bbox[1,1], chosen_state@bbox[2,1]))
    upper_right <- data.frame(cbind(chosen_state@bbox[2,1], chosen_state@bbox[2,2]))

    #lower_left <- data.frame(cbind(box_lower_left_lon, box_lower_left_lat))
    #upper_right <- data.frame(cbind(-75.058594, 39.690281))
    #upper_right <- data.frame(cbind(box_upper_right_lon, box_upper_right_lat))

    #define bearings and distance
    #lon_bearing <- 90
    lon_bearing <- lon_bearing

    #lat_bearing <- 0
    lat_bearing <- lat_bearing

    #dis <- 1000
    dis <- distance

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

    # add State & County names for all points
    states_counties <- latlong2county(dt_lons_lats, state_fips)
    dt_lons_lats[,STATEFP:=states_counties$STATEFP]
    dt_lons_lats[,COUNTYFP:=states_counties$COUNTYFP]

    # select only chosen State
    dt_lons_lats_state <- dt_lons_lats[STATEFP==state_fips,]
}
