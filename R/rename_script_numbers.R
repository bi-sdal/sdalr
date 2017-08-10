library(stringr)

#' Returns a new file name with padded digits
#'
#' @param file_name: original filename to rename
#' @param number_match_pattern: regular expression to extract the number to pad
#' @param pad_width: total number of digits to left pad with
#' @param verbose: print statements
#'
#' @export
#'
#' @examples
#' new_filename <- renumber_file(file_name = 'account_table_2017-07-17_1.RData',
#'                               number_match_pattern = '\\d*\\.RData$',
#'                               pad_width = 3,
#'                               verbose = FALSE)
#'
#' new_filename <- renumber_file(file_name = "1-my_script.R",
#'                               number_match_pattern = '^\\d*-',
#'                               pad_width = 3,
#'                               verbose = FALSE)
renumber_file <- function(file_name, number_match_pattern, pad_width, verbose=TRUE) {
    # get the part of the file that matches the number
    matches <- stringr::str_extract(string = file_name, pattern = number_match_pattern)

    # extract the number part of it
    number <- stringr::str_extract(string = matches, pattern = '\\d*')

    # pad the number
    padded <- stringr::str_pad(string = number, width = pad_width, side = 'left', pad = '0')

    # use the padded number to replace the part from matches
    replaced_padded <- stringr::str_replace(string = matches, pattern = '\\d*', replacement = padded)

    # get the new filename with the replacement
    replaced <- stringr::str_replace(string = file_name, pattern = number_match_pattern, replacement = replaced_padded)

    if (verbose) {print(sprintf('renaming file FROM: %s --------> TO: %s', file_name, replaced))}
    return(replaced)
}


#' Iteratively renames files in a directory using the `renumber_file` function
#'
#' @param path: directory of files
#' @param number_match_pattern: pattern passed into `renumber_file`
#' @param pad_width: left pad width passed into `renumber_file`
#' @param rfile_pattern: regular expression that looks for files to rename,
#'                       defaults to looking for r script files
#' @param dry_run: whether or not to actually do the rename or not.
#'                 defaults to TRUE, which does not rename files,
#'                 only prints out pre and post file names
#' @param verbose: whether or not to show print statments
#'
#' @export
#'
#' @examples
#' rename_script_numbers(path = '~/git/lab/dspg_17/oss/data/oss/original/openhub/users/user_tables/',
#'                       number_match_pattern = '\\d*\\.RData$',
#'                       pad_width = 3,
#'                       rfile_pattern = '*.[rRdD]ata')
rename_script_numbers <- function(path, number_match_pattern, pad_width,
                                  rfile_pattern = '*.[rR]$',
                                  dry_run = TRUE,
                                  verbose=TRUE) {
    files <- list.files(path = path, pattern = rfile_pattern, full.names = TRUE)
    for (fn in files) {

        original_fn <- basename(fn)
        new_fn <- renumber_file(file_name = original_fn, number_match_pattern = number_match_pattern,
                                pad_width = pad_width, verbose = verbose)

        orginal_path <- normalizePath(paste0(dirname(fn), '/', original_fn))
        new_path <- normalizePath(paste0(dirname(fn), '/', new_fn))
        if (verbose) {
            print(sprintf('renaming file FROM: %s --------> TO: %s', orginal_path, new_path))
        }

        if (dry_run) {
            # don't actually do anything, just print
            print(sprintf('renaming file FROM: %s --------> TO: %s', orginal_path, new_path))
        } else {
            # actually rename the files
            file.rename(orginal_path, new_path)
            if (verbose) {print('File renamed')}
        }
    }
}
