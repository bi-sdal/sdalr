#' Retrieves the ACS API key on the server
#'
#' So it's not accidentently pushed in the code
#'
#' @param file location of the google maps key file by default it points to the location in the sdal server
#' @return string
#' @export
#' @examples
#' \dontrun{
#' get_acs_key()
#'
#' get_acs_key('~/acs_api_key.txt')
#' }
get_acs_key <- function(file='/home/sdal/projects/keys/acs_api_key.txt') {
    paste(readLines(file), collapse = " ")
}
