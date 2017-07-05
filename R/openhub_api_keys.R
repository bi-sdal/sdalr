#' Retrieves the OpenHub keys from members in the lab
#'
#' So it's not accidentently pushed in the code.
#'
#' Dataframe has 3 columns: id, name, and key.
#' id is some identifier for the key
#' name is the name of the person the key is associated with
#' key is the actuall API key.
#'
#' @param file location of the google maps key file by default it points to the location in the sdal server
#' @return dataframe
#' @export
#' @examples
#' get_openhub_keys_df()
get_openhub_keys_df <- function(file = '/home/sdal/projects/keys/ohloh_keys.csv') {
    return(read.csv(file, stringsAsFactors = FALSE))
}

#' Gets a single OpenHub API key
#'
#' Calls `get_openhub_keys_df` to get API key(s) so it's not accidentently pushed in the code.
#'
#' @param key_index the row index of the key (can also be vector of integers), defaults to 1
#' @param key_id the id to use to subset the table of API keys (use with key_name), defaults to NULL
#' @param key_name the name to use to subset the table of API keys (use with key_id), defaults to NULL
#' @param file location of the google maps key file by default it points to the location in the sdal server
#' @return string
#' @export
#' @examples
#' get_openhub_key()
#'
#' get_openhub_key(2)
#'
#' get_openhub_key(c(1, 2))
#'
#' get_openhub_key(key_id = 'oh_key_dc', key_name = 'Daniel')
get_openhub_key <- function(key_index = 1,
                            key_id = NULL,
                            key_name = NULL,
                            file = '/home/sdal/projects/keys/ohloh_keys.csv') {
    oh_key_df <- read.csv(file, stringsAsFactors = FALSE)
    # if key_id is null then key_name should also be null
    # and vice versa
    if (is.null(key_id)) {testthat::expect_null(key_name)}
    if (is.null(key_name)) {testthat::expect_null(key_id)}

    # if key_id or key_name is not null,
    # then the other value should also not be null
    # key_index should also remain the default value, 1
    if (!is.null(key_id)) {
        testthat::expect_true(!is.null(key_name))
        testthat::expect_equal(key_index, 1)
    }
    if (!is.null(key_name)) {
        testthat::expect_true(!is.null(key_id))
        testthat::expect_equal(key_index, 1)
    }

    # use the key_index
    if (is.null(key_id) & is.null(key_name)) {
        return(oh_key_df[key_index, 'key'])
    } else {
        return(oh_key_df[oh_key_df$id == key_id &
                             oh_key_df$name == key_name, 'key'])
    }
}
