#' Makes a connection to a database.
#'
#' Creates a connection to a database.
#' This function is really a high-level function that calls the corresponding
#' \code{con_db} function for a particular database driver.
#'
#' @param db the name of the database you want to connect to
#' @param user the username for the database connection
#' @param pass the password for the database connection
#' @param driver the database driver to use, defaults to 'PostgreSQL'
#' @param host where the database is running, defaults to 'localhost'
#' @param port the port where the database in running, defaults to '5432'
#' @param close_existing_cons whether to close existing database connections, defaults to 'TRUE'
#' @return a database connection
#' @export
#' @examples
#' con_db('sample_db', 'dan', 'isawesome')
con_db <- function(db, user, pass, driver = 'PostgreSQL',
                   host = 'localhost', port = 5432, close_existing_cons = TRUE) {
    if (driver == 'PostgreSQL') {
        con_db_postgresql(db, user, pass, host, port, close_existing_cons)
    } else{
        stop("Unknown driver")
    }

}

con_db_postgresql <- function(db, user, pass, host, port, close_existing_cons) {
    drv <- RPostgreSQL::dbDriver("PostgreSQL")

    if (close_existing_cons) {
        all_cons <- RPostgreSQL::dbListConnections(drv)
        for (con in all_cons) {RPostgreSQL::dbDisconnect(con)}
    }

    con <- RPostgreSQL::dbConnect(drv, dbname = db,
                                  host = host, port = port,
                                  user = user, password = pass)
    return(con)
}
