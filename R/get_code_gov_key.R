#' Retrieves the code.gov key on the server
#'
#' So it's not accidentently pushed in the code
#'
#' @param file location of the google maps key file by default it points to the location in the sdal server
#' @return string
#' @export
#' @examples
#' \dontrun{
#' get_code_gov_key()
#'
#' get_code_gov_key('~/google_maps_api_key.txt')
#' }
get_code_gov_key <- function(file = '/home/sdal/projects/sdal/api_keys/code_gov.txt') {
    paste(readLines(file), collapse = " ")
}
