#' Makes a connection to a database.
#'
#' Creates a connection to a database.
#' This function is really a high-level function that calls the corresponding
#' \code{con_db} function for a particular database driver.
#'
#' @param dbname the name of the database you want to connect to
#' @param user the username for the database connection
#' @param driver the database driver to use, defaults to 'PostgreSQL'
#' @param host where the database is running, defaults to 'postgresql'
#' @param port the port where the database in running, defaults to '5432' for PostgreSQL
#' @param close_existing_cons whether to close existing database connections, defaults to 'TRUE'
#' @return a database connection
#' @export
#' @examples
#' con_db('sample_db', 'dan', 'isawesome')
con_db <- function(dbname, user, driver = 'PostgreSQL',
                   host = 'postgresql', port = 5432, close_existing_cons = TRUE) {
    pass <- .rs.askForPassword("database password")
    if (driver == 'PostgreSQL') {
        sdalr::.con_db_postgresql(dbname, user, pass, host, port, close_existing_cons)
    } else{
        stop("Unknown driver")
    }

}

#' Makes a connection to a postgresql database
#' @export
.con_db_postgresql <- function(dbname, user, pass, host, port, close_existing_cons) {
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
