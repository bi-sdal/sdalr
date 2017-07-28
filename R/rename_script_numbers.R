library(stringr)

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

rename_script_numbers <- function(path, number_match_pattern, pad_width,
                                  rfile_pattern = '*.[rR]$',
                                  dry_run = TRUE,
                                  verbose=TRUE) {
    files <- list.files(path = path, pattern = rfile_pattern, full.names = TRUE)
    for (fn in files) {

        original_fn <- basename(fn)
        new_fn <- renumber_file(file_name = original_fn, number_match_pattern = number_match_pattern,
                                pad_width = pad_width, verbose = verbose)
        if (verbose) {
            print(sprintf('renaming file FROM: %s --------> TO: %s', original_fn, new_fn))
        }

        if (dry_run) {
            # don't actually do anything, just print
        } else {
            # actually rename the files
            file.rename(original_fn, new_fn)
            if (verbose) {print('File renamed')}
        }
    }
}
