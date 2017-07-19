.get_all_files <- function(proj_dir) {
    return(list.files(path = proj_dir, all.files = TRUE, recursive = TRUE))
}

.get_dir_files <- function(folder) {
    return(list.files(path = folder, all.files = TRUE, no.. = TRUE))
}

check_proj_top_level <- function(proj_dir,
                                 should_contain_exactly = c('.git', '.gitignore', 'data', 'output', 'src'),
                                 should_contain_pattern = c('*.rproj$', '^readme*'),
                                 verbose = FALSE) {
    top_level_files <- .get_dir_files(proj_dir)

    all_exactly <- all(should_contain_exactly %in% top_level_files)

    pattern <- paste(should_contain_pattern, collapse = '|')
    found <- grep(pattern = pattern, x = top_level_files, ignore.case = TRUE)
    found_pattern <- length(found) == length(should_contain_pattern)

    all_pattern <- c(should_contain_exactly, should_contain_pattern)
    pattern <- paste(all_pattern, collapse = '|')
    found <- grepl(pattern = pattern, x = top_level_files, ignore.case = TRUE)
    unexpected <- top_level_files[!found]

    if (verbose) {
        cat('Files found in top level:\n', top_level_files, '\n')
        cat('Should contain these files/directories:\n ', should_contain_exactly, '\n')
        cat('These files/directories all found:\n', all_exactly, '\n')
        cat('Should contain these file/directory patterns:\n', pattern, '\n')
        cat('These files/directories all found:\n', found_pattern, '\n')
        cat('Unexpected in toplevel:\n', unexpected, '\n')
    }

    return(list(
        'top_level_files' = top_level_files,
        'should_contain_exactly' = should_contain_exactly,
        'all_exactly' = all_exactly,
        'pattern' = pattern,
        'found_pattern' = found_pattern,
        'unexpected' = unexpected
    ))
}

check_src_folder <- function(proj_dir,
                             r_files_patterns = c('*.r$', '*.rmd$'),
                             ignore_patterns = c('.gitignore', 'readme*', '*.py'),
                             data_patterns = c('*.csv$', '*.xls$', '*.xlsx$', '*.rdata$'),
                             pattern_ignore_case = TRUE,
                             verbose = FALSE) {
    src_path <- normalizePath(sprintf('%s/src', proj_dir))
    all_src_files <- .get_all_files(src_path)

    pattern_data <- paste(data_patterns, collapse = "|")
    found_data <- grepl(pattern_data, all_src_files, ignore.case = pattern_ignore_case)
    data_files_found <- all_src_files[found_data]

    belong_patterns <- c(r_files_patterns, ignore_patterns)
    r_and_data_patterns <- c(belong_patterns, data_patterns)
    pattern_maybe <- paste(r_and_data_patterns, collapse = '|')
    found <- grepl(pattern_maybe, all_src_files, ignore.case = pattern_ignore_case)
    maybe_belong <- all_src_files[!found]

    if (verbose) {
        print('These files most likely does not belong in the src folder:')
        print(maybe_belong)

        print("Found these data files (they definitely don't belong here):")
        print(data_files_found)
    }

    return(list(
        'maybe_belong' = maybe_belong,
        'data_files_found' = data_files_found
    ))
}

check_data_lvl_1 <- function(proj_dir,
                             ignore_patterns = c('^\\d{2}', '^readme'),
                             pattern_ignore_case = TRUE,
                             verbose = FALSE) {
    data_1_files <- .get_dir_files(normalizePath(sprintf('%s/data', proj_dir)))

    pattern <- paste(ignore_patterns, collapse = '|')
    found <- grepl(pattern, data_1_files, ignore.case = pattern_ignore_case)
    manual_check <- data_1_files[!found]

    if (verbose) {
        print("Check that these files belong in the top level data folder:")
        print(manual_check)
    }
    return(list(
        'manual_check' = manual_check
    ))
}

check_wd <- function(base_dir =  getwd(),
                     verbose = FALSE) {
    cwd <- base_dir
    current_dir_split <- stringr::str_split(cwd, '/')[[1]]
    current_dir <- current_dir_split[length(current_dir_split)]

    if (current_dir == "") {
        current_dir <- current_dir_split[length(current_dir_split) - 1]
    }

    current_rproj <- list.files(cwd, pattern = '*.rproj', ignore.case = TRUE)
    current_proj_split <- stringr::str_split(current_rproj, '\\.')[[1]]
    current_proj <- current_proj_split[1]

    is_match <- current_dir == current_proj

    if (verbose) {
        print("does current_dir match current_proj:")
        print(is_match)
    }

    return(list(
        'current_dir' = current_dir,
        'current_rproj' = current_rproj,
        'dir_proj_match' = is_match
    ))
}


# EXAMPLE_PATH <- '~/git/lab/dspg_17/oss'
# .get_dir_files(EXAMPLE_PATH)
#
# check_wd(EXAMPLE_PATH)
#
# check_proj_top_level(EXAMPLE_PATH)
# check_src_folder(EXAMPLE_PATH)
# check_data_lvl_1(EXAMPLE_PATH)


#'
#'@export
project_audit <- function(project_path = getwd(),
                          verbose = FALSE,
                          print_results = FALSE){
    # .get_dir_files(project_path)
    wd_status <- check_wd(project_path, verbose = verbose)
    proj_top_level_status <- check_proj_top_level(project_path, verbose = verbose)
    src_folder_status <- check_src_folder(project_path, verbose = verbose)
    data_lvl_1_status <- check_data_lvl_1(project_path, verbose = verbose)

    if (print_results) {
        print(wd_status)
        print(proj_top_level_status)
        print(src_folder_status)
        print(data_lvl_1_status)
    }

    cat("DIRECTORY REPORT\n")
    cat(sprintf("Current working directory:                               %s\n", getwd()))
    cat(sprintf("Performing Audit in:                                     %s\n", wd_status$current_dir))
    cat(sprintf("Current rproject:                                        %s\n", wd_status$current_rproj))
    cat(sprintf("Working directory matches rproject (should be TRUE):     %s\n", wd_status$dir_proj_match))
    cat('\n\n')
    cat(sprintf("Pattern used for top level project analysis:             %s\n", proj_top_level_status$pattern))
    cat(sprintf("Were all these files found (should be TRUE):             %s\n", proj_top_level_status$found_pattern))
    cat(sprintf("Please check that this file belongs in the top level:    %s\n", proj_top_level_status$unexpected))
    cat('\n\n')
    cat("SRC REPORT\n")
    cat(sprintf("Please check that this files belongs in the src folder:  %s\n", src_folder_status$maybe_belong))
    cat('\n')
    cat(sprintf("This data file definitely DOES NOT belong in src:        %s\n", src_folder_status$data_files_found))
    cat('\n\n')
    cat("DATA REPORT\n")
    cat(sprintf("Please check that these files belong in the data folder: %s\n", data_lvl_1_status$manual_check))
}

# project_audit(EXAMPLE_PATH, verbose = FALSE, print_results = FALSE)
