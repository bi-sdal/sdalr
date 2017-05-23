library(jsonlite)
library(data.table)

#' Convert FCC location to FIPS code
#'
#' @param place_id some unique identifier for the lat lon
#' @param lat the latitude
#' @param lon the longitude
FCClocation2FIPS <- function(place_id, lat, lon) {
    json_string <- sprintf('http://data.fcc.gov/api/block/find?format=json&latitude=%s&longitude=%s&showall=true&format=JSON',
                           lat, lon)
    if (length(place_id) > 1) {stop('you supplied multiple values for place_id, did you mean to use FCClocations2FIPS?')}
    if (length(lat) > 1) {stop('you supplied multiple values for lat, did you mean to use FCClocations2FIPS?')}
    if (length(lon) > 1) {stop('you supplied multiple values for lon, did you mean to use FCClocations2FIPS?')}

    res <- fromJSON(json_string)
    data.table(place_id = place_id,
               state_name = res$State$name,
               state_fips = res$State$FIPS,
               county_name = res$County$name,
               county_fips = res$County$FIPS,
               block_fips = res$Block$FIPS)
}

#' Convert multiple FCC locations to FIPS codes
#'
#' @param place_idCol vector of unique identifiers
#' @param latCol vector of latitudes
#' @param lonCol vector of longitudes
FCClocations2FIPS <- function(place_idCol, latCol, lonCol) {
    res <- as.data.table(t(mapply(FCClocation2FIPS, place_idCol, lonCol, latCol)))
    data.table(place_id = unlist(res$place_id),
               state_name = unlist(res$state_name),
               state_fips = unlist(res$state_fips),
               county_name = unlist(res$county_name),
               county_fips = unlist(res$county_fips),
               block_fips = unlist(res$block_fips))
}
