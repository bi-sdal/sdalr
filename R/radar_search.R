#' Performs a radar search from a given lat and lon within a certain radius
#'
#' Uses the google maps api which will require an API key
#'
#' @param lat the latitude
#' @param lon the longitude
#' @param type_search_string the string to be used to look for location types
#' @param radius how wide the radar search will look
#' @param ... optional. parameters passed into sdal::get_google_maps_key
#' @return list
#' @export
#' @examples
#' sdalr::radar_search(lat = 37.231264, lon = -80.426745,
#'                     type_search_string = 'grocery_or_supermarket')
#'
#' sdalr::radar_search(lat = 37.231264, lon = -80.426745,
#'                     type_search_string = 'grocery_or_supermarket',
#'                     file = '~/google_maps_api_key.txt')
radar_search <- function(lat, lon, type_search_string, radius = 1609, ...) {
    jsonlite::fromJSON(paste0("https://maps.googleapis.com/maps/api/place/radarsearch/json?",
                    "location=", lat, ",", lon,
                    "&radius=", radius,
                    "&type=", type_search_string,
                    "&key=", sdalr::get_google_maps_key(...)))
}
