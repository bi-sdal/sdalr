
#' Load a compressed shapefile
#'
#' @param filepath path to the zip file
#' @param prefix prefix for the loaded shapefile when it is loaded in the environment
#' @param delete_unzip boolean on whether to delete the extracted zip file (default TRUE)
#' @param env environment where the file will be loaded into (default to .GlobalEnv)
#' @export
load_zipped_shapefile <- function(filepath, prefix, delete_unzip = TRUE, env = .GlobalEnv) {
    shapefilezip <- filepath
    var_prefix <- prefix
    unzip(shapefilezip, exdir = tools::file_path_sans_ext(shapefilezip))
    shp_file <- list.files(pattern = "\\.shp", path = tools::file_path_sans_ext(shapefilezip))[1]

    f <- paste0(tools::file_path_sans_ext(shapefilezip), "/", shp_file)
    spdf <- tmaptools::read_shape(file = f)

    assign(paste0(var_prefix, tolower(tools::file_path_sans_ext(basename(shapefilezip)))), spdf, envir = env)

    if (delete_unzip) {
        unlink(x = tools::file_path_sans_ext(shapefilezip), recursive = TRUE)
    }
}

#' Load all files in a directory into an environment with a given prefix
#'
#' @param shapefile_dir path to the directory of files
#' @param prefix prefix for the loaded shapefile when it is loaded in the environment
#' @param delete_unzip boolean on whether to delete the extracted zip files (default TRUE)
#' @param env environment where the file will be loaded into (default to .GlobalEnv)
#' @param verbose boolean on whether or not to print the file as they are being loaded (default TRUE)
#' @export
#' @examples
#' load_zipped_shapefiles("data/shapefiles/zip", "arl_")
#'
load_zipped_shapefiles <- function(shapefile_dir, prefix, delete_unzip = TRUE,
                                   env = .GlobalEnv, verbose = TRUE) {
    for (file in list.files(shapefile_dir, full.names = TRUE)) {

        if (verbose) {
            print(paste("Working on", file))
        }

        load_zipped_shapefile(file, prefix, delete_unzip, env)
    }
}
