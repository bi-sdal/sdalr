#' Makes a connection to a database.
#'
#' Creates a connection to a database.
#' This function is really a high-level function that calls the corresponding
#' \code{con_db} function for a particular database driver.
#'
#' @param dbname the name of the database you want to connect to, defaults to current user
#' @param user the username for the database connection, defaults to current user
#' @param driver the database driver to use, defaults to 'PostgreSQL'
#' @param host where the database is running, defaults to 'postgresql (the docker container name)'
#' @param port the port where the database in running, defaults to '5432' for PostgreSQL
#' @param close_existing_cons whether to close existing database connections, defaults to 'TRUE'.
#'                            You need to set this to FALSE if
#'                            you are planning to make simultaneous database connections.
#' @param pass optional, defaults to NULL.
#'             If .dbpass exists in users home directory, password will be read from file (not advised).
#'             It will then try to run the `sdalr::get_my_password()` function,
#'             if that fails it will prompt the user for a password.
#'             You can also directly pass in a password as a string (not advised).
#' @return database connection
#' @export
#' @examples
#' con_db('sample_db', 'dan', 'isawesome')
#'
#' \dontrun{
#' con <- sdalr::con_db(dbname = 'arlington', user = 'chend')
#' df <- DBI::dbGetQuery(con, "SELECT * FROM fire.medic_unit_movement_summary_2013")
#' head(df)
#' }
con_db <- function(dbname = Sys.getenv("LOGNAME"), user = Sys.getenv("LOGNAME"), driver = 'PostgreSQL',
                   host = 'postgresql', port = 5432, close_existing_cons = TRUE,
                   pass = NULL) {

  # try to guess password if nothing is passed in
  if (is.null(pass)) {
    if (file.exists(sprintf("/home/%s/.dbpass", Sys.getenv("LOGNAME")))) {
      warning('You are storing a plain text file as your password,
              please run sdalr::setup_user_pass() or sdalr::update_user_pass(),
              and delete the ~/.dbpass file.')
      pass <- readLines(sprintf("/home/%s/.dbpass", Sys.getenv("LOGNAME")))
    } else if (!is.na(get_my_password())) {
      pass <- get_my_password()
    } else {
      pass <- getPass("LDAP Password (the one you use to login to Lightfoot and RStudio):")
    }
  } else {
    user <- user
    pass <- pass
  }

  # create the database connection
  if (driver == 'PostgreSQL') {
    sdalr::con_db_postgresql(dbname, user, pass, host, port, close_existing_cons)
  } else{
    stop("Unknown driver")
  }
}

#' Makes a connection to a postgresql database
#' @return postgresql database connection
#' @export
con_db_postgresql <- function(dbname, user, pass, host, port, close_existing_cons) {
  drv <- RPostgreSQL::PostgreSQL()

  if (close_existing_cons) {
    all_cons <- RPostgreSQL::dbListConnections(drv)
    for (con in all_cons) {RPostgreSQL::dbDisconnect(con)}
  }

  params <- list(drv = drv,
                 dbname = dbname,
                 host = host,
                 port = port,
                 user = user,
                 password = pass)

  # create connection
  con <- do.call(DBI::dbConnect, params)
  return(con)
}
