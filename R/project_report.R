# .find_data_files <- function(data_path,
#                              data_files_ignore_folder,
#                              data_file_extensions,
#                              data_case_sensitive){
#     data_files_pattern <- paste(data_file_extensions, '$', sep = '')
#     pattern <- paste(data_files_pattern, collapse = '|')
#
#     data_files <- list.files(data_path,
#                              pattern = pattern,
#                              full.names = TRUE,
#                              recursive = TRUE,
#                              ignore.case = !data_case_sensitive)
#     return(data_files)
# }

.get_paths_to_ignore <- function(base_path, ignore_paths){
    current_dirs <- list.dirs(base_path, recursive = FALSE, full.names = FALSE)
    # print(current_dirs)
    current_dirs[!current_dirs %in% ignore_paths]
}

testthat::expect_equal(.get_paths_to_ignore('~/git/hub/sdal/sdalr/',
                                            c('.git', '.Rproj.user', 'man')),
                       c('data', 'R'))

.find_non_r_scripts <- function(script_path,
                                script_extensions){
    non_r_scripts <- list.files(script_path,
                                pattern = '([^r]$)',
                                full.names = TRUE,
                                recursive = TRUE,
                                ignore.case = TRUE)
    return(non_r_scripts)
}

# there should be non-r files in a non-r folder
testthat::expect_equal(.find_non_r_scripts('~/git/hub/sdal/sdalr/data',
                                           c('.git', '.Rproj.user', 'man')),
                       c("/home/dchen/git/hub/sdal/sdalr/data/anscombosaurus.csv",
                         "/home/dchen/git/hub/sdal/sdalr/data/anscombosaurus.RData")
)


# only rscripts in the R folder
testthat::expect_equal(.find_non_r_scripts('~/git/hub/sdal/sdalr/R',
                                           c('.git', '.Rproj.user', 'man')),
                       vector(mode = 'character')
)

project_path <- '~/git/hub/sdal/sdalr'
i <- c('.git', '.Rproj.user', 'R', 'man')
folders_to_use <- .get_paths_to_ignore(project_path, i)

non_r_scripts <- c()
for (f in folders_to_use) {
    non_r_scripts <- c(non_r_scripts,
                       .find_non_r_scripts(f, script_extensions = 'r'))
}

testthat::expect_equal(non_r_scripts,
                       c("data/anscombosaurus.csv",
                         "data/anscombosaurus.RData")
)


.get_project_report_data <- function(project_path,
                                     non_r_ignore_folder,
                                     data_files_ignore_folder,
                                     data_file_extensions,
                                     data_case_sensitive,
                                     script_extensions){
    src_path <- normalizePath(sprintf('%s/%s',
                                      project_path, non_r_ignore_folder))
    data_path <- normalizePath(sprintf('%s/%s',
                                       project_path, data_files_ignore_folder))
    cwd <- getwd()

    rproj_file <- list.files(path = '.', pattern = '*rproj$', ignore.case = TRUE)
    exists_rproj <- length(rproj_file) > 0

    i <- c('.git', '.Rproj.user', 'R')
    folders_to_use <- .get_paths_to_ignore(project_path, i)

    non_r_scripts <- c()
    for (f in folders_to_use){
        non_r_scripts <- c(non_r_scripts,
                           .find_non_r_scripts(f, script_extensions = 'r'))
    }
    non_r_scripts

    return(list(
        'cwd' = cwd,
        'rproj_file' = rproj_file,
        'exists_rproj' = exists_rproj,
        'src_path' = src_path,
        'data_path' = data_path,
        'non_r_scripts' = non_r_scripts,
        'data_files' = 42
    ))
}

project_report <- function(project_path,
                           script_folder='src',
                           data_folder='data',
                           script_extensions=c('r', 'rmd'),
                           data_file_extensions=c('rdata', 'csv'),
                           data_case_sensitive=FALSE,
                           dir_always_ignore = c('./.git', "./.Rproj.user")) {
    report_data <<- .get_project_report_data(
        project_path = project_path,
        non_r_ignore_folder = script_folder,
        data_files_ignore_folder = data_folder,
        data_file_extensions = data_file_extensions,
        data_case_sensitive = data_case_sensitive,
        script_extensions = script_extensions
    )

    cat(sprintf("
Current working directory:             %s
Current rproject:                      %s
Does rproj file exist here:            %s
Looking for R scripts in:              %s
Looking for data in:                   %s

R script extensions: (TODO)            %s
R scripts found in no script folders:\n%s

Data extensions: (TODO)                %s
Data found in non data folders:      \n%s
",
                report_data$cwd,
                report_data$rproj_file,
                report_data$exists_rproj,
                report_data$src_path,
                report_data$data_path,
                paste(script_extensions, collapse = " "),
                paste(report_data$non_r_scripts, collapse = "\n"),
                paste(data_file_extensions, collapse = " "),
                paste(report_data$data_files, collapse = "\n")



    ))
}

project_report('~/temp/test_project_report/')
