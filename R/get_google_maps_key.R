#' Retrieves the Google Maps API key on the server
#'
#' So it's not accidentently pushed in the code
#'
#' @param file location of the google maps key file by default it points to the location in the sdal server
#' @export
get_google_maps_key <- function(file = '/home/sdal/projects/keys/google_maps_api_key.txt') {
    paste(readLines(file), collapse = " ")
}
