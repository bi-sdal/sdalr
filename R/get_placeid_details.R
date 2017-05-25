#' Get detailed information about a Google Maps place_id
#'
#' @param place_id the placeid
#' @param ... optional. parameters passed into sdal::get_google_maps_key
#' @export
get_placeid_details <- function(place_id, ...) {
    url <- paste0("https://maps.googleapis.com/maps/api/place/details/json?placeid=",
                  place_id,
                  "&key=", sdalr::get_google_maps_key(...))
    return(jsonlite::fromJSON(url))
}
